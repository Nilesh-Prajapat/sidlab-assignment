import { Card, CardContent } from '@/components/ui/card';

const features = [
  {
    icon: (
      <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4" />
      </svg>
    ),
    title: 'Task Management',
    description: 'Create, update, delete and manage tasks effortlessly. Mark complete with a single tap.',
  },
  {
    icon: (
      <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M3 4h13M3 8h9m-9 4h6m4 0l4-4m0 0l4 4m-4-4v12" />
      </svg>
    ),
    title: 'Priority Levels',
    description: 'Organize tasks by Low, Medium, or High priority. Always know what to do next.',
  },
  {
    icon: (
      <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
      </svg>
    ),
    title: 'Dashboard Stats',
    description: 'Real-time overview of Total, Completed, and Pending tasks at a glance.',
  },
  {
    icon: (
      <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
      </svg>
    ),
    title: 'Secure Auth',
    description: 'JWT authentication with bcrypt hashing. Tokens stored securely on device.',
  },
  {
    icon: (
      <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586a1 1 0 01-.293.707l-6.414 6.414a1 1 0 00-.293.707V17l-4 4v-6.586a1 1 0 00-.293-.707L3.293 7.293A1 1 0 013 6.586V4z" />
      </svg>
    ),
    title: 'Smart Filters',
    description: 'Search and filter by status, priority, or keywords instantly.',
  },
  {
    icon: (
      <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M12 18h.01M8 21h8a2 2 0 002-2V5a2 2 0 00-2-2H8a2 2 0 00-2 2v14a2 2 0 002 2z" />
      </svg>
    ),
    title: 'Mobile First',
    description: 'Beautiful Flutter app built for Android and iOS with native performance.',
  },
];

export default function Features() {
  return (
    <section id="features" className="py-28 sm:py-36 relative">
      <div className="max-w-6xl mx-auto px-6">
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-12 lg:gap-16">
          {/* Right sticky header */}
          <div className="lg:sticky lg:top-28 lg:self-start lg:order-2">
            <p className="font-mono text-sm text-white/25 mb-4">// features</p>
            <h2 className="text-4xl sm:text-5xl font-black text-white leading-[1.05] tracking-tight">
              Everything
              <br />
              you need
            </h2>
            <p className="mt-5 text-white/45 text-base leading-relaxed max-w-xs">
              Built with clean architecture and modern technologies for a seamless experience.
            </p>
            <div className="mt-8 flex items-center gap-3">
              <img src="/logo.png" alt="" className="w-7 h-7 object-cover scale-110 opacity-30" />
              <span className="font-mono text-xs text-white/20">// 6 core features</span>
            </div>
          </div>

          {/* Left cards — 2 col */}
          <div className="lg:col-span-2 grid grid-cols-1 sm:grid-cols-2 gap-4 lg:order-1">
            {features.map((feature, idx) => (
              <Card key={idx} className="bg-card hover:bg-secondary/60 transition-all duration-300 border-border group">
                <CardContent className="p-6">
                  <div className="w-11 h-11 rounded-xl bg-secondary text-white flex items-center justify-center mb-4 group-hover:scale-110 transition-transform duration-300">
                    {feature.icon}
                  </div>
                  <h3 className="text-base font-semibold text-white mb-2">{feature.title}</h3>
                  <p className="text-white/45 text-sm leading-relaxed">{feature.description}</p>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}
