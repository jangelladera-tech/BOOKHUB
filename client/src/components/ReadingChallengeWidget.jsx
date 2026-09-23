import React, { useState } from 'react';
import { Trophy, Target, Sparkles, Edit2, Check, Flame, Award, BookOpen } from 'lucide-react';

export default function ReadingChallengeWidget({ challenge, onUpdateChallenge, readCount }) {
  const [isEditing, setIsEditing] = useState(false);
  const [newGoal, setNewGoal] = useState(challenge?.goal || 24);

  const goal = challenge?.goal || 24;
  const completed = readCount !== undefined ? readCount : (challenge?.completed || 0);
  const percentage = Math.min(100, Math.round((completed / goal) * 100));
  const remaining = Math.max(0, goal - completed);

  const handleSave = (e) => {
    e.preventDefault();
    if (newGoal > 0) {
      onUpdateChallenge(Number(newGoal));
      setIsEditing(false);
    }
  };

  return (
    <div className="space-y-6">
      {/* Top Banner */}
      <div className="bg-gradient-to-r from-amber-500 via-orange-500 to-amber-600 rounded-3xl p-8 text-white shadow-xl relative overflow-hidden">
        <div className="absolute top-0 right-0 w-80 h-80 bg-white/10 rounded-full blur-2xl pointer-events-none" />

        <div className="relative max-w-4xl mx-auto grid grid-cols-1 md:grid-cols-12 gap-6 items-center">
          <div className="md:col-span-8 space-y-3">
            <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-white/20 backdrop-blur-md text-amber-100 text-xs font-semibold">
              <Trophy className="w-3.5 h-3.5 text-amber-200" />
              <span>Reto de Lectura Anual {challenge?.year || 2026}</span>
            </div>

            <h2 className="text-3xl sm:text-4xl font-serif font-bold text-white leading-tight">
              {completed >= goal ? '¡Felicidades, cumpliste tu meta!' : '¡Cada página cuenta!'}
            </h2>

            <p className="text-amber-100 text-sm max-w-xl">
              Has leído <span className="font-bold text-white underline decoration-amber-300">{completed} libros</span> de tu meta anual de <span className="font-bold text-white">{goal} libros</span>.
              {remaining > 0 ? ` Te faltan ${remaining} libros para completar el reto.` : ' ¡Excelente ritmo de lectura!'}
            </p>

            {/* Editable goal toggle */}
            <div className="pt-2">
              {!isEditing ? (
                <button
                  onClick={() => setIsEditing(true)}
                  className="inline-flex items-center gap-1.5 text-xs text-amber-100 hover:text-white bg-black/20 hover:bg-black/30 px-3 py-1.5 rounded-lg font-medium transition-colors"
                >
                  <Edit2 className="w-3 h-3" />
                  <span>Modificar meta ({goal} libros)</span>
                </button>
              ) : (
                <form onSubmit={handleSave} className="flex items-center gap-2">
                  <input
                    type="number"
                    min="1"
                    max="300"
                    value={newGoal}
                    onChange={(e) => setNewGoal(e.target.value)}
                    className="w-20 px-2 py-1 text-xs rounded-lg text-slate-900 bg-white font-bold focus:outline-none"
                  />
                  <button
                    type="submit"
                    className="px-3 py-1 bg-white text-orange-600 font-bold text-xs rounded-lg hover:bg-amber-50"
                  >
                    Guardar
                  </button>
                  <button
                    type="button"
                    onClick={() => setIsEditing(false)}
                    className="text-xs text-amber-200 hover:text-white"
                  >
                    Cancelar
                  </button>
                </form>
              )}
            </div>
          </div>

          {/* Progress circle or large visual */}
          <div className="md:col-span-4 flex justify-center">
            <div className="relative w-36 h-36 flex items-center justify-center bg-white/10 rounded-full border-4 border-white/30 backdrop-blur-md shadow-inner">
              <div className="text-center">
                <span className="text-4xl font-extrabold font-serif text-white block">
                  {percentage}%
                </span>
                <span className="text-[11px] font-semibold text-amber-200 uppercase tracking-widest">
                  Completado
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Challenge Breakdown Cards */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
        <div className="bg-white p-6 rounded-2xl border border-slate-200 shadow-sm flex items-center gap-4">
          <div className="w-12 h-12 rounded-xl bg-amber-50 text-amber-600 flex items-center justify-center shrink-0">
            <Flame className="w-6 h-6" />
          </div>
          <div>
            <div className="text-xs font-semibold text-slate-400 uppercase tracking-wider">Libros Leídos</div>
            <div className="text-2xl font-bold font-serif text-slate-900">{completed}</div>
            <div className="text-xs text-emerald-600 font-medium">Registrados en tu estantería</div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl border border-slate-200 shadow-sm flex items-center gap-4">
          <div className="w-12 h-12 rounded-xl bg-indigo-50 text-indigo-600 flex items-center justify-center shrink-0">
            <Target className="w-6 h-6" />
          </div>
          <div>
            <div className="text-xs font-semibold text-slate-400 uppercase tracking-wider">Meta Anual</div>
            <div className="text-2xl font-bold font-serif text-slate-900">{goal}</div>
            <div className="text-xs text-slate-500">Objetivo para el año {challenge?.year || 2026}</div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl border border-slate-200 shadow-sm flex items-center gap-4">
          <div className="w-12 h-12 rounded-xl bg-orange-50 text-orange-600 flex items-center justify-center shrink-0">
            <Award className="w-6 h-6" />
          </div>
          <div>
            <div className="text-xs font-semibold text-slate-400 uppercase tracking-wider">Restantes</div>
            <div className="text-2xl font-bold font-serif text-slate-900">{remaining}</div>
            <div className="text-xs text-slate-500">Libros para alcanzar tu meta</div>
          </div>
        </div>
      </div>

      {/* Reader habit tips */}
      <div className="bg-indigo-50/70 border border-indigo-100 rounded-2xl p-6">
        <h4 className="text-sm font-bold text-indigo-950 flex items-center gap-2 mb-3">
          <Sparkles className="w-4 h-4 text-indigo-600" />
          <span>Consejos para alcanzar tu meta de lectura:</span>
        </h4>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-xs text-indigo-900 leading-relaxed">
          <div className="p-3 bg-white rounded-xl shadow-xs border border-indigo-100/50">
            <span className="font-bold text-indigo-700 block mb-1">📖 20 páginas al día</span>
            Si lees 20 páginas cada día antes de dormir o por la mañana, terminarás aproximadamente 2 libros por mes.
          </div>
          <div className="p-3 bg-white rounded-xl shadow-xs border border-indigo-100/50">
            <span className="font-bold text-indigo-700 block mb-1">🎧 Alterna formatos</span>
            Combina libros físicos, electrónicos o audiolibros durante tus traslados diarios para mantener el hábito activo.
          </div>
          <div className="p-3 bg-white rounded-xl shadow-xs border border-indigo-100/50">
            <span className="font-bold text-indigo-700 block mb-1">✍️ Escribe reflexiones</span>
            Anotar tus impresiones y dejar reseñas refuerza lo aprendido y te mantiene motivado para continuar con el siguiente título.
          </div>
        </div>
      </div>
    </div>
  );
}
