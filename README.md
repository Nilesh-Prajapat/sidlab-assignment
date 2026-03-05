# TaskFlow — Personal Task Manager

> Flutter full-stack internship assignment — SidLabs

**Live Website:** [sidlab-assignment-hnv6.vercel.app](https://sidlab-assignment-hnv6.vercel.app)  
**Backend API:** [sidlab-assignment.vercel.app/api](https://sidlab-assignment.vercel.app/api)  
**APK Download:** Available on the landing page

---

## Stack

| Layer        | Tech                                       |
| ------------ | ------------------------------------------ |
| Mobile App   | Flutter + Dart + BLoC                      |
| Landing Page | React JS (Vite) + Tailwind CSS + shadcn/ui |
| Backend API  | Node.js + Express                          |
| Database     | MongoDB Atlas (Mongoose)                   |
| Auth         | JWT + bcrypt                               |
| Hosting      | Vercel                                     |

---

## Project Structure

```
sidlab-assignment/
├── backend/          # Node.js + Express REST API
├── mobile/           # Flutter application
├── website/          # React landing page (Vite)
├── README.md
└── ARCHITECTURE.md
```

---

## Local Setup

### Backend

```bash
cd backend
npm install
```

Create `backend/.env`:

```env
PORT=5000
MONGO_URI=mongodb+srv://<user>:<pass>@cluster.mongodb.net/taskflow
JWT_SECRET=your_jwt_secret
JWT_REFRESH_SECRET=your_refresh_secret
```

```bash
npm run dev
```

API runs at `http://localhost:5000`

---

### Mobile (Flutter)

```bash
cd mobile
flutter pub get
flutter run
```

---

### Website (React)

```bash
cd website
npm install
npm run dev
```

Create `website/.env`:

```env
VITE_API_URL=https://sidlab-assignment.vercel.app
```

Website runs at `http://localhost:5173`

---

## API Reference

All protected routes require `Authorization: Bearer <token>`.

| Method | Endpoint                  | Auth | Description       |
| ------ | ------------------------- | ---- | ----------------- |
| POST   | `/api/auth/register`      | —    | Register user     |
| POST   | `/api/auth/login`         | —    | Login → JWT       |
| GET    | `/api/tasks`              | 🔒   | List user's tasks |
| POST   | `/api/tasks`              | 🔒   | Create task       |
| PUT    | `/api/tasks/:id`          | 🔒   | Update task       |
| DELETE | `/api/tasks/:id`          | 🔒   | Delete task       |
| PATCH  | `/api/tasks/:id/complete` | 🔒   | Toggle complete   |
| POST   | `/api/contact`            | —    | Contact form      |

---

## Features

- **Auth** — Register, login, logout, persistent JWT session
- **Tasks** — Full CRUD, mark complete, due dates, priority levels (LOW/MEDIUM/HIGH)
- **Dashboard** — Live stats: total, completed, pending
- **Filters** — Search and filter by status, priority, keyword
- **Contact** — Landing page form stored in MongoDB
- **Responsive** — Mobile-first Flutter app + responsive React landing page
- **Security** — bcrypt hashing, JWT auth, protected routes, env secrets

---

## Architectural Decisions

See [`ARCHITECTURE.md`](./ARCHITECTURE.md) for the full breakdown covering:

- System diagram
- Task ownership model
- JWT stateless auth
- BLoC state management
- Database schema decisions
- Security considerations

---

_Nilesh Prajapat — SidLabs Flutter Full-Stack Developer Internship_
