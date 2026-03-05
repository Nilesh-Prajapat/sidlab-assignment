import { useState } from 'react';
import { Badge } from '@/components/ui/badge';

const screens = [
  {
    id: 'login',
    label: 'Sign In',
    src: '/framed/s5.png',
    comment: '// secure jwt-based authentication',
    description: 'Clean login screen with email and password. JWT tokens with expiration handling and persistent login.',
  },
  {
    id: 'dashboard',
    label: 'Dashboard',
    src: '/framed/s1.png',
    comment: '// real-time task statistics',
    description: 'Overview of your tasks at a glance — Total, Completed, and Pending counts with a recent task list.',
  },
  {
    id: 'tasks',
    label: 'Tasks',
    src: '/framed/s2.png',
    comment: '// search, filter, swipe to delete',
    description: 'Full task list with search, priority filters, and swipe-to-delete. Pull down to refresh.',
  },
  {
    id: 'create',
    label: 'Create Task',
    src: '/framed/s3.png',
    comment: '// title, description, due date, priority',
    description: 'Add tasks with title, description, a date picker, and Low / Medium / High priority levels.',
  },
  {
    id: 'profile',
    label: 'Profile',
    src: '/framed/s4.png',
    comment: '// manage your account',
    description: 'User profile with task statistics, personal info, appearance settings, and account management.',
  },
 
];

export default function AppPreview() {
  const [active, setActive] = useState(1);

  return (
    <section id="preview" className="py-28 sm:py-36 relative overflow-hidden">
      <div className="max-w-6xl mx-auto px-6">
        {/* Header */}
        <div className="mb-16">
          <p className="font-mono text-sm text-white/25 mb-4">// app preview</p>
          <h2 className="text-4xl sm:text-5xl font-black text-white leading-tight tracking-tight">
            See it in action
          </h2>
          <p className="mt-4 text-white/45 text-base max-w-md">
            A minimal Flutter app with a clean, dark interface.
          </p>
        </div>

        {/* ── Mobile: horizontal scroll (show pre-framed images) ── */}
        <div className="lg:hidden">
          <div className="flex gap-6 overflow-x-auto pb-6 snap-x snap-mandatory -mx-6 px-6">
            {screens.map((screen) => (
              <div key={screen.id} className="flex-shrink-0 snap-center flex flex-col items-center gap-3">
                {/* No phone wrapper — image already has Pixel 7 frame */}
                <img
                  src={screen.src}
                  alt={screen.label}
                  className="h-[420px] w-auto object-contain select-none drop-shadow-2xl"
                  loading="lazy"
                />
                <p className="text-white text-sm font-medium">{screen.label}</p>
                <p className="font-mono text-[11px] text-white/20 text-center">{screen.comment}</p>
              </div>
            ))}
          </div>
        </div>

        {/* ── Desktop: split layout ── */}
        <div className="hidden lg:grid grid-cols-2 gap-20 items-center">
          {/* Left — feature list */}
          <div className="space-y-2">
            {screens.map((screen, idx) => (
              <button
                key={screen.id}
                onClick={() => setActive(idx)}
                className={`w-full text-left px-6 py-5 rounded-2xl transition-all duration-300 cursor-pointer group ${
                  active === idx
                    ? 'bg-white/[0.07] border border-white/[0.12]'
                    : 'hover:bg-white/[0.03] border border-transparent'
                }`}
              >
                <div className="flex items-center justify-between mb-1.5">
                  <span className={`text-base font-semibold transition-colors duration-300 ${
                    active === idx ? 'text-white' : 'text-white/35 group-hover:text-white/55'
                  }`}>
                    {screen.label}
                  </span>
                  {active === idx && <div className="w-2 h-2 rounded-full bg-white" />}
                </div>
                <p className={`font-mono text-xs transition-colors duration-300 ${
                  active === idx ? 'text-white/30' : 'text-white/12'
                }`}>
                  {screen.comment}
                </p>
              </button>
            ))}

            <div className="pt-6 flex flex-wrap gap-2 px-6">
              {['Flutter', 'Node.js', 'MongoDB', 'JWT', 'BLoC'].map((tech) => (
                <Badge key={tech} variant="secondary" className="text-xs font-mono py-1 px-3">
                  {tech}
                </Badge>
              ))}
            </div>
          </div>

          {/* Right — pre-framed Pixel 7 image (no wrapper needed) */}
          <div className="flex flex-col items-center gap-8">
            <img
              src={screens[active].src}
              alt={screens[active].label}
              className="h-[540px] w-auto object-contain select-none drop-shadow-2xl transition-all duration-500"
            />
            <div className="text-center max-w-xs">
              <p className="text-white font-semibold text-base">{screens[active].label}</p>
              <p className="text-white/40 text-sm leading-relaxed mt-2">{screens[active].description}</p>
              <p className="font-mono text-xs text-white/15 mt-3">{screens[active].comment}</p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
