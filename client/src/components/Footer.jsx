import React from 'react';
import { BookOpen, Heart } from 'lucide-react';

export default function Footer() {
  return (
    <footer className="mt-20 border-t border-slate-200 bg-white py-10 text-slate-500 text-xs">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex flex-col sm:flex-row items-center justify-between gap-4">
        <div className="flex items-center gap-2">
          <div className="w-7 h-7 rounded-lg bg-indigo-600 flex items-center justify-center text-white">
            <BookOpen className="w-4 h-4" />
          </div>
          <span className="font-serif font-bold text-slate-900 text-sm">BOOKHUB</span>
          <span className="text-slate-400">| Comunidad para amantes de la lectura</span>
        </div>

        <div className="flex items-center gap-1 text-slate-400">
          <span>Construido con</span>
          <Heart className="w-3.5 h-3.5 text-rose-500 fill-rose-500" />
          <span>para todos los lectores del mundo.</span>
        </div>

        <div className="text-slate-400">
          &copy; {new Date().getFullYear()} BookHub. Todos los derechos reservados.
        </div>
      </div>
    </footer>
  );
}
