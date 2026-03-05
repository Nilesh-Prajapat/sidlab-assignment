import { useEffect, useState } from 'react';

// All images that need to be preloaded before showing the site
const IMAGES_TO_PRELOAD = [
  '/logo.png',
  '/framed/s1.png',
  '/framed/s2.png',
  '/framed/s3.png',
  '/framed/s4.png',
  '/framed/s5.png',
  '/framed/s6.png',
];

function preloadImages(urls) {
  return Promise.all(
    urls.map(
      (src) =>
        new Promise((resolve) => {
          const img = new Image();
          img.onload = resolve;
          img.onerror = resolve; // don't block on missing images
          img.src = src;
        })
    )
  );
}

export default function SplashScreen({ onDone }) {
  const [progress, setProgress] = useState(0);
  const [leaving, setLeaving] = useState(false);

  useEffect(() => {
    let loaded = 0;
    const total = IMAGES_TO_PRELOAD.length;

    const promises = IMAGES_TO_PRELOAD.map(
      (src) =>
        new Promise((resolve) => {
          const img = new Image();
          img.onload = img.onerror = () => {
            loaded += 1;
            setProgress(Math.round((loaded / total) * 100));
            resolve();
          };
          img.src = src;
        })
    );

    // Wait for BOTH: all images loaded AND minimum 3s display time
    const minTimer = new Promise((resolve) => setTimeout(resolve, 3000));

    Promise.all([...promises, minTimer]).then(() => {
      setProgress(100);
      setTimeout(() => {
        setLeaving(true);
        setTimeout(onDone, 500); // match CSS fade-out
      }, 300);
    });
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
        {/* Spinning ring */}
        <div className="absolute inset-0 -m-3 rounded-full border border-white/[0.08] animate-spin [animation-duration:3s]" />
      </div>

      <p className="text-white font-semibold text-lg tracking-tight mb-1">TaskFlow</p>
      <p className="font-mono text-xs text-white/25 mb-10">// personal task manager</p>

      {/* Progress bar */}
      <div className="w-48 h-px bg-white/[0.08] rounded-full overflow-hidden">
        <div
          className="h-full bg-white/60 transition-all duration-200 ease-out rounded-full"
          style={{ width: `${progress}%` }}
        />
      </div>
      <p className="font-mono text-[10px] text-white/15 mt-3">{progress}%</p>
    </div>
  );
}
