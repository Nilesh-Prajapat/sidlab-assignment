import { useState } from 'react';
import { Card, CardContent } from '@/components/ui/card';

/* ── primitives ── */
function DiagramBox({ label, sublabel, items = [], wide = false }) {
  return (
    <div className={`diagram-box ${wide ? 'w-full' : ''}`}>
      <div className="diagram-box-header px-5 py-3">
        <p className="text-white/80 text-xs font-bold tracking-widest uppercase">{label}</p>
        {sublabel && <p className="font-mono text-[11px] text-white/30 mt-0.5">{sublabel}</p>}
      </div>
      {items.length > 0 && (
        <div className="px-5 py-3 space-y-1">
          {items.map((item, i) => (
            <p key={i} className="text-white/45 text-[12px] leading-relaxed">
              <span className="text-white/20 mr-2">•</span>{item}
            </p>
          ))}
        </div>
      )}
    </div>
  );
}

function ArrowDown({ label }) {
  return (
    <div className="flex flex-col items-center py-3 gap-1">
      <svg width="2" height="32" viewBox="0 0 2 32" className="overflow-visible">
        <line x1="1" y1="0" x2="1" y2="22" stroke="rgba(255,255,255,0.12)" strokeWidth="1" strokeDasharray="4 3" />
        <polygon points="1,32 -4,20 6,20" fill="rgba(255,255,255,0.2)" />
      </svg>
      {label && <span className="font-mono text-[10px] text-white/15">{label}</span>}
    </div>
  );
}

function MacroBlock({ title, sublabel, children, highlight = false }) {
  return (
    <div className={`diagram-macro ${highlight ? 'border-white/[0.14]' : 'border-white/[0.07]'}`}>
      <div className="border-b border-white/[0.08] pb-4 mb-6 flex items-center gap-3">
        <img src="/logo.png" alt="" className="w-8 h-8 object-cover scale-110 opacity-20" />
        <div>
          <p className="text-white/75 font-bold text-sm tracking-widest uppercase">{title}</p>
          {sublabel && <p className="font-mono text-[11px] text-white/25 mt-0.5">{sublabel}</p>}
        </div>
      </div>
      {children}
    </div>
  );
}

function SectionLabel({ label }) {
  return <p className="font-mono text-[11px] text-white/25 mb-2 mt-3">{label}</p>;
}

function Endpoint({ method, path, desc, auth }) {
  return (
    <div className="flex items-center gap-4 font-mono text-[12px] py-2.5 border-b border-white/[0.05] last:border-0">
      <span className="font-bold shrink-0 w-16 text-white/60">{method}</span>
      <span className="text-white/35 flex-1">{path}</span>
      <span className="text-white/20 hidden sm:block text-[11px]">{desc}</span>
      {auth && <span className="text-white/20 text-[11px]">🔒</span>}
    </div>
  );
}

/* ── Mobile accordion layer ── */
const mobileLayers = [
  {
    id: 'client',
    title: 'Flutter App',
    sublabel: '// dart · bloc · shared_preferences',
    rows: [
      { label: 'Screens', value: 'splash · login · register · home · tasks · profile' },
      { label: 'Widgets', value: 'task_card · app_button · app_input · priority_selector' },
      { label: 'BLoC', value: 'auth_bloc · task_bloc (state management)' },
      { label: 'Services', value: 'auth_service · task_service (HTTP calls)' },
      { label: 'Storage', value: 'SharedPreferences → JWT token persisted' },
    ],
  },
  {
    id: 'server',
    title: 'Node.js API',
    sublabel: '// https://sidlab-assignment.vercel.app',
    rows: [
      { label: 'Middleware', value: 'cors() · express.json()' },
      { label: 'Routes', value: '/api/auth · /api/tasks · /api/contact' },
      { label: 'Auth MW', value: 'jwt.verify(token) → inject req.userId' },
      { label: 'Controllers', value: 'auth_controller · task_controller · contact_controller' },
      { label: 'Models', value: 'User · Task · Contact (Mongoose schemas)' },
    ],
  },
  {
    id: 'db',
    title: 'MongoDB Atlas',
    sublabel: '// cloud · 3 collections',
    rows: [
      { label: 'users', value: '_id · name · email (unique) · password (hashed)' },
      { label: 'tasks', value: '_id · userId (ref) · title · priority · completed · dueDate' },
      { label: 'contacts', value: '_id · name · email · message · timestamps' },
    ],
  },
  {
    id: 'endpoints',
    title: 'API Endpoints',
    sublabel: '// REST API quick reference',
    rows: [
      { label: 'POST', value: '/api/auth/register — create account' },
      { label: 'POST', value: '/api/auth/login — returns JWT' },
      { label: 'GET 🔒', value: '/api/tasks — list user tasks' },
      { label: 'POST 🔒', value: '/api/tasks — create task' },
      { label: 'PUT 🔒', value: '/api/tasks/:id — update task' },
      { label: 'DELETE 🔒', value: '/api/tasks/:id — delete task' },
      { label: 'PATCH 🔒', value: '/api/tasks/:id/complete — toggle' },
      { label: 'POST', value: '/api/contact — contact form' },
    ],
  },
];

export default function Architecture() {
  const [mobileTab, setMobileTab] = useState('client');

  return (
    <section id="architecture" className="py-28 sm:py-36 relative">
      <div className="max-w-5xl mx-auto px-6">
        {/* Header */}
        <div className="text-center mb-16">
          <p className="font-mono text-sm text-white/25 mb-4">// architecture</p>
          <h2 className="text-4xl sm:text-5xl font-black text-white tracking-tight">How it all works</h2>
          <p className="mt-4 text-white/45 text-base max-w-lg mx-auto">
            Full-stack data flow from Flutter client through the REST API to MongoDB.
          </p>
        </div>

        {/* ──────────────── MOBILE: tab switcher ──────────────── */}
        <div className="lg:hidden">
          {/* Tab pills */}
          <div className="flex gap-2 overflow-x-auto pb-1 mb-6 scrollbar-hide">
            {mobileLayers.map((layer) => (
              <button
                key={layer.id}
                onClick={() => setMobileTab(layer.id)}
                className={`shrink-0 px-4 py-2 rounded-full text-sm font-medium transition-all duration-200 cursor-pointer border ${
                  mobileTab === layer.id
                    ? 'bg-white text-black border-white'
                    : 'bg-transparent text-white/40 border-white/10 hover:border-white/25'
                }`}
              >
                {layer.title}
              </button>
            ))}
          </div>

          {/* Active layer card */}
          {mobileLayers.map((layer) =>
            mobileTab === layer.id ? (
              <Card key={layer.id} className="bg-card border-border">
                <CardContent className="p-5">
                  <p className="text-white font-bold text-base mb-0.5">{layer.title}</p>
                  <p className="font-mono text-[11px] text-white/25 mb-5">{layer.sublabel}</p>
                  <div className="space-y-4">
                    {layer.rows.map((row, i) => (
                      <div key={i}>
                        <p className="text-white/60 text-xs font-semibold uppercase tracking-wider mb-1">{row.label}</p>
                        <p className="text-white/40 text-sm leading-relaxed">{row.value}</p>
                      </div>
                    ))}
                  </div>
                </CardContent>
              </Card>
            ) : null
          )}
        </div>

        {/* ──────────────── DESKTOP: full box diagram ──────────────── */}
        <div className="hidden lg:block">
          {/* CLIENT */}
          <MacroBlock title="Client — Flutter App" sublabel="// dart · bloc · shared_preferences" highlight>
            <SectionLabel label="// screens" />
            <div className="grid grid-cols-6 gap-2 mb-4">
              {['splash_screen', 'login_screen', 'register_screen', 'home_screen', 'task_list_screen', 'profile_screen'].map(s => (
                <div key={s} className="border border-white/[0.09] rounded-lg px-2 py-2 font-mono text-[10px] text-white/35 text-center">{s}</div>
              ))}
            </div>
            <ArrowDown />
            <SectionLabel label="// widgets" />
            <div className="grid grid-cols-5 gap-2 mb-4">
              {['task_card', 'task_tile', 'app_button', 'app_input', 'priority_selector'].map(w => (
                <div key={w} className="border border-white/[0.09] rounded-lg px-2 py-2 font-mono text-[10px] text-white/35 text-center">{w}</div>
              ))}
            </div>
            <ArrowDown />
            <SectionLabel label="// state management (BLoC)" />
            <div className="grid grid-cols-2 gap-3 mb-4">
              <DiagramBox label="auth_bloc.dart" sublabel="// manages login / logout state"
                items={['AuthInitial → AuthLoading', 'AuthAuthenticated (JWT stored)', 'AuthUnauthenticated (redirect)']} />
              <DiagramBox label="task_bloc.dart" sublabel="// manages task CRUD state"
                items={['TaskLoading → TaskLoaded', 'TaskCreated / TaskUpdated', 'TaskDeleted / TaskError']} />
            </div>
            <ArrowDown />
            <SectionLabel label="// service layer" />
            <div className="grid grid-cols-2 gap-3">
              <DiagramBox label="auth_service.dart" sublabel="// POST /auth/register · /auth/login"
                items={['register(name, email, password)', 'login(email, password) → JWT', 'stores token via SharedPreferences']} />
              <DiagramBox label="task_service.dart" sublabel="// GET · POST · PUT · DELETE · PATCH"
                items={['getTasks() → List<Task>', 'createTask / updateTask / deleteTask', 'toggleComplete(id)']} />
            </div>
          </MacroBlock>

          <div className="flex flex-col items-center py-2">
            <ArrowDown />
            <div className="diagram-box px-6 py-3">
              <p className="font-mono text-[11px] text-white/40 text-center">HTTP/HTTPS · Authorization: Bearer &lt;jwt&gt; · Content-Type: application/json</p>
            </div>
            <ArrowDown />
          </div>

          {/* SERVER */}
          <MacroBlock title="Server — Node.js + Express" sublabel="// https://sidlab-assignment.vercel.app" highlight>
            <SectionLabel label="// middleware" />
            <DiagramBox label="app.js" sublabel="// applied to every request" wide
              items={['cors() → Allow all origins', 'express.json() → Parse JSON bodies']} />
            <ArrowDown />
            <SectionLabel label="// routes" />
            <div className="grid grid-cols-3 gap-3">
              <DiagramBox label="/api/auth" sublabel="// public"
                items={['POST /register', 'POST /login']} />
              <DiagramBox label="/api/tasks" sublabel="// 🔒 protected"
                items={['GET /', 'POST /', 'PUT /:id', 'DELETE /:id', 'PATCH /:id/complete']} />
              <DiagramBox label="/api/contact" sublabel="// public"
                items={['POST /']} />
            </div>
            <ArrowDown />
            <SectionLabel label="// auth middleware" />
            <DiagramBox label="middleware/auth.js" sublabel="// JWT verification" wide
              items={['reads req.headers.authorization', 'jwt.verify(token, JWT_SECRET) → decoded', 'injects req.userId · returns 401 if invalid']} />
            <ArrowDown />
            <SectionLabel label="// controllers" />
            <div className="grid grid-cols-3 gap-3">
              <DiagramBox label="auth_controller.js"
                items={['register → bcrypt.hash → User.create', 'login → bcrypt.compare → jwt.sign']} />
              <DiagramBox label="task_controller.js"
                items={['get_tasks → Task.find({ userId })', 'create_task · update_task', 'delete_task · toggle_complete']} />
              <DiagramBox label="contact_controller.js"
                items={['createContact → Contact.create']} />
            </div>
            <ArrowDown />
            <SectionLabel label="// models (Mongoose)" />
            <div className="grid grid-cols-3 gap-3">
              <DiagramBox label="User model"
                items={['name: String (req)', 'email: String (unique)', 'password: String (hashed)', 'timestamps: true']} />
              <DiagramBox label="Task model"
                items={['userId: ObjectId → User', 'title: String (req)', 'completed: Boolean', 'dueDate: Date', 'priority: LOW|MEDIUM|HIGH', 'virtual: status']} />
              <DiagramBox label="Contact model"
                items={['name · email · message', 'timestamps: true']} />
            </div>
          </MacroBlock>

          <div className="flex flex-col items-center py-2">
            <ArrowDown />
            <div className="diagram-box px-6 py-3">
              <p className="font-mono text-[11px] text-white/40 text-center">Mongoose ODM · mongodb+srv:// · MongoDB Atlas Cloud</p>
            </div>
            <ArrowDown />
          </div>

          {/* DATABASE */}
          <MacroBlock title="Database — MongoDB Atlas" sublabel="// cloud · 3 collections">
            <div className="grid grid-cols-3 gap-3">
              <DiagramBox label="users collection"
                items={['_id', 'name', 'email (unique index)', 'password (bcrypt)', 'createdAt / updatedAt']} />
              <DiagramBox label="tasks collection"
                items={['_id', 'userId → ref: users', 'title · description', 'completed: false', 'dueDate · priority', 'createdAt / updatedAt']} />
              <DiagramBox label="contacts collection"
                items={['_id', 'name · email · message', 'createdAt / updatedAt']} />
            </div>
          </MacroBlock>

          {/* Endpoint quick-ref */}
          <div className="diagram-box mt-6">
            <div className="diagram-box-header px-5 py-3 flex items-center gap-3">
              <img src="/logo.png" alt="" className="w-5 h-5 object-cover scale-110 opacity-25" />
              <div>
                <p className="text-white/70 text-xs font-bold tracking-widest uppercase">API Quick Reference</p>
                <p className="font-mono text-[11px] text-white/25">https://sidlab-assignment.vercel.app/api</p>
              </div>
            </div>
            <div className="px-5 py-2">
              <Endpoint method="POST" path="/api/auth/register" desc="Create account" auth={false} />
              <Endpoint method="POST" path="/api/auth/login" desc="Get JWT" auth={false} />
              <Endpoint method="GET" path="/api/tasks" desc="List tasks" auth={true} />
              <Endpoint method="POST" path="/api/tasks" desc="Create task" auth={true} />
              <Endpoint method="PUT" path="/api/tasks/:id" desc="Update task" auth={true} />
              <Endpoint method="DELETE" path="/api/tasks/:id" desc="Delete task" auth={true} />
              <Endpoint method="PATCH" path="/api/tasks/:id/complete" desc="Toggle done" auth={true} />
              <Endpoint method="POST" path="/api/contact" desc="Contact form" auth={false} />
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
