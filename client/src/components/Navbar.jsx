import React from 'react';
import { BookOpen, Library, Trophy, BarChart3, Plus, Bookmark } from 'lucide-react';

export default function Navbar({ activeTab, setActiveTab, onOpenAddBook, shelfCount }) {
  return (
    <header className="sticky top-0 z-40 bg-white/90 backdrop-blur-md border-b border-slate-200">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          {/* Logo */}
          <div 
            className="flex items-center gap-2.5 cursor-pointer group"
            onClick={() => setActiveTab('catalog')}
          >
            <div className="w-10 h-10 rounded-xl bg-gradient-to-tr from-indigo-600 to-violet-500 flex items-center justify-center text-white shadow-md shadow-indigo-200 group-hover:scale-105 transition-transform">
              <BookOpen className="w-5 h-5" />
            </div>
            <div>
              <span className="text-xl font-bold bg-gradient-to-r from-indigo-700 via-purple-700 to-indigo-900 bg-clip-text text-transparent font-serif tracking-tight">
                BOOKHUB
              </span>
              <span className="block text-[10px] font-medium text-slate-500 uppercase tracking-widest -mt-1">
                Comunidad Lectora
              </span>
            </div>
          </div>

          {/* Navigation links */}
          <nav className="hidden md:flex items-center gap-1">
            <button
              onClick={() => setActiveTab('catalog')}
              className={`flex items-center gap-2 px-3.5 py-2 rounded-lg text-sm font-medium transition-all ${
                activeTab === 'catalog'
                  ? 'bg-indigo-50 text-indigo-700'
                  : 'text-slate-600 hover:text-slate-900 hover:bg-slate-100'
              }`}
            >
              <BookOpen className="w-4 h-4" />
              Explorar Catálogo
            </button>

            <button
              onClick={() => setActiveTab('shelves')}
              className={`flex items-center gap-2 px-3.5 py-2 rounded-lg text-sm font-medium transition-all relative ${
                activeTab === 'shelves'
                  ? 'bg-indigo-50 text-indigo-700'
                  : 'text-slate-600 hover:text-slate-900 hover:bg-slate-100'
              }`}
            >
              <Library className="w-4 h-4" />
              Mis Estanterías
              {shelfCount > 0 && (
                <span className="ml-1 px-1.5 py-0.5 text-xs font-semibold rounded-full bg-indigo-600 text-white leading-none">
                  {shelfCount}
                </span>
              )}
            </button>

            <button
              onClick={() => setActiveTab('challenge')}
              className={`flex items-center gap-2 px-3.5 py-2 rounded-lg text-sm font-medium transition-all ${
                activeTab === 'challenge'
                  ? 'bg-indigo-50 text-indigo-700'
                  : 'text-slate-600 hover:text-slate-900 hover:bg-slate-100'
              }`}
            >
              <Trophy className="w-4 h-4" />
              Reto Anual
            </button>

            <button
              onClick={() => setActiveTab('stats')}
              className={`flex items-center gap-2 px-3.5 py-2 rounded-lg text-sm font-medium transition-all ${
                activeTab === 'stats'
                  ? 'bg-indigo-50 text-indigo-700'
                  : 'text-slate-600 hover:text-slate-900 hover:bg-slate-100'
              }`}
            >
              <BarChart3 className="w-4 h-4" />
              Estadísticas
            </button>
          </nav>

          {/* Action button */}
          <div className="flex items-center gap-3">
            <button
              onClick={onOpenAddBook}
              className="flex items-center gap-1.5 px-4 py-2 rounded-lg bg-indigo-600 hover:bg-indigo-700 text-white text-sm font-medium shadow-sm hover:shadow transition-all active:scale-95"
            >
              <Plus className="w-4 h-4" />
              <span>Añadir Libro</span>
            </button>
          </div>
        </div>
      </div>

      {/* Mobile navigation bottom bar */}
      <div className="md:hidden flex items-center justify-around border-t border-slate-200 bg-white py-2 px-1">
        <button
          onClick={() => setActiveTab('catalog')}
          className={`flex flex-col items-center py-1 px-2 text-xs font-medium ${
            activeTab === 'catalog' ? 'text-indigo-600' : 'text-slate-600'
          }`}
        >
          <BookOpen className="w-5 h-5" />
          <span>Explorar</span>
        </button>
        <button
          onClick={() => setActiveTab('shelves')}
          className={`flex flex-col items-center py-1 px-2 text-xs font-medium relative ${
            activeTab === 'shelves' ? 'text-indigo-600' : 'text-slate-600'
          }`}
        >
          <Library className="w-5 h-5" />
          <span>Estantería</span>
          {shelfCount > 0 && (
            <span className="absolute top-0 right-3 w-4 h-4 text-[10px] font-bold rounded-full bg-indigo-600 text-white flex items-center justify-center">
              {shelfCount}
            </span>
          )}
        </button>
        <button
          onClick={() => setActiveTab('challenge')}
          className={`flex flex-col items-center py-1 px-2 text-xs font-medium ${
            activeTab === 'challenge' ? 'text-indigo-600' : 'text-slate-600'
          }`}
        >
          <Trophy className="w-5 h-5" />
          <span>Reto</span>
        </button>
        <button
          onClick={() => setActiveTab('stats')}
          className={`flex flex-col items-center py-1 px-2 text-xs font-medium ${
            activeTab === 'stats' ? 'text-indigo-600' : 'text-slate-600'
          }`}
        >
          <BarChart3 className="w-5 h-5" />
          <span>Métricas</span>
        </button>
      </div>
    </header>
  );
}
