# LocalUI 🌐
A personal UI profile manager for World of Warcraft — built to make switching between devices, or setups effortless.

## 📦 Features

- 🔐 **Account-wide Saved Profiles** (per device name)
- 🎮 **Saves & Loads**
  - Action bars (all 120 slots)
  - Keybindings (primary & secondary)
- 💾 **Profile Tools**
  - Save, Load, Delete with one click
  - Export to Base64 and import from string
  - Share profiles via popup
- 🖥️ **Automatic Device Detection**
  - First-time prompt to name your computer
  - Auto-load matching profile on login
- 🧰 **In-Game UI**
  - Profile dropdown + input box
  - Device and profile status labels with tooltips
  - Rename Device button
- ✅ No slash commands required — though `/lui save`, `/lui load`, and `/lui export` are supported

---

## 📂 Installation

1. Download the ZIP and extract into:
World of Warcraft\retail\Interface\AddOns\LocalUI\
2. Ensure the folder contains:
- `LocalUI.toc`
- `Core.lua`
- `Utils.lua`
- `SaveLoad.lua`
- `AutoLoad.lua`
- `ExportImport.lua`
- `UIFrame.lua`

---

## 🔤 Commands

```bash
/lui save <name>    - Save current UI + keybinds
/lui load <name>    - Load a saved profile
/lui export <name>  - Print a shareable Base64 string
/lui import <name>  - Imports from a shared Base64 string
/lui ui             - Open the in-game UI panel
```

🔄 How Profiles Work
Each device is assigned a name on first login. That name is used as the profile key. You can rename it later from the UI.

Example: If you name your laptop "MyLaptop", saving a profile with that name lets it load automatically next time you log in.

🛠️ Requirements
WoW Retail (tested on Interface 110107 / War Within)

No other dependencies required (Ace3 optional for serialization)

🔒 Data
This addon saves settings to:
SavedVariables:
- LocalUIPrefs
- LocalUI_DeviceName
They are shared across characters/account, unless manually altered.

Created with love and a dash of Lua ✨

