import { Separator } from '@/components/ui/separator';

export default function Footer() {
  return (
    <footer className="border-t border-border">
      <div className="max-w-6xl mx-auto px-6 py-12">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-10">
          {/* Brand */}
          <div>
            <a href="#" className="flex items-center gap-2.5 mb-4">
              <img
                src="/logo.png"
                alt="TaskFlow"
                className="w-8 h-8 object-cover scale-110"
              />
              <span className="text-foreground font-semibold text-base tracking-tight">
                TaskFlow
              </span>
            </a>
            <p className="text-muted-foreground text-sm leading-relaxed max-w-xs">
              A personal task manager built with Flutter, Node.js, and MongoDB.
            </p>
          </div>

          {/* Quick Links */}
          <div>
            <h4 className="text-foreground font-medium text-xs uppercase tracking-[0.15em] mb-4">Quick Links</h4>
            <ul className="space-y-2">
              {[
                { label: 'Features', href: '#features' },
                { label: 'Preview', href: '#preview' },
                { label: 'Contact', href: '#contact' },
              ].map((link) => (
                <li key={link.href}>
                  <a href={link.href} className="text-muted-foreground hover:text-foreground text-sm transition-colors">
                    {link.label}
                  </a>
                </li>
              ))}
            </ul>
          </div>

          {/* Tech Stack */}
          <div>
            <h4 className="text-foreground font-medium text-xs uppercase tracking-[0.15em] mb-4">Built With</h4>
            <ul className="space-y-2">
              {['Flutter & Dart', 'Node.js & Express', 'MongoDB & Mongoose', 'React & Vite', 'Tailwind CSS'].map((tech) => (
                <li key={tech} className="text-muted-foreground text-sm">
                  {tech}
                </li>
              ))}
            </ul>
          </div>
        </div>

        <Separator className="my-8" />

        <div className="flex flex-col sm:flex-row items-center justify-between gap-4">
          <p className="text-muted-foreground text-xs">
            © {new Date().getFullYear()} TaskFlow. SidLabs Internship Assignment.
          </p>
          <p className="text-muted-foreground text-xs">
            Made by Nilesh Prajapat
          </p>
        </div>
      </div>
    </footer>
  );
}
