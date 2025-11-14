# 🧩 Roommate Chore & Penalty App – Project Log

## Overview
This app helps roommates manage chores fairly, track task completion, and handle penalties for missed tasks.  
It also maintains a shared fund that collects penalties, encouraging accountability and teamwork.

The app is being built using **Flutter** (Dart language).  
All code is written manually for learning purposes, with step-by-step understanding instead of copy-paste.

---                                                                         

## 1. Core Features (Current and Planned)
✅ Add, edit, and delete chores.  
✅ Assign chores manually or fairly among roommates.  
✅ Mark chores as completed.  
✅ Track roommates’ penalty balances and total shared fund.  
✅ Data stored persistently using Hive.  
☑️ Backup and restore data.  
☑️ Apply penalties automatically for missed chores.  
☑️ Optional future cloud sync (Google Drive / Firebase).  

---

## 2. App Structure
The app currently has the following pages set up through Flutter’s navigation:

1. **Home Page** – Displays an overview of chores and penalties.  
2. **Chores Page** – Shows the list of chores, with add/edit/delete options.  
3. **Roommates Page** – Used to add and manage roommates.  
4. **Penalties Page** – Displays total penalties and balances.  
5. **Settings Page** – Reserved for backup, restore, and preferences.

Navigation is handled using a **BottomNavigationBar**, making it easy to switch between sections.

---

## 3. Development Setup
- Created the project using `flutter create roommate_chore_app`.  
- Verified the default Flutter counter app worked correctly.  
- Connected Visual Studio Code and Android Emulator for testing.  
- Confirmed build and debug setup works fine.  

When testing, the app was successfully launched, and we saw the **button click counter screen**, confirming setup was correct.

---

## 4. Models and Data Structure
Created the base **models folder** (`lib/models/`) and added model files for structured data.

### Roommate
| Field | Type | Description |
|-------|------|-------------|
| id | int | Unique identifier |
| name | String | Roommate’s name |
| totalChores | int | Number of chores assigned |
| penaltyBalance | double | Total penalties owed |

### Chore
| Field | Type | Description |
|-------|------|-------------|
| id | int | Unique identifier |
| name | String | Name/description of the chore |
| assignedTo | Roommate | Assigned roommate |
| dueDate | DateTime | When the chore is due |
| isDone | bool | Completion status |

### Penalty
| Field | Type | Description |
|-------|------|-------------|
| id | int | Unique identifier |
| reason | String | Why the penalty was given |
| amount | double | Penalty value |
| date | DateTime | When the penalty occurred |
| assignedTo | Roommate | Who the penalty belongs to |

---

## 5. State Management
- Uses **ChangeNotifier** and **Provider** for managing shared data.  
- When a roommate or chore is added, the UI automatically updates.  
- All pages listen to shared state objects for real-time updates.  

This allows smooth UI updates without manually refreshing pages.

---

## 6. Hive Database Integration
- Added **Hive** to `pubspec.yaml`.  
- Created Hive adapters for `Roommate`, `Chore`, and `Penalty`.  
- Configured Hive initialization in the `main()` function.  
- Verified that data persists between app restarts (basic test).  

This ensures users don’t lose data when the app closes.

---

## 7. Fair Assignment Logic
- Implemented fair assignment for chores.  
- The system checks which roommate has the **fewest chores** and assigns the next chore to them.  
- Ensures even workload distribution over time.  

---

## 8. Penalty System
- Added penalty model and logic placeholder.  
- Penalties are tied to a roommate when they miss a chore or when a penalty is added manually.  
- The total penalty fund increases automatically with every new penalty.  

---

## 9. Backup & Restore (Planned)
**Backup** will export all stored data (chores, roommates, penalties) as a JSON file.  
**Restore** will import from a JSON file to rebuild the data locally.  
Cloud backup via **Google Drive / Firebase** will be added in a later version.

---

## 10. UI Design
- Base layout implemented using Material Design widgets.  
- Navigation handled via **BottomNavigationBar**.  
- Placeholder screens for each section added.  
- Future UI improvements planned:
  - Rounded cards for chores and roommates.  
  - Consistent colors and icons.  
  - Cleaner typography and spacing.

---

## 11. Testing and Debugging
- Debug session started successfully using VS Code.  
- Verified navigation between pages.  
- Tested basic chore addition and display in list.  
- Confirmed data saving works properly with Hive.  

---

## 12. Planned Enhancements
- Notifications for due chores.  
- Reward system for consistent completion.  
- Theme toggle (dark/light mode).  
- Statistics dashboard (completion rate, penalties over time).  
- Cloud sync option.  

---

## 13. Documentation & Tracking
A Google Doc will be maintained alongside this log for extended explanations and screenshots.  
This Markdown file (`PROJECT_LOG.md`) serves as the main instruction-style log for:
- Understanding the structure of the app.  
- Tracking how each feature was built.  
- Adding new features step-by-step.

---

## 14. How to Add Future Updates
Each time a new feature or change is implemented, add an entry like this:


---

## End of Log
This document reflects the current progress of the Roommate Chore & Penalty App.  
It will continue to evolve as more features are added and refined.
