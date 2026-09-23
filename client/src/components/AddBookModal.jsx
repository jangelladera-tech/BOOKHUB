import React, { useState } from 'react';
import { X, Plus, BookPlus, Image as ImageIcon, Sparkles } from 'lucide-react';

export default function AddBookModal({ isOpen, onClose, onAddBook, genres = [] }) {
  const [title, setTitle] = useState('');
  const [author, setAuthor] = useState('');
  const [genre, setGenre] = useState('Ficción');
  const [customGenre, setCustomGenre] = useState('');
  const [pages, setPages] = useState('320');
  const [year, setYear] = useState(new Date().getFullYear().toString());
  const [cover, setCover] = useState('');
  const [synopsis, setSynopsis] = useState('');
  const [tags, setTags] = useState('');
  const [loading, setLoading] = useState(false);

  if (!isOpen) return null;

  const defaultCovers = [
    'https://images.unsplash.com/photo-1544947950-fa07a98d237f?auto=format&fit=crop&q=80&w=600',
    'https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&q=80&w=600',
    'https://images.unsplash.com/photo-1543002588-bfa74002ed7e?auto=format&fit=crop&q=80&w=600',
    'https://images.unsplash.com/photo-1532012164546-f432f2e3777f?auto=format&fit=crop&q=80&w=600'
  ];

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!title.trim() || !author.trim()) return;

    setLoading(true);
    try {
      const finalGenre = genre === 'Otro' && customGenre.trim() ? customGenre.trim() : genre;
      const finalCover = cover.trim() || defaultCovers[Math.floor(Math.random() * defaultCovers.length)];

      await onAddBook({
        title: title.trim(),
        author: author.trim(),
        genre: finalGenre,
        pages: Number(pages) || 250,
        year: Number(year) || new Date().getFullYear(),
        cover: finalCover,
        synopsis: synopsis.trim() || 'Sin sinopsis disponible.',
        tags: tags.split(',').map(t => t.trim()).filter(Boolean)
      });

      // Reset
      setTitle('');
      setAuthor('');
      setCover('');
      setSynopsis('');
      setTags('');
      onClose();
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 overflow-y-auto bg-slate-900/60 backdrop-blur-sm flex items-center justify-center p-4 animate-in fade-in duration-200">
      <div 
        className="relative bg-white w-full max-w-xl rounded-3xl shadow-2xl border border-slate-200 overflow-hidden"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-slate-100 bg-slate-50/50">
          <div className="flex items-center gap-2 text-indigo-700 font-bold">
            <BookPlus className="w-5 h-5" />
            <h3 className="text-base font-serif">Añadir Nuevo Libro al Catálogo</h3>
          </div>
          <button
            onClick={onClose}
            className="p-1.5 rounded-lg text-slate-400 hover:text-slate-700 hover:bg-slate-200 transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Form */}
        <form onSubmit={handleSubmit} className="p-6 space-y-4">
          <div>
            <label className="text-xs font-bold text-slate-700 block mb-1">
              Título del libro *
            </label>
            <input
              type="text"
              required
              placeholder="ej. El Principito, Rayuela, etc."
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              className="w-full px-3.5 py-2 text-sm rounded-xl border border-slate-200 focus:outline-none focus:ring-2 focus:ring-indigo-500"
            />
          </div>

          <div>
            <label className="text-xs font-bold text-slate-700 block mb-1">
              Autor *
            </label>
            <input
              type="text"
              required
              placeholder="ej. Antoine de Saint-Exupéry, Julio Cortázar"
              value={author}
              onChange={(e) => setAuthor(e.target.value)}
              className="w-full px-3.5 py-2 text-sm rounded-xl border border-slate-200 focus:outline-none focus:ring-2 focus:ring-indigo-500"
            />
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
            <div>
              <label className="text-xs font-bold text-slate-700 block mb-1">
                Género
              </label>
              <select
                value={genre}
                onChange={(e) => setGenre(e.target.value)}
                className="w-full px-3 py-2 text-xs rounded-xl border border-slate-200 bg-white focus:outline-none focus:ring-2 focus:ring-indigo-500"
              >
                {genres.map(g => (
                  <option key={g.name} value={g.name}>{g.name}</option>
                ))}
                <option value="Ficción">Ficción</option>
                <option value="Ciencia Ficción">Ciencia Ficción</option>
                <option value="Fantasía">Fantasía</option>
                <option value="Misterio">Misterio</option>
                <option value="Desarrollo Personal">Desarrollo Personal</option>
                <option value="No Ficción">No Ficción</option>
                <option value="Romance">Romance</option>
                <option value="Otro">Otro...</option>
              </select>
            </div>

            <div>
              <label className="text-xs font-bold text-slate-700 block mb-1">
                Páginas
              </label>
              <input
                type="number"
                min="1"
                value={pages}
                onChange={(e) => setPages(e.target.value)}
                className="w-full px-3 py-2 text-xs rounded-xl border border-slate-200 focus:outline-none focus:ring-2 focus:ring-indigo-500"
              />
            </div>

            <div>
              <label className="text-xs font-bold text-slate-700 block mb-1">
                Año
              </label>
              <input
                type="number"
                value={year}
                onChange={(e) => setYear(e.target.value)}
                className="w-full px-3 py-2 text-xs rounded-xl border border-slate-200 focus:outline-none focus:ring-2 focus:ring-indigo-500"
              />
            </div>
          </div>

          {genre === 'Otro' && (
            <div>
              <label className="text-xs font-bold text-slate-700 block mb-1">
                Especificar Género
              </label>
              <input
                type="text"
                placeholder="Nombre del nuevo género"
                value={customGenre}
                onChange={(e) => setCustomGenre(e.target.value)}
                className="w-full px-3 py-2 text-xs rounded-xl border border-slate-200 focus:outline-none focus:ring-2 focus:ring-indigo-500"
              />
            </div>
          )}

          <div>
            <label className="text-xs font-bold text-slate-700 block mb-1">
              URL de la Portada (opcional)
            </label>
            <input
              type="url"
              placeholder="https://images.unsplash.com/..."
              value={cover}
              onChange={(e) => setCover(e.target.value)}
              className="w-full px-3.5 py-2 text-xs rounded-xl border border-slate-200 focus:outline-none focus:ring-2 focus:ring-indigo-500"
            />
            {cover && (
              <div className="mt-2 flex items-center gap-3 p-2 bg-slate-50 rounded-xl border border-slate-100">
                <img
                  src={cover}
                  alt="Vista previa"
                  className="w-10 h-14 object-cover rounded shadow-xs"
                  onError={(e) => {
                    e.target.style.display = 'none';
                  }}
                />
                <span className="text-[11px] text-slate-500">Vista previa de la portada detectada</span>
              </div>
            )}
          </div>

          <div>
            <label className="text-xs font-bold text-slate-700 block mb-1">
              Sinopsis
            </label>
            <textarea
              rows={3}
              placeholder="Breve resumen o argumento del libro..."
              value={synopsis}
              onChange={(e) => setSynopsis(e.target.value)}
              className="w-full p-3 text-xs rounded-xl border border-slate-200 focus:outline-none focus:ring-2 focus:ring-indigo-500"
            />
          </div>

          <div>
            <label className="text-xs font-bold text-slate-700 block mb-1">
              Etiquetas (separadas por coma)
            </label>
            <input
              type="text"
              placeholder="ej. Clásico, Aventura, Filosofía"
              value={tags}
              onChange={(e) => setTags(e.target.value)}
              className="w-full px-3.5 py-2 text-xs rounded-xl border border-slate-200 focus:outline-none focus:ring-2 focus:ring-indigo-500"
            />
          </div>

          <div className="pt-2 flex justify-end gap-2">
            <button
              type="button"
              onClick={onClose}
              className="px-4 py-2 text-xs font-semibold text-slate-600 hover:text-slate-800 rounded-xl hover:bg-slate-100"
            >
              Cancelar
            </button>
            <button
              type="submit"
              disabled={loading}
              className="px-5 py-2 bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-semibold rounded-xl shadow-sm transition-all flex items-center gap-1.5"
            >
              <Plus className="w-4 h-4" />
              <span>{loading ? 'Guardando...' : 'Añadir al Catálogo'}</span>
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
