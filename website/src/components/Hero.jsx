import { Button } from '@/components/ui/button';

export default function Hero() {
  return (
    <section className="relative min-h-screen flex items-center overflow-hidden">
      {/* Dot grid */}
      <div
        className="absolute inset-0 opacity-[0.03]"
        style={{
          backgroundImage: 'radial-gradient(circle, white 1px, transparent 1px)',
          backgroundSize: '40px 40px',
        }}
      />

      <div className="relative max-w-6xl mx-auto px-6 py-32 w-full">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-16 items-center">

          {/* ── Left – Content ── */}
          <div>
            <div className="animate-fade-in-up flex items-center gap-4 mb-10">
              <img src="/logo.png" alt="TaskFlow" className="w-14 h-14 object-cover scale-110" />
              <div>
                <p className="text-white font-semibold text-base tracking-tight">TaskFlow</p>
                <p className="font-mono text-xs text-white/30 mt-0.5">// personal task manager</p>
              </div>
            </div>

            <h1 className="animate-fade-in-up-delay-1 text-5xl sm:text-6xl lg:text-7xl font-black text-white leading-[1.0] tracking-tighter mb-8">
              Organize
              <br />
              your work
              <br />
              <span className="text-white/30">&amp; life.</span>
            </h1>

            <p className="animate-fade-in-up-delay-2 text-lg text-white/50 max-w-md mb-10 leading-relaxed">
              A beautifully crafted task manager — stay focused,
              prioritize what matters, and get more done.
            </p>

            <div className="animate-fade-in-up-delay-3 flex flex-wrap gap-4">
              <Button asChild size="lg" className="text-base px-7 h-12 rounded-xl font-semibold">
                <a href="#preview">View Demo →</a>
              </Button>
              <Button asChild variant="outline" size="lg" className="text-base px-7 h-12 rounded-xl font-semibold border-white/20 hover:border-white/40">
                <a href="/TaskFlow.apk" download>
                  <svg className="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" />
                  </svg>
                  Download APK
                </a>
              </Button>
            </div>

            <div className="animate-fade-in-up-delay-3 mt-14 font-mono text-xs text-white/15 space-y-1.5">
              <p>// flutter · node.js · mongodb</p>
              <p>// jwt auth · bcrypt · bloc pattern</p>
            </div>
          </div>

          {/* ── Right – Pixel 7 framed screenshot ── */}
          <div className="hidden lg:flex justify-center items-center">
            {/* Two phones — main + offset */}
            <div className="relative w-full flex items-center justify-center">
              {/* Back phone (offset, dimmed) */}
              <img
                src="/framed/s1.png"
                alt="Sign In"
                className="absolute h-[520px] w-auto object-contain opacity-25 drop-shadow-2xl translate-x-28 -translate-y-4 rotate-6"
              />
              {/* Front phone */}
              <img
                src="/framed/s2.png"
                alt="Dashboard"
                className="relative h-[580px] w-auto object-contain drop-shadow-2xl"
              />
            </div>
          </div>
        </div>

        {/* Mobile – single framed image below content */}
        <div className="mt-14 flex justify-center lg:hidden">
          <img
            src="/framed/s2.png"
            alt="Dashboard Preview"
            className="h-[380px] w-auto object-contain drop-shadow-2xl"
          />
        </div>
      </div>
    </section>
  );
}
