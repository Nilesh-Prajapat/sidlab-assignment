import { Button } from '@/components/ui/button';

export default function Navbar() {
  const links = [
    { label: 'Features', href: '#features' },
    { label: 'Architecture', href: '#architecture' },
    { label: 'Preview', href: '#preview' },
    { label: 'Contact', href: '#contact' },
  ];

  return (
    <div className="fixed bottom-6 left-1/2 -translate-x-1/2 z-50">
      <nav className="flex items-center gap-1 px-2 py-2 rounded-2xl bg-white/[0.04] backdrop-blur-2xl border border-white/[0.08] shadow-2xl shadow-black/40">
        {/* Logo */}
        <a
          href="#"
          className="flex items-center justify-center w-10 h-10 rounded-lg bg-white/[0.08] hover:bg-white/[0.12] transition-colors"
        >
          <img
            src="/logo.png"
            alt="TaskFlow"
            className="w-8 h-8 object-cover scale-110"
          />
        </a>

        {/* Divider */}
        <div className="w-px h-6 bg-white/[0.08] mx-1 hidden sm:block" />

        {/* Links - hidden on very small screens */}
        <div className="hidden sm:flex items-center gap-0.5">
          {links.map((link) => (
            <a
              key={link.href}
              href={link.href}
              className="px-3 py-2 rounded-lg text-xs text-white/50 hover:text-white hover:bg-white/[0.06] transition-all duration-200"
            >
              {link.label}
            </a>
          ))}
        </div>

        {/* Divider */}
        <div className="w-px h-6 bg-white/[0.08] mx-1" />

        {/* CTA */}
        <Button asChild size="sm" className="rounded-lg h-9 text-xs">
          <a href="#contact">Get Started</a>
        </Button>
      </nav>
    </div>
  );
}
