import React from 'react';
import { 
  BarChart3, BookOpen, Layers, Award, Heart, CheckCircle2, 
  Clock, TrendingUp, Sparkles 
} from 'lucide-react';

export default function StatsView({ stats }) {
  if (!stats) return null;

  const avgPagesPerBook = stats.readCount > 0 
    ? Math.round(stats.totalPagesRead / (stats.readCount + (stats.readingCount > 0 ? 0.5 : 0))) 
    : 0;

  return (
    <div className="space-y-6">
      <div className="bg-white p-6 rounded-3xl border border-slate-200 shadow-sm">
        <h2 className="text-2xl font-serif font-bold text-slate-900">
          Tus Estadísticas de Lectura
        </h2>
        <p className="text-sm text-slate-500 mt-1">
          Un resumen detallado de tus hábitos, páginas devoradas y géneros preferidos.
        </p>
      </div>

      {/* Main Stats Cards Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
        {/* Books Read */}
        <div className="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm relative overflow-hidden">
          <div className="flex items-center justify-between">
            <span className="text-xs font-bold text-slate-400 uppercase tracking-wider">Libros Leídos</span>
            <div className="w-9 h-9 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center">
              <CheckCircle2 className="w-5 h-5" />
            </div>
          </div>
          <div className="mt-3">
            <span className="text-3xl font-extrabold font-serif text-slate-900">{stats.readCount}</span>
            <span className="text-xs text-slate-500 ml-1.5">libros</span>
          </div>
          <div className="text-[11px] text-emerald-600 font-semibold mt-2 flex items-center gap-1">
            <TrendingUp className="w-3.5 h-3.5" /> En tu estantería
          </div>
        </div>

        {/* Pages Read */}
        <div className="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm relative overflow-hidden">
          <div className="flex items-center justify-between">
            <span className="text-xs font-bold text-slate-400 uppercase tracking-wider">Páginas Totales</span>
            <div className="w-9 h-9 rounded-xl bg-indigo-50 text-indigo-600 flex items-center justify-center">
              <Layers className="w-5 h-5" />
            </div>
          </div>
          <div className="mt-3">
            <span className="text-3xl font-extrabold font-serif text-slate-900">
              {stats.totalPagesRead.toLocaleString()}
            </span>
            <span className="text-xs text-slate-500 ml-1.5">págs</span>
          </div>
          <div className="text-[11px] text-indigo-600 font-semibold mt-2 flex items-center gap-1">
            <Clock className="w-3.5 h-3.5" /> Suma acumulada
          </div>
        </div>

        {/* Reading in Progress */}
        <div className="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm relative overflow-hidden">
          <div className="flex items-center justify-between">
            <span className="text-xs font-bold text-slate-400 uppercase tracking-wider">Leyendo Ahora</span>
            <div className="w-9 h-9 rounded-xl bg-amber-50 text-amber-600 flex items-center justify-center">
              <BookOpen className="w-5 h-5" />
            </div>
          </div>
          <div className="mt-3">
            <span className="text-3xl font-extrabold font-serif text-slate-900">{stats.readingCount}</span>
            <span className="text-xs text-slate-500 ml-1.5">en curso</span>
          </div>
          <div className="text-[11px] text-amber-600 font-semibold mt-2 flex items-center gap-1">
            <Sparkles className="w-3.5 h-3.5" /> Progreso activo
          </div>
        </div>

        {/* Favorite Genre */}
        <div className="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm relative overflow-hidden">
          <div className="flex items-center justify-between">
            <span className="text-xs font-bold text-slate-400 uppercase tracking-wider">Género Favorito</span>
            <div className="w-9 h-9 rounded-xl bg-rose-50 text-rose-600 flex items-center justify-center">
              <Heart className="w-5 h-5" />
            </div>
          </div>
          <div className="mt-3">
            <span className="text-lg font-bold font-serif text-slate-900 block truncate">
              {stats.favoriteGenre}
            </span>
            <span className="text-xs text-slate-400">Más leído este año</span>
          </div>
          <div className="text-[11px] text-rose-600 font-semibold mt-2 flex items-center gap-1">
            <Award className="w-3.5 h-3.5" /> Mayor afinidad
          </div>
        </div>
      </div>

      {/* Additional Reading Insights */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div className="bg-white p-6 rounded-2xl border border-slate-200 shadow-sm space-y-4">
          <h3 className="text-sm font-bold text-slate-900 uppercase tracking-wider flex items-center gap-2">
            <BarChart3 className="w-4 h-4 text-indigo-600" />
            Distribución de tu Biblioteca
          </h3>

          <div className="space-y-3 pt-2">
            <div>
              <div className="flex justify-between text-xs font-semibold text-slate-700 mb-1">
                <span>Libros Leídos</span>
                <span>{stats.readCount}</span>
              </div>
              <div className="w-full h-2 bg-slate-100 rounded-full overflow-hidden">
                <div 
                  className="h-full bg-emerald-500 rounded-full"
                  style={{ width: `${Math.min(100, (stats.readCount / (stats.readCount + stats.readingCount + stats.wantToReadCount || 1)) * 100)}%` }}
                />
              </div>
            </div>

            <div>
              <div className="flex justify-between text-xs font-semibold text-slate-700 mb-1">
                <span>Leyendo Actualmente</span>
                <span>{stats.readingCount}</span>
              </div>
              <div className="w-full h-2 bg-slate-100 rounded-full overflow-hidden">
                <div 
                  className="h-full bg-amber-500 rounded-full"
                  style={{ width: `${Math.min(100, (stats.readingCount / (stats.readCount + stats.readingCount + stats.wantToReadCount || 1)) * 100)}%` }}
                />
              </div>
            </div>

            <div>
              <div className="flex justify-between text-xs font-semibold text-slate-700 mb-1">
                <span>Por Leer en Lista</span>
                <span>{stats.wantToReadCount}</span>
              </div>
              <div className="w-full h-2 bg-slate-100 rounded-full overflow-hidden">
                <div 
                  className="h-full bg-indigo-500 rounded-full"
                  style={{ width: `${Math.min(100, (stats.wantToReadCount / (stats.readCount + stats.readingCount + stats.wantToReadCount || 1)) * 100)}%` }}
                />
              </div>
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl border border-slate-200 shadow-sm flex flex-col justify-between">
          <div>
            <h3 className="text-sm font-bold text-slate-900 uppercase tracking-wider flex items-center gap-2">
              <Award className="w-4 h-4 text-amber-500" />
              Promedios y Hábitos
            </h3>
            
            <div className="mt-4 space-y-4">
              <div className="flex items-center justify-between p-3 bg-slate-50 rounded-xl">
                <span className="text-xs text-slate-600 font-medium">Grosor promedio por libro:</span>
                <span className="text-xs font-bold text-slate-900">{avgPagesPerBook} páginas</span>
              </div>
              <div className="flex items-center justify-between p-3 bg-slate-50 rounded-xl">
                <span className="text-xs text-slate-600 font-medium">Libros guardados en cola:</span>
                <span className="text-xs font-bold text-slate-900">{stats.wantToReadCount} títulos</span>
              </div>
              <div className="flex items-center justify-between p-3 bg-slate-50 rounded-xl">
                <span className="text-xs text-slate-600 font-medium">Estado del Reto Anual:</span>
                <span className="text-xs font-bold text-indigo-600">{stats.challenge.percentage}% logrado</span>
              </div>
            </div>
          </div>

          <div className="text-[11px] text-slate-400 mt-4 text-center">
            Las estadísticas se sincronizan en tiempo real con cada actualización de tu estantería.
          </div>
        </div>
      </div>
    </div>
  );
}
