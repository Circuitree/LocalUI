# 📦 LocalUI

**LocalUI** is a World of Warcraft addon that lets you save, load, import, and export your action bar and keybinding layouts—per device. Whether you play on multiple setups or just want to preserve your configuration, LocalUI has your back.

---

## 🌀 What Blizzard Changed: Server-Side UI Sync

- Starting with Dragonflight, Blizzard introduced a feature called Server-Side UI Profiles. This was a big quality-of-life update that allows most UI settings—including action bars, edit mode layouts, and keybindings—to be automatically saved to your Battle.net account and restored across characters and devices.

## 🎯 Blizzard's Goals:

- Make UI setups consistent across multiple characters
- Reduce reliance on per-character SavedVariables files
- Simplify moving between machines or re-installing WoW

---

## 😬 The Problem: One Size Doesn’t Fit All
- Blizzard’s system is powerful—but it assumes that you want the exact same layout everywhere. That causes friction when:
  - You play on multiple PCs with different monitors, keybind setups, or peripherals
  - You want a compact layout for your laptop and a spread-out layout for your desktop
- In these cases, the global sync can actually overwrite your preferred layout unless you manually switch profiles each time—and there’s no native automation.

## 🛡️ How LocalUI Solves It
- LocalUI reintroduces local control and flexibility:
  - Auto-loads the right layout based on the device name you set
  - Auto-saves changes on logout or exit
  - Lets you export/import profiles manually as Base64 strings
-It basically gives you back the ability to treat your setups as distinct, intentional experiences—without worrying about global settings overriding everything when you switch machines.

===

## ⚙️ Features

- 🖥️ **Device-based auto-loading and auto-saving**
  - setup your UI once, move from device-to-device, and when you come back **LocalUI** will change your UI back to it's last known configurations that you locked in
- 🎮 **Saves & Loads**
  - Action bars (all 120 slots)
  - Keybindings (primary & secondary)
- 💾 **Command-based profile control** via `/lui`
- 🔐💬 **Export/import profiles** using Base64-encoded strings
- 🔄 **Autosaves on logout** to protect your latest action bar changes
- 🛠️ **Settings Panel Integration**
  - configure directly from Game Menu → Options → AddOns → LocalUI

---

## 🧠 How It Works

- On first login, you'll be prompted to name your current device (e.g., "Desktop", “Laptop”, “RaiderRig”).
- That name becomes the active profile that LocalUI will:
  - ✅ Automatically load on login
  - ✅ Automatically save when you exit or logout
- You can create and manage multiple profiles for different layouts or roles.

---

## 💬 Commands

Type /lui in chat to access these options:
```bash
/lui save <name>	  - Save your current action bars and keybinds
/lui load <name>  	- Load a saved profile
/lui export <name>	- Print a Base64 export of the profile
/lui import <name>	- Paste a Base64 string into a named profile
/lui                - list	List all saved profiles
```

---

## 🔒 Notes

- **LocalUI** does not sync between devices—it’s designed to be local (surprise!) and fast.
- For shared syncing or cloud backups, use the Export and Import features to transfer profiles manually.

---

## 💾 Dependencies

- AceSerializer-3.0
- LibStub