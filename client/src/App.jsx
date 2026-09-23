import React, { useState, useEffect } from 'react';
import { api } from './services/api';
import Navbar from './components/Navbar';
import Hero from './components/Hero';
import SearchBar from './components/SearchBar';
import BookCard from './components/BookCard';
import BookDetailModal from './components/BookDetailModal';
import ShelfView from './components/ShelfView';
import ReadingChallengeWidget from './components/ReadingChallengeWidget';
import StatsView from './components/StatsView';
import AddBookModal from './components/AddBookModal';
import Footer from './components/Footer';
import { BookOpen, CheckCircle, AlertCircle, Loader2 } from 'lucide-react';

export default function App() {
  const [activeTab, setActiveTab] = useState('catalog'); // 'catalog' | 'shelves' | 'challenge' | 'stats'
  const [books, setBooks] = useState([]);
  const [genres, setGenres] = useState([]);
  const [shelves, setShelves] = useState([]);
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(true);

  // Filters & Search
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedGenre, setSelectedGenre] = useState('Todos');
  const [sortBy, setSortBy] = useState('rating_desc');

  // Modals
  const [selectedBook, setSelectedBook] = useState(null);
  const [isAddBookOpen, setIsAddBookOpen] = useState(false);

  // Toast feedback
  const [toast, setToast] = useState(null);

  const showToast = (message, type = 'success') => {
    setToast({ message, type });
    setTimeout(() => {
      setToast(null);
    }, 3200);
  };

  // Load initial application data
  const loadInitialData = async () => {
    try {
      setLoading(true);
      const [booksData, genresData, shelvesData, statsData] = await Promise.all([
        api.getBooks(),
        api.getGenres(),
        api.getShelves(),
        api.getStats()
      ]);
      setBooks(booksData);
      setGenres(genresData);
      setShelves(shelvesData);
      setStats(statsData);
    } catch (err) {
      console.error('Error loading data:', err);
      showToast('Error conectando con el servidor BookHub', 'error');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadInitialData();
  }, []);

  // Filter & sort books dynamically
  const filteredBooks = books.filter(book => {
    const matchesSearch = 
      book.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
      book.author.toLowerCase().includes(searchQuery.toLowerCase()) ||
      (book.synopsis && book.synopsis.toLowerCase().includes(searchQuery.toLowerCase())) ||
      (book.tags && book.tags.some(t => t.toLowerCase().includes(searchQuery.toLowerCase())));

    const matchesGenre = selectedGenre === 'Todos' || book.genre.toLowerCase() === selectedGenre.toLowerCase();

    return matchesSearch && matchesGenre;
  }).sort((a, b) => {
    switch (sortBy) {
      case 'rating_desc':
        return b.rating - a.rating;
      case 'year_desc':
        return b.year - a.year;
      case 'pages_desc':
        return b.pages - a.pages;
      case 'pages_asc':
        return a.pages - b.pages;
      case 'title_asc':
        return a.title.localeCompare(b.title);
      default:
        return 0;
    }
  });

  const featuredBook = books.find(b => b.featured) || books[0];

  // Handlers
  const handleSelectBook = async (book) => {
    try {
      const detailedBook = await api.getBookById(book.id);
      setSelectedBook(detailedBook);
    } catch (err) {
      setSelectedBook(book);
    }
  };

  const handleUpdateShelf = async (shelfData) => {
    try {
      const res = await api.updateShelf(shelfData);
      // Refresh shelves and stats
      const [updatedShelves, updatedStats] = await Promise.all([
        api.getShelves(),
        api.getStats()
      ]);
      setShelves(updatedShelves);
      setStats(updatedStats);

      // If detailed modal is open, refresh its shelf status
      if (selectedBook && selectedBook.id === shelfData.bookId) {
        setSelectedBook(prev => ({
          ...prev,
          shelfStatus: res.item
        }));
      }

      const statusMap = {
        want_to_read: 'añadido a "Por leer"',
        reading: 'añadido a "Leyendo actualmente"',
        read: 'marcado como "Leído" 🎉'
      };
      showToast(`Libro ${statusMap[shelfData.status] || 'actualizado'}`);
    } catch (err) {
      console.error(err);
      showToast('Error al actualizar estantería', 'error');
    }
  };

  const handleRemoveFromShelf = async (bookId) => {
    try {
      await api.removeFromShelf(bookId);
      const [updatedShelves, updatedStats] = await Promise.all([
        api.getShelves(),
        api.getStats()
      ]);
      setShelves(updatedShelves);
      setStats(updatedStats);

      if (selectedBook && selectedBook.id === bookId) {
        setSelectedBook(prev => ({ ...prev, shelfStatus: null }));
      }
      showToast('Libro removido de tu estantería');
    } catch (err) {
      console.error(err);
      showToast('Error al eliminar libro', 'error');
    }
  };

  const handleAddReview = async (reviewData) => {
    try {
      const res = await api.createReview(reviewData);
      
      // Update books list rating
      setBooks(prev => prev.map(b => b.id === reviewData.bookId ? res.updatedBook : b));
      if (selectedBook && selectedBook.id === reviewData.bookId) {
        setSelectedBook(prev => ({
          ...prev,
          rating: res.updatedBook.rating,
          ratingsCount: res.updatedBook.ratingsCount
        }));
      }

      showToast('¡Reseña publicada con éxito!');
      return res;
    } catch (err) {
      console.error(err);
      showToast('Error al publicar reseña', 'error');
      throw err;
    }
  };

  const handleAddBook = async (bookData) => {
    try {
      const newBook = await api.createBook(bookData);
      setBooks(prev => [newBook, ...prev]);
      const updatedGenres = await api.getGenres();
      setGenres(updatedGenres);
      showToast(`"${newBook.title}" añadido al catálogo`);
    } catch (err) {
      console.error(err);
      showToast('Error al añadir libro', 'error');
    }
  };

  const handleUpdateChallenge = async (newGoal) => {
    try {
      await api.updateChallenge(newGoal);
      const updatedStats = await api.getStats();
      setStats(updatedStats);
      showToast(`Meta anual actualizada a ${newGoal} libros`);
    } catch (err) {
      console.error(err);
      showToast('Error al actualizar meta', 'error');
    }
  };

  return (
    <div className="min-h-screen flex flex-col bg-slate-50 text-slate-800">
      {/* Toast Notification */}
      {toast && (
        <div className="fixed bottom-6 right-6 z-50 flex items-center gap-2.5 px-4 py-3 rounded-2xl shadow-xl border bg-white border-slate-200 text-slate-800 animate-in slide-in-from-bottom-5">
          {toast.type === 'error' ? (
            <AlertCircle className="w-5 h-5 text-rose-500 shrink-0" />
          ) : (
            <CheckCircle className="w-5 h-5 text-emerald-500 shrink-0" />
          )}
          <span className="text-xs font-semibold">{toast.message}</span>
        </div>
      )}

      {/* Top Navbar */}
      <Navbar
        activeTab={activeTab}
        setActiveTab={setActiveTab}
        onOpenAddBook={() => setIsAddBookOpen(true)}
        shelfCount={shelves.length}
      />

      {/* Main Content Area */}
      <main className="flex-1 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full">
        {loading ? (
          <div className="flex flex-col items-center justify-center py-32 space-y-4">
            <Loader2 className="w-8 h-8 text-indigo-600 animate-spin" />
            <p className="text-sm font-medium text-slate-500">Cargando biblioteca de BookHub...</p>
          </div>
        ) : (
          <>
            {/* VIEW 1: CATALOG & EXPLORE */}
            {activeTab === 'catalog' && (
              <div className="space-y-8">
                {/* Hero with featured book */}
                <Hero
                  featuredBook={featuredBook}
                  onSelectBook={handleSelectBook}
                  onOpenAddBook={() => setIsAddBookOpen(true)}
                />

                {/* Search, Filter & Sort */}
                <div id="catalog-section">
                  <SearchBar
                    searchQuery={searchQuery}
                    setSearchQuery={setSearchQuery}
                    selectedGenre={selectedGenre}
                    setSelectedGenre={setSelectedGenre}
                    genres={genres}
                    sortBy={sortBy}
                    setSortBy={setSortBy}
                    resultsCount={filteredBooks.length}
                  />
                </div>

                {/* Books Grid */}
                {filteredBooks.length === 0 ? (
                  <div className="bg-white rounded-3xl border border-slate-200 p-12 text-center max-w-md mx-auto shadow-xs my-8">
                    <BookOpen className="w-12 h-12 text-slate-300 mx-auto mb-3" />
                    <h3 className="text-base font-serif font-bold text-slate-800">
                      No encontramos ningún libro coincidente
                    </h3>
                    <p className="text-xs text-slate-500 mt-1">
                      Intenta buscar por otro término o limpia los filtros de género.
                    </p>
                    <button
                      onClick={() => {
                        setSearchQuery('');
                        setSelectedGenre('Todos');
                      }}
                      className="mt-4 px-4 py-2 text-xs font-semibold text-indigo-600 hover:text-indigo-800 hover:bg-indigo-50 rounded-xl"
                    >
                      Restablecer filtros
                    </button>
                  </div>
                ) : (
                  <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-4 gap-4 sm:gap-6">
                    {filteredBooks.map((book) => {
                      const shelfItem = shelves.find(s => s.bookId === book.id);
                      return (
                        <BookCard
                          key={book.id}
                          book={book}
                          shelfItem={shelfItem}
                          onSelectBook={handleSelectBook}
                          onUpdateShelf={handleUpdateShelf}
                        />
                      );
                    })}
                  </div>
                )}
              </div>
            )}

            {/* VIEW 2: USER SHELVES */}
            {activeTab === 'shelves' && (
              <ShelfView
                shelves={shelves}
                onSelectBook={handleSelectBook}
                onUpdateShelf={handleUpdateShelf}
                onRemoveFromShelf={handleRemoveFromShelf}
                onGoToCatalog={() => setActiveTab('catalog')}
              />
            )}

            {/* VIEW 3: READING CHALLENGE */}
            {activeTab === 'challenge' && (
              <ReadingChallengeWidget
                challenge={stats?.challenge}
                readCount={stats?.readCount}
                onUpdateChallenge={handleUpdateChallenge}
              />
            )}

            {/* VIEW 4: READING STATS */}
            {activeTab === 'stats' && (
              <StatsView stats={stats} />
            )}
          </>
        )}
      </main>

      {/* Book Detail Modal */}
      {selectedBook && (
        <BookDetailModal
          book={selectedBook}
          shelfItem={shelves.find(s => s.bookId === selectedBook.id)}
          onClose={() => setSelectedBook(null)}
          onUpdateShelf={handleUpdateShelf}
          onRemoveFromShelf={handleRemoveFromShelf}
          onAddReview={handleAddReview}
        />
      )}

      {/* Add New Book Modal */}
      <AddBookModal
        isOpen={isAddBookOpen}
        onClose={() => setIsAddBookOpen(false)}
        onAddBook={handleAddBook}
        genres={genres}
      />

      {/* Footer */}
      <Footer />
    </div>
  );
}
