import { useEffect, useState } from 'react';

const IMAGES_TO_PRELOAD = [
  '/logo.png',
  '/framed/s1.png',
  '/framed/s2.png',
  '/framed/s3.png',
  '/framed/s4.png',
  '/framed/s5.png',
  '/framed/s6.png',
];

export default function SplashScreen({ onDone }) {
  const [progress, setProgress] = useState(0);
  const [leaving, setLeaving] = useState(false);

  useEffect(() => {
    // ── 1. Smooth progress bar over exactly 3000ms ──
    const DURATION = 3000;
    const INTERVAL = 30; // update every 30ms → 100 steps
    let elapsed = 0;

    const ticker = setInterval(() => {
      elapsed += INTERVAL;
      const pct = Math.min(Math.round((elapsed / DURATION) * 100), 100);
      setProgress(pct);
      if (pct >= 100) clearInterval(ticker);
    }, INTERVAL);

    // ── 2. Preload images in the background (silent) ──
    IMAGES_TO_PRELOAD.forEach((src) => {
      const img = new Image();
      img.src = src;
    });

    // ── 3. Dismiss after 3s + 300ms pause + 500ms fade ──
    const dismiss = setTimeout(() => {
      setLeaving(true);
      setTimeout(onDone, 500);
    }, DURATION + 300);

    return () => {
      clearInterval(ticker);
      clearTimeout(dismiss);
    };
  }, [onDone]);

  return (
    <div
      className={`fixed inset-0 z-[9999] flex flex-col items-center justify-center bg-background transition-opacity duration-500 ${
        leaving ? 'opacity-0 pointer-events-none' : 'opacity-100'
      }`}
    >
      {/* Logo */}
      <div className="relative mb-8">
        <img
          src="/logo.png"
          alt="TaskFlow"
          className="w-16 h-16 object-cover scale-110 animate-pulse"
        />
        <div className="absolute inset-0 -m-3 rounded-full border border-white/[0.08] animate-spin [animation-duration:3s]" />
      </div>

      <p className="text-white font-semibold text-lg tracking-tight mb-1">TaskFlow</p>
      <p className="font-mono text-xs text-white/25 mb-10">// personal task manager</p>

      {/* Progress bar */}
      <div className="w-48 h-px bg-white/[0.08] rounded-full overflow-hidden">
        <div
          className="h-full bg-white/60 rounded-full"
          style={{
            width: `${progress}%`,
            transition: 'width 30ms linear',
          }}
        />
      </div>
      <p className="font-mono text-[10px] text-white/15 mt-3">{progress}%</p>
    </div>
  );
}
