# TaskFlow — Personal Task Manager

A full-stack personal task manager built as a SidLabs internship assignment.

## Stack

| Layer        | Tech                                       |
| ------------ | ------------------------------------------ |
| Mobile App   | Flutter + Dart + BLoC                      |
| Landing Page | React JS (Vite) + Tailwind CSS + shadcn/ui |
| Backend API  | Node.js + Express                          |
| Database     | MongoDB (Mongoose)                         |
| Auth         | JWT + bcrypt                               |
| Hosting      | Vercel (backend)                           |

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

## Quick Start

### 1. Backend

```bash
cd backend
npm install
```

Create `.env`:

```env
PORT=5000
MONGO_URI=mongodb+srv://<user>:<pass>@cluster.mongodb.net/taskflow
JWT_SECRET=your_jwt_secret
JWT_REFRESH_SECRET=your_refresh_secret
```

```bash
npm run dev        # development
npm start          # production
```

API runs at `http://localhost:5000`

**Live API:** `https://sidlab-assignment.vercel.app`

---

### 2. Mobile (Flutter)

```bash
cd mobile
flutter pub get
flutter run
```

> Update the base URL in `lib/api_service/auth_service.dart` and `task_service.dart` if your backend is running locally.

---

### 3. Website (React)

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

## API Endpoints

| Method | Endpoint                  | Auth | Description     |
| ------ | ------------------------- | ---- | --------------- |
| POST   | `/api/auth/register`      | —    | Register user   |
| POST   | `/api/auth/login`         | —    | Login → JWT     |
| GET    | `/api/tasks`              | 🔒   | List user tasks |
| POST   | `/api/tasks`              | 🔒   | Create task     |
| PUT    | `/api/tasks/:id`          | 🔒   | Update task     |
| DELETE | `/api/tasks/:id`          | 🔒   | Delete task     |
| PATCH  | `/api/tasks/:id/complete` | 🔒   | Toggle complete |
| POST   | `/api/contact`            | —    | Contact form    |

---

## Features

- **Auth** — Register, login, logout, persistent JWT session
- **Tasks** — Create, read, update, delete, mark complete
- **Priorities** — LOW / MEDIUM / HIGH per task
- **Filters** — Filter by status, priority, keyword
- **Dashboard** — Live stats: total, completed, pending
- **Contact** — Landing page form stored in MongoDB
- **Responsive** — Mobile-first Flutter app + responsive React site

---

## Architectural Decisions

See [`ARCHITECTURE.md`](./ARCHITECTURE.md) for detailed decisions.

---

## Submission

- **GitHub:** [sidlab-assignment](https://github.com/Nilesh-Prajapat/sidlab-assignment)
- **Live API:** `https://sidlab-assignment.vercel.app`
- **APK:** `website/public/TaskFlow.apk`

---

_Made by Nilesh Prajapat — SidLabs Flutter Full-Stack Developer Internship Assignment_
