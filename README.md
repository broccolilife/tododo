# 🌿 Tododo — Healing Todo List

A calming, beautifully designed todo app for iOS built with SwiftUI and SwiftData. Tododo transforms mundane task management into a soothing experience with aurora backgrounds, glassmorphic cards, and haptic feedback.

## ✨ Features

- **Aurora Background** — Layered radial gradients with GPU-accelerated Canvas shapes create a dreamy, animated backdrop
- **Liquid Glass UI** — Cards and orbs use Apple's `.glassEffect` with crystal-clear styling and smooth spring animations
- **Drag & Drop Categories** — Drag tasks onto glowing category orbs to organize; haptic feedback on drop
- **SwiftData Persistence** — Full local persistence with `@Model` entities for Tasks, Categories, and UserSettings
- **Quick Add** — Pull-to-refresh or tap + to rapidly capture tasks
- **Category Management** — Create custom categories with icons, colors, and sort ordering
- **Haptics & Sound** — Configurable tactile feedback for interactions

## 🏗 Architecture Overview

```
┌─────────────────────────────────────────────┐
│  HealingTodoApp (App Entry)                 │
│  └─ ModelContainer: Task, Category,         │
│     UserSettings (SwiftData schema)         │
├─────────────────────────────────────────────┤
│  Views                                      │
│  ├─ InboxView        Main task list + tray  │
│  ├─ QuickAddView     Sheet for new tasks    │
│  ├─ NewCategoryView  Category creation      │
│  ├─ CategoryPushPopPicker  Inline picker    │
│  ├─ BucketOrb        Drag-drop target orb   │
│  ├─ GlassCard        Reusable glass card    │
│  └─ AuroraBackground Full-screen backdrop   │
├─────────────────────────────────────────────┤
│  Models (SwiftData @Model)                  │
│  ├─ Task        title, notes, due, tags...  │
│  ├─ Category    name, icon, colorID, tasks  │
│  └─ UserSettings  haptics, sounds, companion│
├─────────────────────────────────────────────┤
│  Utilities                                  │
│  ├─ Palette     Named color system          │
│  ├─ Color+Hex   Hex string → SwiftUI Color  │
│  └─ Haptics     Haptic feedback engine      │
└─────────────────────────────────────────────┘
```

## 🚀 Getting Started

### Requirements
- Xcode 16+ (Swift 6)
- iOS 26+ / macOS 26+ (uses `.glassEffect` — Liquid Glass API)

### Build & Run
1. Clone the repo:
   ```bash
   git clone https://github.com/broccolilife/tododo.git
   cd tododo
   ```
2. Open in Xcode — no Package.swift needed, all frameworks are system-provided
3. Select an iOS Simulator or physical device
4. **⌘R** to build and run

### Default Categories
On first launch, Tododo creates 7 default categories: Inbox, Work, Home, Errands, Health, Play, and Learning — each with a unique color and SF Symbol icon.

## 📸 Screenshots

> _Coming soon — aurora UI with glass cards and category orbs_

## 🎨 Color System

Colors are managed through the `Palette` enum, which maps category names to curated SwiftUI `Color` values. Custom categories can use hex color strings as fallback.

## 📄 License

MIT
