import React, { useState } from 'react';
import { 
  BookOpen, Bookmark, Check, Trash2, ArrowRight, Star, 
  Plus, Sparkles, BookMarked, Filter 
} from 'lucide-react';

export default function ShelfView({ 
  shelves, 
  onSelectBook, 
  onUpdateShelf, 
  onRemoveFromShelf, 
  onGoToCatalog 
}) {
  const [shelfFilter, setShelfFilter] = useState('all'); // 'all' | 'reading' | 'want_to_read' | 'read'

  const filteredShelves = shelves.filter(item => {
    if (shelfFilter === 'all') return true;
    return item.status === shelfFilter;
  });

  const readingCount = shelves.filter(s => s.status === 'reading').length;
  const wantCount = shelves.filter(s => s.status === 'want_to_read').length;
  const readCount = shelves.filter(s => s.status === 'read').length;

  return (
    <div className="space-y-6">
      {/* Top Banner & Header */}
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 bg-white p-6 rounded-3xl border border-slate-200 shadow-sm">
        <div>
          <h2 className="text-2xl font-serif font-bold text-slate-900">
            Mis Estanterías
          </h2>
          <p className="text-sm text-slate-500 mt-1">
            Organiza tus lecturas actuales, tu lista de pendientes y los libros completados.
          </p>
        </div>

        <button
          onClick={onGoToCatalog}
          className="inline-flex items-center gap-2 px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-semibold rounded-xl shadow-sm transition-all"
        >
          <Plus className="w-4 h-4" />
          <span>Explorar más libros</span>
        </button>
      </div>

      {/* Tabs Filter */}
      <div className="flex flex-wrap items-center gap-2 border-b border-slate-200 pb-3">
        <button
          onClick={() => setShelfFilter('all')}
          className={`flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-bold transition-all ${
            shelfFilter === 'all'
              ? 'bg-slate-900 text-white shadow-sm'
              : 'bg-white text-slate-600 hover:bg-slate-100 border border-slate-200'
          }`}
        >
          <BookMarked className="w-3.5 h-3.5" />
          <span>Todos ({shelves.length})</span>
        </button>

        <button
          onClick={() => setShelfFilter('reading')}
          className={`flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-bold transition-all ${
            shelfFilter === 'reading'
              ? 'bg-amber-600 text-white shadow-sm'
              : 'bg-white text-slate-600 hover:bg-slate-100 border border-slate-200'
          }`}
        >
          <BookOpen className="w-3.5 h-3.5" />
          <span>Leyendo ({readingCount})</span>
        </button>

        <button
          onClick={() => setShelfFilter('want_to_read')}
          className={`flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-bold transition-all ${
            shelfFilter === 'want_to_read'
              ? 'bg-indigo-600 text-white shadow-sm'
              : 'bg-white text-slate-600 hover:bg-slate-100 border border-slate-200'
          }`}
        >
          <Bookmark className="w-3.5 h-3.5" />
          <span>Por Leer ({wantCount})</span>
        </button>

        <button
          onClick={() => setShelfFilter('read')}
          className={`flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-bold transition-all ${
            shelfFilter === 'read'
              ? 'bg-emerald-600 text-white shadow-sm'
              : 'bg-white text-slate-600 hover:bg-slate-100 border border-slate-200'
          }`}
        >
          <Check className="w-3.5 h-3.5" />
          <span>Leídos ({readCount})</span>
        </button>
      </div>

      {/* Shelves List Grid */}
      {filteredShelves.length === 0 ? (
        <div className="bg-white rounded-3xl border border-slate-200 p-12 text-center max-w-lg mx-auto shadow-sm my-8">
          <div className="w-16 h-16 rounded-2xl bg-indigo-50 text-indigo-600 flex items-center justify-center mx-auto mb-4">
            <BookOpen className="w-8 h-8" />
          </div>
          <h3 className="text-lg font-serif font-bold text-slate-900">
            No tienes libros en esta sección
          </h3>
          <p className="text-xs text-slate-500 mt-2 max-w-sm mx-auto">
            {shelfFilter === 'reading' 
              ? 'No estás leyendo ningún libro ahora mismo. ¡Empieza uno hoy!'
              : shelfFilter === 'read'
              ? 'Aún no has marcado ningún libro como leído. ¡Completa tu primera lectura!'
              : 'Agrega títulos desde el catálogo para mantener tu biblioteca personal al día.'}
          </p>
          <button
            onClick={onGoToCatalog}
            className="mt-6 inline-flex items-center gap-2 px-5 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-bold rounded-xl shadow-md transition-all"
          >
            <span>Ir al Catálogo</span>
            <ArrowRight className="w-4 h-4" />
          </button>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
          {filteredShelves.map((item) => {
            const book = item.book;
            if (!book) return null;
            const progress = Math.min(100, Math.round(((item.currentPage || 0) / (book.pages || 1)) * 100));

            return (
              <div
                key={item.bookId}
                className="bg-white rounded-2xl border border-slate-200 hover:border-indigo-300 p-4 shadow-sm hover:shadow-md transition-all flex flex-col justify-between"
              >
                <div>
                  <div className="flex gap-4">
                    {/* Cover thumbnail */}
                    <img
                      src={book.cover}
                      alt={book.title}
                      onClick={() => onSelectBook(book)}
                      className="w-20 h-28 object-cover rounded-xl shadow-sm shrink-0 cursor-pointer hover:opacity-90 transition-opacity"
                      onError={(e) => {
                        e.target.src = 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&q=80&w=600';
                      }}
                    />

                    {/* Book Info */}
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center justify-between gap-1">
                        <span className="text-[10px] font-semibold uppercase px-2 py-0.5 rounded-md bg-slate-100 text-slate-600">
                          {book.genre}
                        </span>
                        <button
                          onClick={() => onRemoveFromShelf(book.id)}
                          className="text-slate-400 hover:text-rose-500 p-1 transition-colors"
                          title="Eliminar de la estantería"
                        >
                          <Trash2 className="w-3.5 h-3.5" />
                        </button>
                      </div>

                      <h4
                        onClick={() => onSelectBook(book)}
                        className="font-serif font-bold text-slate-900 text-sm mt-1.5 line-clamp-1 cursor-pointer hover:text-indigo-600 transition-colors"
                      >
                        {book.title}
                      </h4>
                      <p className="text-xs text-slate-500 line-clamp-1">{book.author}</p>

                      {/* Status indicator */}
                      <div className="mt-2">
                        {item.status === 'reading' && (
                          <span className="inline-flex items-center gap-1 text-[11px] font-bold text-amber-700 bg-amber-50 px-2 py-0.5 rounded-full border border-amber-200">
                            <BookOpen className="w-3 h-3" /> Leyendo
                          </span>
                        )}
                        {item.status === 'want_to_read' && (
                          <span className="inline-flex items-center gap-1 text-[11px] font-bold text-indigo-700 bg-indigo-50 px-2 py-0.5 rounded-full border border-indigo-200">
                            <Bookmark className="w-3 h-3" /> Por leer
                          </span>
                        )}
                        {item.status === 'read' && (
                          <span className="inline-flex items-center gap-1 text-[11px] font-bold text-emerald-700 bg-emerald-50 px-2 py-0.5 rounded-full border border-emerald-200">
                            <Check className="w-3 h-3" /> Leído
                          </span>
                        )}
                      </div>
                    </div>
                  </div>

                  {/* Reading Progress bar if in reading status */}
                  {item.status === 'reading' && (
                    <div className="mt-4 pt-3 border-t border-slate-100">
                      <div className="flex justify-between text-xs text-slate-600 font-semibold mb-1">
                        <span>Pág. {item.currentPage || 0} de {book.pages}</span>
                        <span>{progress}%</span>
                      </div>
                      <div className="w-full h-2 bg-slate-100 rounded-full overflow-hidden">
                        <div
                          className="h-full bg-amber-500 rounded-full transition-all"
                          style={{ width: `${progress}%` }}
                        />
                      </div>

                      {/* Quick page update buttons */}
                      <div className="flex items-center justify-between mt-2.5">
                        <div className="flex items-center gap-1">
                          <button
                            onClick={() => onUpdateShelf({
                              bookId: book.id,
                              status: 'reading',
                              currentPage: Math.max(0, (item.currentPage || 0) - 10)
                            })}
                            className="px-2 py-0.5 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded text-[11px] font-medium"
                          >
                            -10 pág
                          </button>
                          <button
                            onClick={() => onUpdateShelf({
                              bookId: book.id,
                              status: 'reading',
                              currentPage: Math.min(book.pages, (item.currentPage || 0) + 10)
                            })}
                            className="px-2 py-0.5 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded text-[11px] font-medium"
                          >
                            +10 pág
                          </button>
                        </div>

                        <button
                          onClick={() => onUpdateShelf({
                            bookId: book.id,
                            status: 'read',
                            currentPage: book.pages
                          })}
                          className="text-xs text-emerald-600 hover:text-emerald-700 font-bold flex items-center gap-1"
                        >
                          <Check className="w-3 h-3" /> Marcar leído
                        </button>
                      </div>
                    </div>
                  )}

                  {/* Actions for Want to Read */}
                  {item.status === 'want_to_read' && (
                    <div className="mt-4 pt-3 border-t border-slate-100 flex items-center justify-between">
                      <span className="text-[11px] text-slate-400 font-medium">{book.pages} páginas</span>
                      <button
                        onClick={() => onUpdateShelf({
                          bookId: book.id,
                          status: 'reading',
                          currentPage: 1
                        })}
                        className="inline-flex items-center gap-1 px-3 py-1 bg-amber-500 hover:bg-amber-600 text-white rounded-lg text-xs font-semibold transition-colors"
                      >
                        <BookOpen className="w-3 h-3" />
                        <span>Empezar a leer</span>
                      </button>
                    </div>
                  )}

                  {/* Completed info */}
                  {item.status === 'read' && (
                    <div className="mt-4 pt-3 border-t border-slate-100 flex items-center justify-between text-xs">
                      <span className="text-emerald-600 font-semibold flex items-center gap-1">
                        <Check className="w-3.5 h-3.5" /> Completado
                      </span>
                      <span className="text-slate-400 text-[11px]">{book.pages} páginas leídas</span>
                    </div>
                  )}
                </div>

                {/* Optional note snippet */}
                {item.notes && (
                  <div className="mt-3 p-2 bg-slate-50 rounded-xl text-[11px] text-slate-600 italic border border-slate-100">
                    "{item.notes}"
                  </div>
                )}
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}
