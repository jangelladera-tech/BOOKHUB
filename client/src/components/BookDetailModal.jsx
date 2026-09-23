import React, { useState, useEffect } from 'react';
import { 
  X, Star, Bookmark, BookOpen, Check, Trash2, MessageSquare, 
  Send, Calendar, FileText, Hash, Tag, Sparkles 
} from 'lucide-react';

export default function BookDetailModal({ 
  book, 
  shelfItem, 
  onClose, 
  onUpdateShelf, 
  onRemoveFromShelf, 
  onAddReview 
}) {
  const [activeTab, setActiveTab] = useState('info'); // 'info' | 'reviews'
  const [status, setStatus] = useState(shelfItem?.status || '');
  const [currentPage, setCurrentPage] = useState(shelfItem?.currentPage || 0);
  const [notes, setNotes] = useState(shelfItem?.notes || '');
  const [shelfSaving, setShelfSaving] = useState(false);

  // New review state
  const [userName, setUserName] = useState('');
  const [rating, setRating] = useState(5);
  const [hoverRating, setHoverRating] = useState(0);
  const [comment, setComment] = useState('');
  const [submittingReview, setSubmittingReview] = useState(false);
  const [reviewsList, setReviewsList] = useState(book?.reviews || []);

  useEffect(() => {
    if (shelfItem) {
      setStatus(shelfItem.status || '');
      setCurrentPage(shelfItem.currentPage || 0);
      setNotes(shelfItem.notes || '');
    } else {
      setStatus('');
      setCurrentPage(0);
      setNotes('');
    }
  }, [shelfItem]);

  useEffect(() => {
    setReviewsList(book?.reviews || []);
  }, [book]);

  // Handle escape key
  useEffect(() => {
    const handleKeyDown = (e) => {
      if (e.key === 'Escape') onClose();
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [onClose]);

  if (!book) return null;

  const handleSaveShelf = async (newStatus) => {
    setShelfSaving(true);
    const targetStatus = newStatus || status || 'want_to_read';
    setStatus(targetStatus);
    await onUpdateShelf({
      bookId: book.id,
      status: targetStatus,
      currentPage: targetStatus === 'read' ? book.pages : currentPage,
      notes
    });
    setShelfSaving(false);
  };

  const handlePageUpdate = async (e) => {
    e.preventDefault();
    setShelfSaving(true);
    await onUpdateShelf({
      bookId: book.id,
      status: status || 'reading',
      currentPage: Number(currentPage),
      notes
    });
    setShelfSaving(false);
  };

  const handleSubmitReview = async (e) => {
    e.preventDefault();
    if (!comment.trim()) return;

    setSubmittingReview(true);
    try {
      const res = await onAddReview({
        bookId: book.id,
        userName: userName.trim() || 'Lector Apasionado',
        rating,
        comment: comment.trim()
      });

      if (res?.review) {
        setReviewsList(prev => [res.review, ...prev]);
        setComment('');
        setRating(5);
      }
    } catch (err) {
      console.error(err);
    } finally {
      setSubmittingReview(false);
    }
  };

  const readPercentage = Math.min(100, Math.round(((currentPage || 0) / (book.pages || 1)) * 100));

  return (
    <div className="fixed inset-0 z-50 overflow-y-auto bg-slate-900/60 backdrop-blur-sm flex items-center justify-center p-4 sm:p-6 animate-in fade-in duration-200">
      <div 
        className="relative bg-white w-full max-w-4xl rounded-3xl shadow-2xl border border-slate-200 overflow-hidden flex flex-col max-h-[90vh]"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Header bar */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-slate-100 bg-slate-50/50">
          <div className="flex items-center gap-2">
            <span className="px-3 py-1 text-xs font-semibold rounded-full bg-indigo-100 text-indigo-800">
              {book.genre}
            </span>
            {book.featured && (
              <span className="inline-flex items-center gap-1 px-3 py-1 text-xs font-semibold rounded-full bg-amber-100 text-amber-800">
                <Sparkles className="w-3 h-3 text-amber-500" />
                Destacado
              </span>
            )}
          </div>
          <button
            onClick={onClose}
            className="p-2 rounded-xl text-slate-400 hover:text-slate-700 hover:bg-slate-200/60 transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Modal Body */}
        <div className="overflow-y-auto p-6 flex-1 space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-12 gap-8">
            {/* Left: Book Cover and Quick Shelf Actions */}
            <div className="md:col-span-4 flex flex-col items-center">
              <div className="relative aspect-[3/4] w-48 sm:w-56 rounded-2xl overflow-hidden shadow-2xl border border-slate-100">
                <img
                  src={book.cover}
                  alt={book.title}
                  className="w-full h-full object-cover"
                  onError={(e) => {
                    e.target.src = 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&q=80&w=600';
                  }}
                />
              </div>

              {/* Status Selector */}
              <div className="w-full mt-6 space-y-2">
                <label className="text-xs font-bold text-slate-500 uppercase tracking-wider block text-center">
                  Estado en tu estantería
                </label>
                <div className="grid grid-cols-3 gap-1.5 p-1 bg-slate-100 rounded-xl">
                  <button
                    onClick={() => handleSaveShelf('want_to_read')}
                    className={`py-2 text-xs font-medium rounded-lg flex flex-col items-center gap-1 transition-all ${
                      status === 'want_to_read'
                        ? 'bg-white text-indigo-700 font-bold shadow-sm'
                        : 'text-slate-600 hover:text-slate-900'
                    }`}
                  >
                    <Bookmark className="w-4 h-4" />
                    <span>Por leer</span>
                  </button>

                  <button
                    onClick={() => handleSaveShelf('reading')}
                    className={`py-2 text-xs font-medium rounded-lg flex flex-col items-center gap-1 transition-all ${
                      status === 'reading'
                        ? 'bg-white text-amber-700 font-bold shadow-sm'
                        : 'text-slate-600 hover:text-slate-900'
                    }`}
                  >
                    <BookOpen className="w-4 h-4" />
                    <span>Leyendo</span>
                  </button>

                  <button
                    onClick={() => handleSaveShelf('read')}
                    className={`py-2 text-xs font-medium rounded-lg flex flex-col items-center gap-1 transition-all ${
                      status === 'read'
                        ? 'bg-white text-emerald-700 font-bold shadow-sm'
                        : 'text-slate-600 hover:text-slate-900'
                    }`}
                  >
                    <Check className="w-4 h-4" />
                    <span>Leído</span>
                  </button>
                </div>

                {shelfItem && (
                  <button
                    onClick={() => onRemoveFromShelf(book.id)}
                    className="w-full py-1.5 text-xs text-rose-500 hover:text-rose-700 hover:bg-rose-50 rounded-lg flex items-center justify-center gap-1.5 transition-colors mt-2"
                  >
                    <Trash2 className="w-3.5 h-3.5" />
                    <span>Quitar de mi estantería</span>
                  </button>
                )}
              </div>

              {/* Progress Tracker (If currently reading) */}
              {status === 'reading' && (
                <div className="w-full mt-4 p-4 bg-amber-50/70 border border-amber-200/70 rounded-2xl">
                  <div className="flex items-center justify-between text-xs font-bold text-amber-900 mb-1.5">
                    <span>Progreso de lectura</span>
                    <span>{readPercentage}%</span>
                  </div>
                  <div className="w-full h-2.5 bg-amber-200/50 rounded-full overflow-hidden">
                    <div 
                      className="h-full bg-amber-500 rounded-full transition-all duration-300"
                      style={{ width: `${readPercentage}%` }}
                    />
                  </div>
                  <form onSubmit={handlePageUpdate} className="mt-3 flex items-center gap-2">
                    <input
                      type="number"
                      min="0"
                      max={book.pages}
                      value={currentPage}
                      onChange={(e) => setCurrentPage(e.target.value)}
                      className="w-20 px-2 py-1 text-xs border border-amber-300 rounded-lg bg-white text-slate-900 font-semibold focus:outline-none focus:ring-2 focus:ring-amber-500"
                    />
                    <span className="text-xs text-amber-800">de {book.pages} págs</span>
                    <button
                      type="submit"
                      disabled={shelfSaving}
                      className="ml-auto px-2.5 py-1 text-xs bg-amber-600 hover:bg-amber-700 text-white rounded-lg font-medium transition-colors"
                    >
                      Actualizar
                    </button>
                  </form>
                </div>
              )}
            </div>

            {/* Right: Book Details & Tabs */}
            <div className="md:col-span-8 flex flex-col">
              <div>
                <h1 className="text-2xl sm:text-3xl font-serif font-bold text-slate-900 leading-tight">
                  {book.title}
                </h1>
                <p className="text-base text-indigo-600 font-semibold mt-1">
                  por {book.author}
                </p>

                {/* Rating badge */}
                <div className="flex items-center gap-2 mt-3">
                  <div className="flex text-amber-400">
                    {[...Array(5)].map((_, i) => (
                      <Star
                        key={i}
                        className={`w-4 h-4 ${
                          i < Math.floor(book.rating)
                            ? 'fill-amber-400 text-amber-400'
                            : i < book.rating
                            ? 'fill-amber-400/50 text-amber-400'
                            : 'text-slate-200'
                        }`}
                      />
                    ))}
                  </div>
                  <span className="text-sm font-bold text-slate-800">{book.rating}</span>
                  <span className="text-xs text-slate-400">({reviewsList.length} valoraciones en la comunidad)</span>
                </div>

                {/* Metadata Pills */}
                <div className="grid grid-cols-2 sm:grid-cols-4 gap-2.5 mt-5">
                  <div className="p-2.5 bg-slate-50 rounded-xl border border-slate-100 flex items-center gap-2">
                    <FileText className="w-4 h-4 text-slate-400" />
                    <div>
                      <div className="text-[10px] text-slate-400 font-medium">Páginas</div>
                      <div className="text-xs font-bold text-slate-700">{book.pages}</div>
                    </div>
                  </div>

                  <div className="p-2.5 bg-slate-50 rounded-xl border border-slate-100 flex items-center gap-2">
                    <Calendar className="w-4 h-4 text-slate-400" />
                    <div>
                      <div className="text-[10px] text-slate-400 font-medium">Año</div>
                      <div className="text-xs font-bold text-slate-700">{book.year}</div>
                    </div>
                  </div>

                  <div className="p-2.5 bg-slate-50 rounded-xl border border-slate-100 flex items-center gap-2">
                    <Hash className="w-4 h-4 text-slate-400" />
                    <div>
                      <div className="text-[10px] text-slate-400 font-medium">ISBN</div>
                      <div className="text-xs font-bold text-slate-700 truncate max-w-[80px]">{book.isbn}</div>
                    </div>
                  </div>

                  <div className="p-2.5 bg-slate-50 rounded-xl border border-slate-100 flex items-center gap-2">
                    <Tag className="w-4 h-4 text-slate-400" />
                    <div>
                      <div className="text-[10px] text-slate-400 font-medium">Género</div>
                      <div className="text-xs font-bold text-slate-700 truncate">{book.genre}</div>
                    </div>
                  </div>
                </div>
              </div>

              {/* Tabs for Info vs Reviews */}
              <div className="flex border-b border-slate-200 mt-6">
                <button
                  onClick={() => setActiveTab('info')}
                  className={`pb-3 text-sm font-semibold transition-colors relative mr-6 ${
                    activeTab === 'info'
                      ? 'text-indigo-600 border-b-2 border-indigo-600'
                      : 'text-slate-500 hover:text-slate-800'
                  }`}
                >
                  Sinopsis y Notas
                </button>
                <button
                  onClick={() => setActiveTab('reviews')}
                  className={`pb-3 text-sm font-semibold transition-colors relative flex items-center gap-1.5 ${
                    activeTab === 'reviews'
                      ? 'text-indigo-600 border-b-2 border-indigo-600'
                      : 'text-slate-500 hover:text-slate-800'
                  }`}
                >
                  <MessageSquare className="w-4 h-4" />
                  <span>Reseñas de la Comunidad ({reviewsList.length})</span>
                </button>
              </div>

              {/* Tab 1: Info & Notes */}
              {activeTab === 'info' && (
                <div className="py-4 space-y-5">
                  <div>
                    <h3 className="text-sm font-bold text-slate-800 mb-2">Sinopsis</h3>
                    <p className="text-sm text-slate-600 leading-relaxed font-normal">
                      {book.synopsis}
                    </p>
                  </div>

                  {book.tags && book.tags.length > 0 && (
                    <div>
                      <h4 className="text-xs font-bold text-slate-500 uppercase tracking-wider mb-2">
                        Etiquetas
                      </h4>
                      <div className="flex flex-wrap gap-1.5">
                        {book.tags.map((tag, idx) => (
                          <span
                            key={idx}
                            className="px-2.5 py-1 text-xs rounded-lg bg-slate-100 text-slate-600 font-medium"
                          >
                            #{tag}
                          </span>
                        ))}
                      </div>
                    </div>
                  )}

                  {/* Personal notes section */}
                  {shelfItem && (
                    <div className="pt-2">
                      <div className="flex items-center justify-between mb-1.5">
                        <label className="text-xs font-bold text-slate-700">
                          Tus notas personales de lectura
                        </label>
                        <button
                          onClick={() => handleSaveShelf()}
                          disabled={shelfSaving}
                          className="text-xs text-indigo-600 hover:text-indigo-800 font-semibold"
                        >
                          Guardar notas
                        </button>
                      </div>
                      <textarea
                        value={notes}
                        onChange={(e) => setNotes(e.target.value)}
                        placeholder="Escribe tus citas favoritas, reflexiones o momentos memorables de este libro..."
                        rows={3}
                        className="w-full text-xs p-3 rounded-xl border border-slate-200 focus:outline-none focus:ring-2 focus:ring-indigo-500"
                      />
                    </div>
                  )}
                </div>
              )}

              {/* Tab 2: Reviews */}
              {activeTab === 'reviews' && (
                <div className="py-4 space-y-6">
                  {/* Add Review Form */}
                  <form onSubmit={handleSubmitReview} className="p-4 bg-slate-50 rounded-2xl border border-slate-200 space-y-3">
                    <h4 className="text-xs font-bold text-slate-800 uppercase tracking-wider">
                      ¿Ya lo leíste? Deja tu opinión
                    </h4>

                    {/* Star selector */}
                    <div className="flex items-center gap-3">
                      <span className="text-xs text-slate-600 font-medium">Tu puntuación:</span>
                      <div className="flex text-amber-400">
                        {[1, 2, 3, 4, 5].map((starVal) => (
                          <button
                            type="button"
                            key={starVal}
                            onClick={() => setRating(starVal)}
                            onMouseEnter={() => setHoverRating(starVal)}
                            onMouseLeave={() => setHoverRating(0)}
                            className="p-1 hover:scale-110 transition-transform"
                          >
                            <Star
                              className={`w-5 h-5 ${
                                starVal <= (hoverRating || rating)
                                  ? 'fill-amber-400 text-amber-400'
                                  : 'text-slate-300'
                              }`}
                            />
                          </button>
                        ))}
                      </div>
                      <span className="text-xs font-bold text-amber-600">{hoverRating || rating} de 5</span>
                    </div>

                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                      <input
                        type="text"
                        placeholder="Tu nombre (ej. Santiago P.)"
                        value={userName}
                        onChange={(e) => setUserName(e.target.value)}
                        className="w-full px-3 py-2 text-xs rounded-xl border border-slate-200 bg-white focus:outline-none focus:ring-2 focus:ring-indigo-500"
                      />
                    </div>

                    <textarea
                      placeholder="Escribe tu reseña honesta para otros lectores..."
                      value={comment}
                      onChange={(e) => setComment(e.target.value)}
                      rows={2}
                      required
                      className="w-full p-3 text-xs rounded-xl border border-slate-200 bg-white focus:outline-none focus:ring-2 focus:ring-indigo-500"
                    />

                    <div className="flex justify-end">
                      <button
                        type="submit"
                        disabled={submittingReview || !comment.trim()}
                        className="flex items-center gap-1.5 px-4 py-2 bg-indigo-600 hover:bg-indigo-700 disabled:opacity-50 text-white text-xs font-semibold rounded-xl shadow-sm transition-all"
                      >
                        <Send className="w-3.5 h-3.5" />
                        <span>Publicar reseña</span>
                      </button>
                    </div>
                  </form>

                  {/* List of reviews */}
                  <div className="space-y-3">
                    {reviewsList.length === 0 ? (
                      <p className="text-center text-xs text-slate-400 py-6">
                        Aún no hay reseñas para este libro. ¡Sé el primero en compartir tu experiencia!
                      </p>
                    ) : (
                      reviewsList.map((rev) => (
                        <div key={rev.id} className="p-4 rounded-xl bg-white border border-slate-100 shadow-sm space-y-2">
                          <div className="flex items-center justify-between">
                            <div className="flex items-center gap-2.5">
                              <img
                                src={rev.userAvatar || `https://api.dicebear.com/7.x/avataaars/svg?seed=${encodeURIComponent(rev.userName)}`}
                                alt={rev.userName}
                                className="w-8 h-8 rounded-full border border-slate-200"
                              />
                              <div>
                                <span className="text-xs font-bold text-slate-800 block">{rev.userName}</span>
                                <span className="text-[10px] text-slate-400">{rev.date}</span>
                              </div>
                            </div>
                            <div className="flex text-amber-400">
                              {[...Array(5)].map((_, i) => (
                                <Star
                                  key={i}
                                  className={`w-3.5 h-3.5 ${
                                    i < rev.rating ? 'fill-amber-400 text-amber-400' : 'text-slate-200'
                                  }`}
                                />
                              ))}
                            </div>
                          </div>
                          <p className="text-xs text-slate-600 leading-relaxed font-normal">
                            {rev.comment}
                          </p>
                        </div>
                      ))
                    )}
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
