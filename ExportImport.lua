-- Ensure profile table exists
LocalUIPrefs = LocalUIPrefs or {}

-- Export a profile to a Base64-encoded string
function LocalUI:ExportProfile(profileName)
    local data = LocalUIPrefs[profileName]
    if not data then
        print("LUI: Profile '" .. profileName .. "' not found.")
        return
    end

    local serialized = LibStub("AceSerializer-3.0"):Serialize(data)
    local encoded = self:Base64Encode(serialized)
    print("LUI Export [" .. profileName .. "]:")
    print(encoded)
end

-- Import a Base64-encoded profile string into a named profile
function LocalUI:ImportProfile(profileName, encoded)
    local decoded = self:Base64Decode(encoded)
    local success, data = LibStub("AceSerializer-3.0"):Deserialize(decoded)
    if success then
        LocalUIPrefs[profileName] = data
        print("LUI: Imported profile '" .. profileName .. "' successfully.")
    else
        print("LUI: Failed to import profile. Invalid string.")
    end
end

-- Register /lui command
SLASH_LUI1 = "/lui"
SlashCmdList["LUI"] = function(msg)
    local cmd, profile = msg:match("^(%S*)%s*(.-)$")
    cmd = cmd and cmd:lower() or ""
    profile = profile and profile:match("^%s*(.-)%s*$")

    if cmd == "save" then
        if profile == "" then
            print("LUI: Please provide a profile name.")
        else
            LocalUI:SaveUI(profile)
        end

    elseif cmd == "load" then
        if profile == "" then
            print("LUI: Please provide a profile name.")
        else
            LocalUI:LoadUI(profile)
        end

    elseif cmd == "export" then
        if profile == "" then
            print("LUI: Please provide a profile name.")
        else
            LocalUI:ExportProfile(profile)
        end

    elseif cmd == "import" then
        if profile == "" then
            print("LUI: Please provide a profile name.")
            return
        end

        StaticPopupDialogs["LUI_IMPORT_SLASH"] = {
            text = "Paste Base64 string to import:",
            button1 = "Import",
            button2 = "Cancel",
            hasEditBox = true,
            maxLetters = 4096,
            OnAccept = function(self)
                LocalUI:ImportProfile(profile, self.editBox:GetText())
                if LocalUI.UpdateDropdown then
                    LocalUI:UpdateDropdown()
                end
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true
        }
        StaticPopup_Show("LUI_IMPORT_SLASH")

    elseif cmd == "list" then
        print("LUI: Saved Profiles:")
        local count = 0
        for name in pairs(LocalUIPrefs or {}) do
            print("  - " .. name)
            count = count + 1
        end
        if count == 0 then
            print("  (No profiles saved yet.)")
        end

    else
        print("Local UI")
        print("go to Menu > Options > AddOns > LocalUI for GUI options")
        print("  /lui save <name>    - Save current action bars & keybinds")
        print("  /lui load <name>    - Load saved profile")
        print("  /lui export <name>  - Export profile to Base64")
        print("  /lui import <name>  - Import Base64 profile into name")
        print("  /lui list           - List all saved profiles")
    end
end
