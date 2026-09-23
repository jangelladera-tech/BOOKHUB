const API_BASE = '/api';

export const api = {
  // Books
  async getBooks({ q = '', genre = '', sortBy = '', sortOrder = 'desc', featured = '' } = {}) {
    const params = new URLSearchParams();
    if (q) params.append('q', q);
    if (genre && genre !== 'Todos') params.append('genre', genre);
    if (sortBy) params.append('sortBy', sortBy);
    if (sortOrder) params.append('sortOrder', sortOrder);
    if (featured) params.append('featured', featured);

    const res = await fetch(`${API_BASE}/books?${params.toString()}`);
    if (!res.ok) throw new Error('Error al cargar libros');
    return res.json();
  },

  async getBookById(id) {
    const res = await fetch(`${API_BASE}/books/${id}`);
    if (!res.ok) throw new Error('Error al obtener información del libro');
    return res.json();
  },

  async createBook(bookData) {
    const res = await fetch(`${API_BASE}/books`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(bookData)
    });
    if (!res.ok) {
      const err = await res.json().catch(() => ({}));
      throw new Error(err.error || 'Error al guardar el libro');
    }
    return res.json();
  },

  async getGenres() {
    const res = await fetch(`${API_BASE}/genres`);
    if (!res.ok) throw new Error('Error al cargar géneros');
    return res.json();
  },

  // Shelves
  async getShelves(status = 'all') {
    const url = status && status !== 'all' ? `${API_BASE}/shelves?status=${status}` : `${API_BASE}/shelves`;
    const res = await fetch(url);
    if (!res.ok) throw new Error('Error al cargar estantería');
    return res.json();
  },

  async updateShelf({ bookId, status, currentPage = 0, notes = '', rating = null }) {
    const res = await fetch(`${API_BASE}/shelves`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ bookId, status, currentPage, notes, rating })
    });
    if (!res.ok) {
      const err = await res.json().catch(() => ({}));
      throw new Error(err.error || 'Error al actualizar estantería');
    }
    return res.json();
  },

  async removeFromShelf(bookId) {
    const res = await fetch(`${API_BASE}/shelves/${bookId}`, {
      method: 'DELETE'
    });
    if (!res.ok) throw new Error('Error al eliminar de la estantería');
    return res.json();
  },

  // Reviews
  async getReviews(bookId) {
    const res = await fetch(`${API_BASE}/reviews?bookId=${bookId}`);
    if (!res.ok) throw new Error('Error al cargar reseñas');
    return res.json();
  },

  async createReview({ bookId, userName, rating, comment }) {
    const res = await fetch(`${API_BASE}/reviews`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ bookId, userName, rating, comment })
    });
    if (!res.ok) {
      const err = await res.json().catch(() => ({}));
      throw new Error(err.error || 'Error al enviar reseña');
    }
    return res.json();
  },

  // Stats & Challenge
  async getStats() {
    const res = await fetch(`${API_BASE}/stats`);
    if (!res.ok) throw new Error('Error al obtener estadísticas');
    return res.json();
  },

  async updateChallenge(goal) {
    const res = await fetch(`${API_BASE}/challenge`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ goal })
    });
    if (!res.ok) {
      const err = await res.json().catch(() => ({}));
      throw new Error(err.error || 'Error al actualizar meta de lectura');
    }
    return res.json();
  }
};
