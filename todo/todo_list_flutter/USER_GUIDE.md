# 🚀 ChronoDo — Complete User Guide & Feature Testing Manual

Welcome to **ChronoDo**, your AI-Powered Wake-Up Focus & Hackathon Deadline Command Suite!

---

## 🌐 1. How to Run on Chrome

Open your terminal in VS Code, Antigravity, or PowerShell and run:

```bash
cd d:\GenAI\todo\todo_list_flutter
flutter run -d chrome
```

> **Tip:** You can also run natively on Windows desktop by typing:
> ```bash
> flutter run -d windows
> ```

---

## 🧪 2. Step-by-Step Feature Walkthrough & Testing Checklist

Here is a checklist of every superpower in the app and how to test it:

### 🌅 A. Morning Wake-Up Kickstart (30-Sec Wake-to-Do)
1. **Location:** Top Sun icon (`☀️`) in the app bar OR tap the **"Morning Focus"** card.
2. **How to Test:**
   - Tap the Sun icon to open the Morning Kickstart screen.
   - Enter your **3 core goals** for today (or tap the quick-tap chips like *"+ Fix Hackathon MVP Bug"*).
   - Tap **"Lock In Today's Focus"**.
   - **Result:** You will see a fire streak boost notification 🔥 and the 3 goals will pin to the top of your home screen!

---

### ⚡ B. Hackathon Command & 2-Hour Safety Buffer
1. **Location:** Bottom Navigation **"Hackathons"** tab OR the live countdown card on Home.
2. **How to Test:**
   - Switch to the **Hackathons** tab.
   - Tap **"+ New Hackathon"**.
   - Enter a name (e.g. *EthGlobal 2026*), select Platform (*Devpost*), and pick a deadline.
   - Tap **"Generate Reverse Timeline & Add"**.
   - Tap the hackathon card to open the **Detail Screen**.
   - **Result:** Watch the real-time live ticker (`DD : HH : MM : SS`), reverse milestone phases (10% Setup $\to$ 60% MVP $\to$ 20% Demo Video $\to$ 10% Devpost Quarantine), and the interactive deliverables checklist!

---

### 🎙️ C. Voice & Thought-Dump AI (Hinglish/English)
1. **Location:** Purple **Mic FAB (`🎙️`)** in the bottom right corner.
2. **How to Test:**
   - Tap the Mic FAB.
   - Tap the big pulsating microphone OR choose a sample voice dump (e.g. *"Shaam 6 baje Hackathon demo video record karna hai urgent high priority"*).
   - **Result:** The AI extracts the title, category (`HACKATHON`), and priority (`HIGH`) automatically. Tap **"Add Task from Voice Dump"**!

---

### 🤖 D. Built-in AI Task Copilot
1. **Location:** On any task tile, tap the **"Copilot"** button.
2. **How to Test:**
   - Tap **"Copilot"** on the *"Study AIML Concepts"* or *"Build Hackathon Prototype"* task.
   - **Result:** An AI modal opens with starter code snippets (PyTorch classifier / Sliding Window template), step-by-step execution roadmap, time estimates, and pro-tips with a 1-tap **"Copy"** button!

---

### 🃏 E. Auto-Generated Active Recall Flashcards
1. **Location:** On any task tile, tap the **"Cards 🃏"** button.
2. **How to Test:**
   - Tap **"Cards 🃏"** to launch the interactive study deck.
   - Tap the card to flip between Question and Answer.
   - Tap **"I Knew It! (+30 XP)"** to score mastery points or **"Need Review"** to cycle back.
   - Complete the deck to earn trophy bonus XP!

---

### 🔥 F. Anti-Procrastination Stake Lock (Commitment Contract)
1. **Location:** On any task tile, tap the **"Stake 🔥"** button.
2. **How to Test:**
   - Select your commitment window (e.g. `30m` or `45m`).
   - Tap **"Lock Stake 🔥"**.
   - **Result:** The task gets an active burning red border and a live ticking countdown timer. If you check off the task before time runs out, you earn a massive **+250 XP bonus**!

---

### 🔗 G. Task Resource Links (YouTube, Docs, GitHub)
1. **Location:** On any task, tap the **Link icon (`🔗`)**.
2. **How to Test:**
   - Enter a title (e.g. *3Blue1Brown Neural Networks*) and a URL (`https://youtube.com/...`).
   - Tap **"Add Link"**.
   - **Result:** A branded colored chip appears on the task. Tap it to directly open the video/doc in your browser or YouTube app!

---

### 🧠 H. Mental Energy-to-Task Matcher (Bio-Filter)
1. **Location:** Top horizontal filter bar right below the header: **"Brain Energy"**.
2. **How to Test:**
   - Tap **"⚡ Deep Focus"** to show only intensive coding/AI tasks.
   - Tap **"☕ Medium"** or **"😴 Light"** when feeling fatigued to see low-friction tasks.

---

### ⏳ I. Pomodoro Focus Shield
1. **Location:** Quick action strip **"Pomodoro Focus"** button OR **"25m"** on any task.
2. **How to Test:**
   - Tap **"Start Focus"** to begin the circular countdown ring.
   - Switch between **25m Focus**, **5m Break**, and **15m Long Break**.
   - Linked task study links appear directly on the timer screen so you study without distraction!

---

### 📋 J. Kanban Sprint Board
1. **Location:** Quick action strip **"Kanban Sprint"** button.
2. **How to Test:**
   - Switch between **To Do 📋**, **In Progress ⚡**, and **Done ✅** tabs.
   - Tap the `...` menu on any card to move tasks across sprint columns.

---

### 🎮 K. Gamification & XP Hunter Profile
1. **Location:** Trophy medal icon (`🎖️`) in the top app bar.
2. **How to Test:**
   - See your current Level, Rank Title (*Novice Sprinter $\to$ Code Crafter $\to$ Hackathon Hustler $\to$ 10x Architect*), and XP progress bar.
   - View your showcase of unlocked and locked Achievement Badges.

---

### 📝 L. Quick Floating Scratchpad
1. **Location:** Middle floating action button with the note icon (`📝`).
2. **How to Test:**
   - Tap the Scratchpad FAB to quickly type distracting thoughts without leaving your screen.

---

### 🌙 M. Night Shutdown & Daily Win Recap
1. **Location:** Moon icon (`🌙`) in the top app bar.
2. **How to Test:**
   - Tap the Moon icon at the end of the day.
   - Enter your biggest win of the day, 1 concept learned, and give a 1–5 star satisfaction rating.
   - Tap **"Lock In Daily Win & Sleep 🌙"** to earn +150 XP!

---

## 💻 Technical Health
- `flutter analyze`: **0 issues found**
- `flutter test`: **All tests passing**
- Local Persistence: Saved locally in `SharedPreferences`
