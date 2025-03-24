<h1 align="center">
    <img src="apps/tasque/assets/logo/logo-1024.png" height="200px" alt="BookMyShow Tracker logo" />
    <br>
    Tasque
</h1>

## Project Overview

Tasque is a **Flutter-based task management application** designed for efficient task tracking, synchronization, and collaboration. It offers **real-time updates** with Firebase and follows a clean and modern design.

## Core Features

- **Task Management:** Create, update, delete, and view tasks.
- **Task Prioritization:** Assign priority levels (Low, Medium, High) to tasks.
- **Task Synchronization:** Sync tasks with Firebase Firestore.
- **User Authentication:** Google Sign-In and Firebase Authentication.
- **Search & Filtering:** Search tasks and filter by status, priority, or due date.
- **Connectivity Monitoring:** Detects online/offline status for a seamless experience.
- **Theming & UI:** Modern UI inspired by a [dribbble](https://dribbble.com/shots/23472405-Streamline-Mobile-App-Design) design.

---

## Project Architecture

Tasque follows a **feature-based architecture** with a clean separation of concerns and uses a **monorepo structure** managed by Melos:

- **app/tasque**: Main Flutter application.
  - **core/**: Common utilities like themes, database setup, and routing.
  - **features/**: Specific modules such as authentication and task management.
  - **shared/**: Shared widgets, extensions, and utilities.

---

## Database & Data Synchronization

- **ObjectBox:** Local database for efficient data storage.
- **Firebase Firestore:** Stores and synchronizes tasks in real time.
- **Repository Pattern:** Abstracts data sources for better scalability and testability.

### Repository Structure

- `task_repository.dart` - Provides an abstraction layer for accessing tasks.
- `task_sync_repository.dart` - Provides an abstraction layer for task synchronization.

---

## State Management

Tasque uses **Bloc (Cubit)** for state management, ensuring a reactive and scalable architecture.

---

## UI Design

- **Dashboard Screen:** Displays task summary, recent tasks, and create task form.
- **Task List Screen:** Shows a full list of tasks with search and filters.
- **Task Details Screen:** Provides details of a selected task with options to update or delete.
- **Authentication Screen:** Google Sign-In based authentication.

---

## Navigation & Routing

- **GoRouter:** Manages type-safe navigation between screens.
- **Predefined Routes:** Centralized control in `routes.dart`.
- **Deep Linking Capability:** Enables navigation through URL schemes.

---

## Packages & Tools Used

| Package                 | Purpose                          |
| ----------------------- | -------------------------------- |
| flutter_bloc            | State management (Cubit)         |
| go_router               | Navigation and routing           |
| cloud_firestore         | Firebase Firestore integration   |
| firebase_auth           | User authentication              |
| google_sign_in          | Google authentication support    |
| objectbox               | Local database                   |
| freezed                 | Data models and serialization    |
| lottie                  | Animations for better UX         |
| form_builder_validators | Form validation utilities        |
| intl                    | Date formatting and localization |
| connectivity_plus       | Network connectivity monitoring  |

---

## Setup & Installation

### Prerequisites

- Flutter SDK (check the version in `.fvmrc` file)

### Steps to Run Locally

1. **Clone the repository:**
   ```sh
   git clone https://github.com/albinpk/tasque.git
   cd tasque # project root
   ```
2. **Navigate to the Flutter app directory:**
   ```sh
   cd apps/tasque # Flutter app directory
   ```
3. **Install dependencies:**
   ```sh
   flutter pub get
   ```
4. **Generate necessary files:**
   ```sh
   dart run build_runner build --delete-conflicting-outputs
   ```
5. **Run the app:**
   ```sh
   flutter run
   ```

---

## Future Enhancements (todo)

- **Import/Export Feature:** Enable data backup and restore.
- **Push Notifications:** Reminders for due tasks.

---

**Tasque - Making Task Management Simpler!**
