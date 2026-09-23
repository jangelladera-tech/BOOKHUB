import express from 'express';
import cors from 'cors';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

// Helper to read and write JSON files
const dataDir = path.join(__dirname, 'data');

const readJSON = (filename) => {
  const filePath = path.join(dataDir, filename);
  try {
    if (!fs.existsSync(filePath)) {
      return [];
    }
    const data = fs.readFileSync(filePath, 'utf-8');
    return JSON.parse(data);
  } catch (err) {
    console.error(`Error reading ${filename}:`, err);
    return [];
  }
};

const writeJSON = (filename, data) => {
  const filePath = path.join(dataDir, filename);
  try {
    fs.writeFileSync(filePath, JSON.stringify(data, null, 2), 'utf-8');
    return true;
  } catch (err) {
    console.error(`Error writing ${filename}:`, err);
    return false;
  }
};

// -------------------------------------------------------------
// BOOKS ENDPOINTS
// -------------------------------------------------------------

// GET /api/books - Search, filter by genre, and sort
app.get('/api/books', (req, res) => {
  const { q, genre, sortBy, sortOrder = 'desc', featured } = req.query;
  let books = readJSON('books.json');

  if (q) {
    const query = q.toLowerCase().trim();
    books = books.filter(b => 
      b.title.toLowerCase().includes(query) ||
      b.author.toLowerCase().includes(query) ||
      (b.synopsis && b.synopsis.toLowerCase().includes(query)) ||
      (b.tags && b.tags.some(t => t.toLowerCase().includes(query)))
    );
  }

  if (genre && genre !== 'Todos') {
    books = books.filter(b => b.genre.toLowerCase() === genre.toLowerCase());
  }

  if (featured === 'true') {
    books = books.filter(b => b.featured);
  }

  if (sortBy) {
    books.sort((a, b) => {
      let valA = a[sortBy];
      let valB = b[sortBy];

      if (typeof valA === 'string') {
        valA = valA.toLowerCase();
        valB = valB.toLowerCase();
        return sortOrder === 'asc' ? valA.localeCompare(valB) : valB.localeCompare(valA);
      }

      return sortOrder === 'asc' ? (valA - valB) : (valB - valA);
    });
  }

  res.json(books);
});

// GET /api/books/:id - Book detail with shelf status and reviews
app.get('/api/books/:id', (req, res) => {
  const books = readJSON('books.json');
  const book = books.find(b => b.id === req.params.id);

  if (!book) {
    return res.status(404).json({ error: 'Libro no encontrado' });
  }

  const reviews = readJSON('reviews.json').filter(r => r.bookId === book.id);
  const shelves = readJSON('shelves.json');
  const shelfEntry = shelves.find(s => s.bookId === book.id) || null;

  res.json({
    ...book,
    reviews,
    shelfStatus: shelfEntry
  });
});

// POST /api/books - Add a new book to the catalog
app.post('/api/books', (req, res) => {
  const { title, author, genre, pages, year, synopsis, cover, tags } = req.body;

  if (!title || !author) {
    return res.status(400).json({ error: 'Título y autor son obligatorios' });
  }

  const books = readJSON('books.json');
  const newBook = {
    id: `book-${Date.now()}`,
    title: title.trim(),
    author: author.trim(),
    genre: genre ? genre.trim() : 'General',
    rating: 5.0,
    ratingsCount: 1,
    pages: Number(pages) || 200,
    year: Number(year) || new Date().getFullYear(),
    isbn: `978-${Math.floor(1000000000 + Math.random() * 9000000000)}`,
    featured: false,
    cover: cover && cover.trim() !== '' 
      ? cover.trim() 
      : 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&q=80&w=600',
    synopsis: synopsis ? synopsis.trim() : 'Sin sinopsis disponible.',
    tags: Array.isArray(tags) ? tags : (tags ? tags.split(',').map(t => t.trim()) : ['Novedad'])
  };

  books.unshift(newBook);
  writeJSON('books.json', books);

  res.status(201).json(newBook);
});

// GET /api/genres - List of unique genres with book count
app.get('/api/genres', (req, res) => {
  const books = readJSON('books.json');
  const genreCount = {};

  books.forEach(b => {
    const g = b.genre || 'General';
    genreCount[g] = (genreCount[g] || 0) + 1;
  });

  const genres = Object.keys(genreCount).map(name => ({
    name,
    count: genreCount[name]
  })).sort((a, b) => b.count - a.count);

  res.json(genres);
});

// -------------------------------------------------------------
// SHELVES (ESTANTERÍAS DE LECTURA) ENDPOINTS
// -------------------------------------------------------------

// GET /api/shelves - Get user shelves with book details
app.get('/api/shelves', (req, res) => {
  const { status } = req.query;
  const shelves = readJSON('shelves.json');
  const books = readJSON('books.json');
  const booksMap = new Map(books.map(b => [b.id, b]));

  let enrichedShelves = shelves.map(item => ({
    ...item,
    book: booksMap.get(item.bookId) || null
  })).filter(item => item.book !== null);

  if (status && status !== 'all') {
    enrichedShelves = enrichedShelves.filter(item => item.status === status);
  }

  res.json(enrichedShelves);
});

// POST /api/shelves - Add or update a book in user shelves
app.post('/api/shelves', (req, res) => {
  const { bookId, status, currentPage = 0, notes = '', rating = null } = req.body;

  if (!bookId || !status) {
    return res.status(400).json({ error: 'bookId y status son requeridos' });
  }

  const shelves = readJSON('shelves.json');
  const books = readJSON('books.json');
  const book = books.find(b => b.id === bookId);

  if (!book) {
    return res.status(404).json({ error: 'Libro no encontrado' });
  }

  const existingIndex = shelves.findIndex(s => s.bookId === bookId);
  const updatedItem = {
    bookId,
    status, // 'want_to_read' | 'reading' | 'read'
    currentPage: status === 'read' ? book.pages : Math.min(Number(currentPage) || 0, book.pages),
    rating: rating !== null ? Number(rating) : (existingIndex >= 0 ? shelves[existingIndex].rating : null),
    notes: notes !== undefined ? notes : (existingIndex >= 0 ? shelves[existingIndex].notes : ''),
    updatedAt: new Date().toISOString().split('T')[0]
  };

  if (existingIndex >= 0) {
    shelves[existingIndex] = updatedItem;
  } else {
    shelves.unshift(updatedItem);
  }

  writeJSON('shelves.json', shelves);
  res.json({ success: true, item: { ...updatedItem, book } });
});

// DELETE /api/shelves/:bookId - Remove from shelf
app.delete('/api/shelves/:bookId', (req, res) => {
  const { bookId } = req.params;
  let shelves = readJSON('shelves.json');
  shelves = shelves.filter(s => s.bookId !== bookId);
  writeJSON('shelves.json', shelves);
  res.json({ success: true, message: 'Libro eliminado de tu estantería' });
});

// -------------------------------------------------------------
// REVIEWS ENDPOINTS
// -------------------------------------------------------------

// GET /api/reviews
app.get('/api/reviews', (req, res) => {
  const { bookId } = req.query;
  let reviews = readJSON('reviews.json');
  if (bookId) {
    reviews = reviews.filter(r => r.bookId === bookId);
  }
  res.json(reviews);
});

// POST /api/reviews - Add a new review and recalculate book rating
app.post('/api/reviews', (req, res) => {
  const { bookId, userName, rating, comment } = req.body;

  if (!bookId || !rating || !comment) {
    return res.status(400).json({ error: 'bookId, rating y comment son obligatorios' });
  }

  const reviews = readJSON('reviews.json');
  const books = readJSON('books.json');
  const bookIndex = books.findIndex(b => b.id === bookId);

  if (bookIndex === -1) {
    return res.status(404).json({ error: 'Libro no encontrado' });
  }

  const newReview = {
    id: `rev-${Date.now()}`,
    bookId,
    userName: userName ? userName.trim() : 'Lector BookHub',
    userAvatar: `https://api.dicebear.com/7.x/avataaars/svg?seed=${encodeURIComponent(userName || 'BookLover')}`,
    rating: Math.max(1, Math.min(5, Number(rating))),
    date: new Date().toISOString().split('T')[0],
    comment: comment.trim()
  };

  reviews.unshift(newReview);
  writeJSON('reviews.json', reviews);

  // Recalculate book rating
  const bookReviews = reviews.filter(r => r.bookId === bookId);
  const avgRating = (bookReviews.reduce((sum, r) => sum + r.rating, 0) / bookReviews.length).toFixed(1);
  books[bookIndex].rating = parseFloat(avgRating);
  books[bookIndex].ratingsCount = bookReviews.length;
  writeJSON('books.json', books);

  res.status(201).json({ review: newReview, updatedBook: books[bookIndex] });
});

// -------------------------------------------------------------
// STATS & READING CHALLENGE ENDPOINTS
// -------------------------------------------------------------

// GET /api/stats - Global reading statistics
app.get('/api/stats', (req, res) => {
  const shelves = readJSON('shelves.json');
  const books = readJSON('books.json');
  const challenge = readJSON('challenge.json');
  const booksMap = new Map(books.map(b => [b.id, b]));

  let totalPagesRead = 0;
  let readCount = 0;
  let readingCount = 0;
  let wantToReadCount = 0;
  const genreCounts = {};

  shelves.forEach(item => {
    const book = booksMap.get(item.bookId);
    if (!book) return;

    if (item.status === 'read') {
      readCount++;
      totalPagesRead += book.pages || 0;
      const g = book.genre || 'General';
      genreCounts[g] = (genreCounts[g] || 0) + 1;
    } else if (item.status === 'reading') {
      readingCount++;
      totalPagesRead += (item.currentPage || 0);
    } else if (item.status === 'want_to_read') {
      wantToReadCount++;
    }
  });

  let favoriteGenre = 'Ninguno todavía';
  let maxGenreCount = 0;
  for (const [genre, count] of Object.entries(genreCounts)) {
    if (count > maxGenreCount) {
      maxGenreCount = count;
      favoriteGenre = genre;
    }
  }

  const goal = challenge.goal || 20;
  const percentage = Math.min(100, Math.round((readCount / goal) * 100));

  res.json({
    readCount,
    readingCount,
    wantToReadCount,
    totalPagesRead,
    favoriteGenre,
    challenge: {
      year: challenge.year || new Date().getFullYear(),
      goal,
      completed: readCount,
      percentage,
      remaining: Math.max(0, goal - readCount)
    }
  });
});

// PUT /api/challenge - Update reading challenge goal
app.put('/api/challenge', (req, res) => {
  const { goal } = req.body;
  if (!goal || goal <= 0) {
    return res.status(400).json({ error: 'La meta debe ser un número mayor a cero' });
  }

  const challenge = readJSON('challenge.json');
  challenge.goal = Number(goal);
  writeJSON('challenge.json', challenge);

  res.json({ success: true, challenge });
});

// Server check
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', app: 'BookHub API', timestamp: new Date() });
});

app.listen(PORT, () => {
  console.log(`🚀 BookHub Server corriendo en http://localhost:${PORT}`);
});
