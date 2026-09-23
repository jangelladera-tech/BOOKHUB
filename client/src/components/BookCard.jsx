import React, { useState } from 'react';
import { Star, Bookmark, Check, BookOpen, Clock, ChevronDown } from 'lucide-react';

export default function BookCard({ book, shelfItem, onSelectBook, onUpdateShelf }) {
  const [dropdownOpen, setDropdownOpen] = useState(false);

  const getStatusBadge = (status) => {
    switch (status) {
      case 'reading':
        return { label: 'Leyendo', bg: 'bg-amber-100 text-amber-800 border-amber-200', icon: BookOpen };
      case 'read':
        return { label: 'Leído', bg: 'bg-emerald-100 text-emerald-800 border-emerald-200', icon: Check };
      case 'want_to_read':
        return { label: 'Por leer', bg: 'bg-indigo-100 text-indigo-800 border-indigo-200', icon: Bookmark };
      default:
        return null;
    }
  };

  const statusInfo = shelfItem ? getStatusBadge(shelfItem.status) : null;

  const handleShelfChange = (e, status) => {
    e.stopPropagation();
    setDropdownOpen(false);
    onUpdateShelf({ bookId: book.id, status });
  };

  return (
    <div 
      onClick={() => onSelectBook(book)}
      className="group relative bg-white rounded-2xl border border-slate-200 hover:border-indigo-300 shadow-sm hover:shadow-xl transition-all duration-300 flex flex-col overflow-hidden cursor-pointer h-full"
    >
      {/* Book Cover Container */}
      <div className="relative aspect-[3/4] overflow-hidden bg-slate-100">
        <img
          src={book.cover}
          alt={book.title}
          className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
          onError={(e) => {
            e.target.src = 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&q=80&w=600';
          }}
        />

        {/* Top Gradient Overlay */}
        <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-black/20 opacity-0 group-hover:opacity-100 transition-opacity" />

        {/* Genre badge */}
        <div className="absolute top-2.5 left-2.5">
          <span className="px-2.5 py-1 text-[11px] font-semibold tracking-wide rounded-full bg-slate-900/80 text-white backdrop-blur-md border border-white/20 shadow-sm">
            {book.genre}
          </span>
        </div>

        {/* Shelf status badge (if already added) */}
        {statusInfo && (
          <div className="absolute top-2.5 right-2.5">
            <span className={`inline-flex items-center gap-1 px-2.5 py-1 text-[11px] font-bold rounded-full border shadow-sm backdrop-blur-md ${statusInfo.bg}`}>
              <statusInfo.icon className="w-3 h-3" />
              <span>{statusInfo.label}</span>
            </span>
          </div>
        )}
      </div>

      {/* Book Info */}
      <div className="p-4 flex-1 flex flex-col justify-between">
        <div>
          <h3 className="font-serif font-bold text-slate-900 text-base line-clamp-1 group-hover:text-indigo-600 transition-colors">
            {book.title}
          </h3>
          <p className="text-slate-500 text-xs mt-1 font-medium line-clamp-1">
            {book.author}
          </p>

          {/* Rating */}
          <div className="flex items-center gap-1.5 mt-2.5">
            <div className="flex text-amber-400">
              {[...Array(5)].map((_, i) => (
                <Star
                  key={i}
                  className={`w-3.5 h-3.5 ${
                    i < Math.floor(book.rating)
                      ? 'fill-amber-400 text-amber-400'
                      : i < book.rating
                      ? 'fill-amber-400/50 text-amber-400'
                      : 'text-slate-200'
                  }`}
                />
              ))}
            </div>
            <span className="text-xs font-bold text-slate-700">{book.rating}</span>
            <span className="text-[11px] text-slate-400">({book.ratingsCount})</span>
          </div>
        </div>

        {/* Footer info: Pages & Quick Shelf Action */}
        <div className="mt-4 pt-3 border-t border-slate-100 flex items-center justify-between">
          <span className="text-[11px] text-slate-400 font-medium">
            {book.pages} págs • {book.year}
          </span>

          {/* Quick Shelf Button */}
          <div className="relative">
            <button
              onClick={(e) => {
                e.stopPropagation();
                setDropdownOpen(!dropdownOpen);
              }}
              className="inline-flex items-center gap-1 px-2.5 py-1 text-xs font-medium rounded-lg text-indigo-700 bg-indigo-50 hover:bg-indigo-100 transition-colors border border-indigo-100"
            >
              <span>{shelfItem ? 'Cambiar estado' : '+ Estantería'}</span>
              <ChevronDown className="w-3 h-3" />
            </button>

            {dropdownOpen && (
              <>
                <div 
                  className="fixed inset-0 z-30" 
                  onClick={(e) => {
                    e.stopPropagation();
                    setDropdownOpen(false);
                  }}
                />
                <div className="absolute right-0 bottom-full mb-1 w-40 bg-white rounded-xl shadow-xl border border-slate-200 py-1.5 z-40 text-xs animate-in fade-in zoom-in-95">
                  <div className="px-3 py-1 font-semibold text-[10px] text-slate-400 uppercase tracking-wider">
                    Guardar en:
                  </div>
                  <button
                    onClick={(e) => handleShelfChange(e, 'want_to_read')}
                    className={`w-full text-left px-3 py-1.5 flex items-center gap-2 hover:bg-indigo-50 hover:text-indigo-700 transition-colors ${
                      shelfItem?.status === 'want_to_read' ? 'font-bold text-indigo-600 bg-indigo-50/50' : 'text-slate-700'
                    }`}
                  >
                    <Bookmark className="w-3.5 h-3.5 text-indigo-500" />
                    Por leer
                  </button>
                  <button
                    onClick={(e) => handleShelfChange(e, 'reading')}
                    className={`w-full text-left px-3 py-1.5 flex items-center gap-2 hover:bg-amber-50 hover:text-amber-700 transition-colors ${
                      shelfItem?.status === 'reading' ? 'font-bold text-amber-600 bg-amber-50/50' : 'text-slate-700'
                    }`}
                  >
                    <BookOpen className="w-3.5 h-3.5 text-amber-500" />
                    Leyendo
                  </button>
                  <button
                    onClick={(e) => handleShelfChange(e, 'read')}
                    className={`w-full text-left px-3 py-1.5 flex items-center gap-2 hover:bg-emerald-50 hover:text-emerald-700 transition-colors ${
                      shelfItem?.status === 'read' ? 'font-bold text-emerald-600 bg-emerald-50/50' : 'text-slate-700'
                    }`}
                  >
                    <Check className="w-3.5 h-3.5 text-emerald-500" />
                    Leído
                  </button>
                </div>
              </>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
