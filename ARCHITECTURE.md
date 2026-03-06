# Architecture — TaskFlow

## Overview

TaskFlow is a **personal task manager** — each authenticated user can only see and manage their own tasks. There is no team/assignment feature; tasks are owned by the user who creates them.

---

## System Diagram

```
┌─────────────────────────────┐     ┌────────────────────────────────┐
│   Flutter App (Mobile)      │     │   React Website (Vite)         │
│                             │     │                                │
│   BLoC State Management     │     │   Landing page, screenshots,   │
│   auth_bloc / task_bloc     │     │   features, architecture,      │
│   SharedPreferences → JWT   │     │   contact form                 │
└────────────┬────────────────┘     └────────────┬───────────────────┘
             │                                   │
             │  HTTP + Bearer <token>            │  HTTP (no auth)
             │                                   │
             └──────────────┬────────────────────┘
                            │
                            ▼
┌───────────────────────────────────────────────────────────────────┐
│                  Node.js + Express API                            │
│                  (Vercel serverless)                              │
│                                                                   │
│  cors() → express.json() → routes → auth_middleware → controller │
│                                                                   │
│  /api/auth    → auth_controller    (register, login,             │
│                                    forgot-password,              │
│                                    change-password,              │
│                                    delete-account)               │
│  /api/tasks   → task_controller    (CRUD, userId scoped)         │
│  /api/contact → contact_controller (store message)               │
└────────────────────────────┬──────────────────────────────────────┘
                             │
                             │ Mongoose ODM
                             ▼
┌───────────────────────────────────────────────────────────────────┐
│                     MongoDB Atlas                                 │
│                                                                   │
│  users     { name, email (unique), password (bcrypt), petName } │
│  tasks     { userId (ref), title, priority, completed, dueDate } │
│  contacts  { name, email, message }                               │
└───────────────────────────────────────────────────────────────────┘
```

---

## Backend Structure

```
backend/
├── src/
│   ├── app.js                  # Express setup, middleware, route mounting
│   ├── server.js               # Entry point — DB connect + listen
│   ├── config/
│   │   ├── db.js               # Mongoose connection
│   │   └── config.js           # Env variable exports
│   ├── middleware/
│   │   └── auth.js             # JWT verify → inject req.userId
│   ├── models/
│   │   ├── user.js             # User schema (name, email, password, petName)
│   │   ├── task.js             # Task schema + virtual status field
│   │   └── contact.js          # Contact schema
│   ├── controllers/
│   │   ├── auth_controller.js  # register, login, forgotPassword,
│   │   │                       # changePassword, deleteAccount
│   │   ├── task_controller.js  # get, create, update, delete, toggle
│   │   └── contact_controller.js
│   └── routes/
│       ├── auth_route.js       # register, login, forgot-password,
│       │                       # change-password, delete-account
│       ├── task_route.js
│       └── contact_route.js
├── index.js                    # Vercel entry point
└── vercel.json                 # Vercel config
```

---

## Mobile Structure

```
mobile/lib/
├── main.dart
├── api_service/
│   ├── auth_service.dart       # HTTP calls to /api/auth
│   ├── auth_bloc.dart          # Auth state management
│   ├── task_service.dart       # HTTP calls to /api/tasks
│   └── task_bloc.dart          # Task state management
├── screens/
│   ├── splash_screen.dart      # JWT check → route
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── home/
│   │   └── home_screen.dart    # Dashboard
│   ├── tasks/
│   │   ├── task_list_screen.dart
│   │   ├── create_task_screen.dart
│   │   └── task_detail_screen.dart
│   └── profile/
│       └── profile_screen.dart
├── widget/                     # Reusable UI components
└── utils/                      # Theme, colors, validator
```

---

## Key Architectural Decisions

### 1. Personal task ownership

Every task stores `userId` (ObjectId ref to the User). Every task query filters by `req.userId` injected by auth middleware. No task is ever shared between users.

### 2. JWT stateless auth

No session store — tokens are verified on every request using the `JWT_SECRET`. The Flutter app stores the token in `SharedPreferences` and attaches it as `Authorization: Bearer <token>`.

### 3. BLoC pattern (Flutter)

Business logic is separated into BLoC classes (`auth_bloc.dart`, `task_bloc.dart`). Screens only emit events and react to states — no direct API calls from widgets.

### 4. Virtual `status` field on Task

Rather than storing a `status` string (which could go out of sync with `completed`), the Task model has a Mongoose virtual that computes `Pending` / `Completed` / `Overdue` at query time.

### 5. Monorepo layout

All three layers (backend, mobile, website) live in one repository for easy submission and cross-reference. Each has its own `package.json` / `pubspec.yaml` and runs independently.

### 6. Vercel serverless deployment

`backend/index.js` exports the Express `app`. `vercel.json` routes all traffic to it. This allows zero-config Node.js deployment with automatic HTTPS.

---

## Security Considerations

| Concern            | Approach                                                       |
| ------------------ | -------------------------------------------------------------- |
| Password storage   | `bcrypt` hash, never plain text                                |
| Token transmission | `Authorization: Bearer` header only                            |
| Route protection   | `auth_middleware` on `/api/tasks` + change-password, delete-account |
| Password recovery  | `petName` security hint — no email link, no OTP required       |
| CORS               | `cors()` enabled for React + Flutter origins                   |
| Env secrets        | `.env` file, never committed (`/backend/.env` in `.gitignore`) |
| Token expiry       | JWT signed with expiry; client handles 401 by re-login         |
