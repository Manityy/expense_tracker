# Flousi

**Flousi** (*flous* — money in Tunisian Arabic) is a personal finance app built with Flutter. Track spending in **Tunisian Dinars (DT)**, set budgets, manage subscriptions, and get AI-powered advice tailored to your monthly income and goals.

The UI uses a Tunisia-inspired palette (saffron, Mediterranean blue, olive) with subtle decorative motifs. The app supports **English, French, and Arabic**, plus **light and dark mode**.

---

## Features

### Home
- Monthly overview: salary, spent, remaining, and savings goal progress
- Spending usage %, end-of-month forecast, and personalized finance insights
- Per-category budget bars with over-budget alerts
- Recent transactions and quick access to Flousi AI

### Expenses
- Add, edit, and delete expenses with date picker
- **Auto category detection** while typing the title:
  - Instant **local keyword matching** (Tunisia-aware: STEG, Carrefour, louage, chawarma, etc.)
  - **Groq / Llama AI fallback** when no local match (800 ms debounce)
- Category filter chips, search, and grouping by day (Today / Yesterday)
- Swipe-to-delete and receipt photo (camera or gallery → Firebase Storage)
- Pull-to-refresh with live Firestore streams

### Analytics
- Month picker with summary cards (spent, remaining, % of income, transaction count)
- Category breakdown with interactive pie chart and progress bars
- 6-month spending bar chart
- **Monthly Trend** — full history, 6-month average, and month-over-month changes

### Subscriptions
- Recurring expenses (rent, bills, streaming, etc.) with due-day tracking
- Add, edit, and delete subscriptions
- **Auto-post** due subscriptions as expenses when the app launches

### Profile & settings
- **Dark mode** toggle (system / light / dark)
- **Language picker**: English, Français, العربية (RTL for Arabic)
- Salary and savings goal setup
- Per-category budget limits
- **Savings challenges** with progress and completion badges
- **Export expenses to CSV** via the system share sheet (Save, email, Drive, etc.)

### AI Assistant (Flousi AI)
- Chat powered by [Groq](https://groq.com/) (`llama-3.3-70b-versatile`) with context from salary, spending, savings goal, and recent transactions
- Conversation history saved in Firestore
- Advice framed in DT and your real monthly data

### Notifications (local)
Checked when the main app opens (not background push):
- Category budget alerts when spending reaches **≥ 80%** of limit
- Subscription reminders for items **due within 3 days**
- Challenge completion celebrations
- Deduplicated to **once per alert per day** via `SharedPreferences`

### Auth & onboarding
- Firebase email/password sign-in, register, and forgot password
- 3-step onboarding: welcome → monthly income → savings goal → optional category budgets
- Firestore security rules scoped per user

---

## Tech stack

| Layer | Tools |
|-------|--------|
| UI | Flutter, Material 3, custom Tunisia-inspired theme |
| State | Riverpod |
| i18n | `flutter_localizations`, ARB files (`lib/l10n/`) |
| Settings persistence | `shared_preferences` (theme, locale) |
| Backend | Firebase Auth, Cloud Firestore, Firebase Storage |
| Charts | `fl_chart` |
| AI | Groq API via `http` (chat + expense categorization) |
| Config | `flutter_dotenv` / `--dart-define=GROQ_API_KEY` |
| Notifications | `flutter_local_notifications` |
| Export | `share_plus`, `path_provider` |

---

## Project structure

```
lib/
├── app/                 # MaterialApp, light/dark themes
├── constants/           # Expense category keys
├── features/
│   ├── auth/            # Login, register, auth wrapper
│   ├── home/            # Dashboard
│   ├── expenses/        # List, add/edit, analytics, monthly trend
│   ├── subscriptions/   # Recurring expenses
│   ├── profile/         # Settings, budgets, salary, export
│   ├── challenges/      # Spending challenges
│   ├── ai/              # Chatbot & conversations
│   ├── onboarding/      # First-run setup
│   └── navigation/      # Bottom nav + startup background tasks
├── l10n/                # app_en/fr/ar.arb + generated localizations
├── models/              # User, expense, conversation, recurring expense
├── providers/           # Riverpod: auth, data streams, settings
├── services/            # Firestore, auth, AI, notifications, export, subscriptions
├── utils/               # Colors, dates, finance/analytics/challenges helpers, category l10n
└── widgets/             # Expense cards, dashboard cards, Tunisian background/motifs
```

---

## Getting started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart ^3.12)
- A [Firebase](https://firebase.google.com/) project with Auth, Firestore, and Storage enabled
- A [Groq API key](https://console.groq.com/) (optional — AI chat and AI categorization)

### 1. Clone and install

```bash
git clone https://github.com/<your-username>/expense_tracker_.git
cd expense_tracker_
flutter pub get
```

### 2. Firebase setup

This repo includes `lib/firebase_options.dart` and platform config files generated by FlutterFire. For your own Firebase project:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Enable **Email/Password** sign-in in the Firebase Console.

Deploy security rules before production use:

```bash
firebase deploy --only firestore:rules,storage:rules
```

Rule files: `firestore.rules`, `storage.rules` (configured in `firebase.json`).

### 3. Environment variables

Create a `.env` file in the project root (gitignored):

```env
GROQ_API_KEY=your_groq_api_key_here
```

Or pass the key at build/run time:

```bash
flutter run --dart-define=GROQ_API_KEY=your_key_here
```

**Without a valid Groq key:**
- The rest of the app works normally
- **Local keyword categorization** still works on the Add Expense screen
- **AI chat** and **AI categorization fallback** will not work

### 4. Run the app

```bash
flutter run
```

Android release builds use core library desugaring in `android/app/build.gradle.kts` (required by local notifications). Android 13+ requires `POST_NOTIFICATIONS` in `AndroidManifest.xml`.

---

## Firestore data model

| Path | Purpose |
|------|---------|
| `users/{uid}` | Profile: name, email, salary, savings goal, category budgets, onboarding flag |
| `users/{uid}/conversations/{id}` | AI chat threads |
| `users/{uid}/conversations/{id}/messages/{id}` | Chat messages |
| `users/{uid}/recurringExpenses/{id}` | Subscription definitions (`dayOfMonth`, `lastPostedMonth`, etc.) |
| `expenses/{id}` | Expense documents: `userId`, title, amount, category, date, optional `receiptUrl`, optional `subscriptionId` |

---

## Expense categories

Stored as English keys in Firestore; displayed localized in the UI:

Rent, Bills, Food, Groceries, Transport, Entertainment, Healthcare, Education, Shopping, Savings, Other

---

## Key flows (for developers)

| Flow | Entry point |
|------|-------------|
| Startup notifications & sub auto-post | `MainNavigationPage` → `AppBackgroundService.runStartupTasks` |
| Local + AI categorization | `AddExpensePage._onTitleChanged` → `_matchLocalCategory` / `AIService.classifyCategory` |
| CSV export | Profile → `ExportService.exportExpensesCsv` → temp file → `Share.shareXFiles` |
| Insights & forecast | `FinanceHelpers` (used on Home) |
| Settings (theme/locale) | `SettingsProvider` + `AppSettingsSection` on Profile |

---

## Development

```bash
# Regenerate localizations after editing lib/l10n/*.arb
flutter gen-l10n

# Static analysis
flutter analyze

# Run tests
flutter test
```

---

## Roadmap ideas

- Receipt OCR for amount/category from photos
- True background notifications (WorkManager / FCM)
- Export filters (by month, by category)
- Localize challenge titles and notification copy
- Cash vs card payment methods
- Payday-based budget cycles (not calendar month)
- More Tunisian-specific categories (9ist, café, louage as first-class options)

---

## License

This project is for personal and educational use. Add a license file if you plan to open-source it formally.
