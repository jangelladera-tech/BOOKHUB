import React from 'react';
import { Sparkles, Star, BookMarked, ArrowRight } from 'lucide-react';

export default function Hero({ featuredBook, onSelectBook, onOpenAddBook }) {
  return (
    <div className="relative overflow-hidden bg-gradient-to-br from-indigo-900 via-slate-900 to-indigo-950 text-white py-12 px-4 sm:px-6 lg:px-8 rounded-3xl shadow-xl mb-10">
      {/* Background glowing decorations */}
      <div className="absolute top-0 right-1/4 w-96 h-96 bg-indigo-500/20 rounded-full blur-3xl pointer-events-none" />
      <div className="absolute bottom-0 left-10 w-72 h-72 bg-violet-600/20 rounded-full blur-2xl pointer-events-none" />

      <div className="relative max-w-6xl mx-auto grid grid-cols-1 lg:grid-cols-12 gap-8 items-center">
        {/* Left Column: Intro */}
        <div className="lg:col-span-7 space-y-5 text-center lg:text-left">
          <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-white/10 backdrop-blur-md border border-white/15 text-indigo-200 text-xs font-medium">
            <Sparkles className="w-3.5 h-3.5 text-amber-400" />
            <span>Tu espacio literario definitivo</span>
          </div>

          <h1 className="text-3xl sm:text-4xl lg:text-5xl font-serif font-bold tracking-tight text-white leading-tight">
            Descubre historias que <span className="bg-gradient-to-r from-amber-200 via-pink-300 to-indigo-200 bg-clip-text text-transparent">transforman</span> tu mundo.
          </h1>

          <p className="text-slate-300 text-base sm:text-lg max-w-xl font-normal leading-relaxed">
            Organiza tus lecturas, lleva el control de tus páginas, comparte reseñas honestas y cumple tu reto anual de lectura junto a una comunidad de apasionados por los libros.
          </p>

          <div className="flex flex-wrap items-center justify-center lg:justify-start gap-3 pt-2">
            <a
              href="#catalog-section"
              className="px-5 py-2.5 rounded-xl bg-white text-indigo-900 hover:bg-slate-100 font-semibold text-sm shadow-md transition-all flex items-center gap-2"
            >
              <span>Explorar catálogo</span>
              <ArrowRight className="w-4 h-4" />
            </a>
            <button
              onClick={onOpenAddBook}
              className="px-5 py-2.5 rounded-xl bg-white/10 hover:bg-white/15 text-white font-medium text-sm border border-white/20 backdrop-blur-sm transition-all"
            >
              Añadir recomendación
            </button>
          </div>
        </div>

        {/* Right Column: Featured Book of the month */}
        {featuredBook && (
          <div className="lg:col-span-5 flex justify-center">
            <div 
              onClick={() => onSelectBook(featuredBook)}
              className="group cursor-pointer bg-white/10 hover:bg-white/15 backdrop-blur-md p-5 rounded-2xl border border-white/20 transition-all hover:scale-[1.02] shadow-2xl max-w-sm w-full"
            >
              <div className="text-xs font-semibold uppercase tracking-wider text-amber-300 mb-3 flex items-center justify-between">
                <span>⭐ Libro Destacado</span>
                <span className="text-slate-300 capitalize">{featuredBook.genre}</span>
              </div>

              <div className="flex gap-4">
                <img
                  src={featuredBook.cover}
                  alt={featuredBook.title}
                  className="w-24 h-36 object-cover rounded-lg shadow-lg group-hover:shadow-indigo-500/20 transition-all shrink-0"
                  onError={(e) => {
                    e.target.src = 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&q=80&w=600';
                  }}
                />
                <div className="flex flex-col justify-between py-1">
                  <div>
                    <h3 className="font-serif font-bold text-lg text-white group-hover:text-amber-200 transition-colors line-clamp-2">
                      {featuredBook.title}
                    </h3>
                    <p className="text-slate-300 text-sm mt-0.5">{featuredBook.author}</p>
                    <div className="flex items-center gap-1.5 mt-2">
                      <div className="flex text-amber-400">
                        <Star className="w-4 h-4 fill-amber-400 text-amber-400" />
                      </div>
                      <span className="text-xs font-bold text-white">{featuredBook.rating}</span>
                      <span className="text-xs text-slate-400">({featuredBook.ratingsCount} reseñas)</span>
                    </div>
                  </div>

                  <span className="text-xs text-indigo-200 group-hover:text-white flex items-center gap-1 font-medium mt-3">
                    Ver detalles y reseñas &rarr;
                  </span>
                </div>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
