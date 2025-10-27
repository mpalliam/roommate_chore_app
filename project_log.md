# 🧩 Roommate Chore & Penalty App – Project Log

## Overview
This app helps roommates manage chores fairly, track task completion, and handle penalties for missed tasks.  
It also maintains a shared fund that collects penalties, encouraging accountability and teamwork.

The app is being built using **Flutter** (Dart language).  
All code is written manually for learning purposes, with guidance and explanations at each step.

---

## 1. Core Features
- Add, edit, and delete chores.  
- Assign chores manually or fairly among roommates.  
- Mark chores as completed.  
- Apply penalties automatically or manually when chores are missed.  
- Track roommates’ penalty balances and total shared fund.  
- Backup and restore data for persistence.  

---

## 2. App Structure
The app is divided into the following main sections:

1. **Home Page** – Displays overall summary (total chores, penalties, fund balance).  
2. **Chores Page** – List of all chores with options to add, edit, delete, or mark done.  
3. **Roommates Page** – Add and manage roommates, view how many chores they have.  
4. **Penalties Page** – View penalty history and total penalty fund.  
5. **Settings Page** – Manage backup/restore, reset data, or future cloud sync.  

---

## 3. Data Models

### Roommate
| Field | Type | Description |
|-------|------|--------------|
| id | int | Unique identifier |
| name | String | Roommate’s name |
| totalChores | int | Count of assigned chores |
| penaltyBalance | double | Total penalties owed |

### Chore
| Field | Type | Description |
|-------|------|--------------|
| id | int | Unique identifier |
| name | String | Chore description |
| assignedTo | Roommate | Who is responsible |
| dueDate | DateTime | When it’s due |
| isDone | bool | Completion status |

### Penalty
| Field | Type | Description |
|-------|------|--------------|
| id | int | Unique identifier |
| reason | String | Why penalty was given |
| amount | double | Penalty value |
| date | DateTime | When penalty occurred |
| assignedTo | Roommate | Who received penalty |

---

## 4. State Management
- Uses **`ChangeNotifier`** and **`Provider`** for managing and updating app-wide state.  
- All UI screens listen for changes in the shared app state.  
- When chores or roommates are added/updated, UI refreshes automatically.

---

## 5. Storage & Persistence
- **Hive database** is used for local storage.  
- Adapters are registered for `Roommate`, `Chore`, and `Penalty` classes.  
- On app launch, all data is loaded from Hive boxes.  
- On changes (add/edit/delete), data is saved automatically.  

---

## 6. Fair Assignment Logic
- When a new chore is created, it can be assigned fairly using a **rotation system**.  
- The algorithm picks the roommate with the **fewest chores assigned**.  
- Over time, all roommates get nearly equal workload distribution.  

---

## 7. Penalty System
- Penalties can be triggered when:
  - A chore’s due date passes and it’s not completed.
  - A user manually marks a missed chore.  
- Penalties are added to the roommate’s balance and the shared fund.  
- Users can manually clear penalties if needed.  

---

## 8. Backup & Restore
- **Backup**: Exports all stored data as a single JSON file.  
- **Restore**: Imports data from the saved JSON file.  
- Future versions will support **cloud sync (Google Drive or Firebase)**.  

---

## 9. UI Design
- Built with **Flutter’s Material components**.  
- Navigation via `BottomNavigationBar`.  
- Cards and rounded containers for chores, roommates, and penalties.  
- Simple, minimal color palette for clarity and readability.

---

## 10. Planned Enhancements
- Notifications/reminders for upcoming chores.  
- Leaderboard or rewards for most consistent roommate.  
- Optional dark/light theme toggle.  
- Cloud sync for cross-device backup.  
- Statistics dashboard (completion rate, penalties over time).  

---

## 11. Notes for Future Updates
When new features are added:
1. Describe **what** was added or changed.  
2. Explain **why** it was added (goal or improvement).  
3. Include any **dependencies or tools** used.  
4. Add any **design or logic decisions** made during implementation.  

Example format:
