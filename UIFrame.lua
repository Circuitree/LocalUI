-- Create the settings panel
local frame = CreateFrame("Frame", "LocalUIFrame", UIParent)
frame.name = "LocalUI"
LocalUI.frame = frame

-- Title
local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("LocalUI Manager")

-- Profile input box
local input = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
input:SetSize(160, 20)
input:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -20)
input:SetAutoFocus(false)
input:SetText(LocalUI_DeviceName or "MyProfile")

-- Classic dropdown
local dropdown = CreateFrame("Frame", "LocalUIDropdown", frame, "UIDropDownMenuTemplate")
dropdown:SetPoint("TOPLEFT", input, "BOTTOMLEFT", -15, -10)

function LocalUI:UpdateDropdown()
    local function OnClick(self)
        UIDropDownMenu_SetSelectedName(dropdown, self:GetText())
        input:SetText(self:GetText())
    end

    local function Initialize(_, level)
        local info = UIDropDownMenu_CreateInfo()
        for name in pairs(LocalUIPrefs or {}) do
            info.text = name
            info.func = OnClick
            UIDropDownMenu_AddButton(info, level)
        end
    end

    UIDropDownMenu_Initialize(dropdown, Initialize)
    UIDropDownMenu_SetWidth(dropdown, 160)
    UIDropDownMenu_SetSelectedName(dropdown, input:GetText())
end

-- Device and profile labels
local deviceLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
deviceLabel:SetPoint("TOPLEFT", dropdown, "BOTTOMLEFT", 15, -10)

local profileLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
profileLabel:SetPoint("TOPLEFT", deviceLabel, "BOTTOMLEFT", 0, -2)
LocalUI.profileLabel = profileLabel

function LocalUI:UpdateUIDisplay()
    self:UpdateDropdown()
    local dev = LocalUI_DeviceName or "Not Set"
    local hasProfile = LocalUIPrefs[dev]
    local colorD = LocalUI_DeviceName and "|cff00ff00" or "|cffff0000"
    local colorP = hasProfile and "|cff00ff00" or "|cffffff00"
    deviceLabel:SetText(colorD .. "Device: " .. dev .. "|r")
    profileLabel:SetText(colorP .. "Active Profile: " .. (hasProfile and dev or "None") .. "|r")
end

-- Utility to create buttons
local function MakeBtn(label, x, y, handler)
    local b = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
    b:SetSize(100, 25)
    b:SetPoint("TOPLEFT", frame, "TOPLEFT", x, y)
    b:SetText(label)
    b:SetScript("OnClick", handler)
    return b
end

-- Buttons
MakeBtn("Save", 20, -160, function() LocalUI:SaveUI(input:GetText()) end)
MakeBtn("Load", 130, -160, function() LocalUI:LoadUI(input:GetText()) end)
MakeBtn("Delete", 240, -160, function()
    local name = input:GetText()
    if LocalUIPrefs[name] then
        LocalUIPrefs[name] = nil
        print("LUI: Deleted '" .. name .. "'")
        input:SetText("")
        LocalUI:UpdateDropdown()
    end
end)

MakeBtn("Export", 20, -200, function()
    LocalUI:ExportProfile(input:GetText())
end)

MakeBtn("Import", 130, -200, function()
    StaticPopupDialogs["LUI_IMPORT"] = {
        text = "Paste Base64 string to import:",
        button1 = "Import",
        button2 = "Cancel",
        hasEditBox = true,
        maxLetters = 4096,
        OnAccept = function(self)
            LocalUI:ImportProfile(input:GetText(), self.editBox:GetText())
            LocalUI:UpdateDropdown()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true
    }
    StaticPopup_Show("LUI_IMPORT")
end)

MakeBtn("Rename Device", 240, -200, function()
    StaticPopupDialogs["LUI_RENAME_DEVICE"] = {
        text = "Enter new name for this device:",
        button1 = "Save",
        button2 = "Cancel",
        hasEditBox = true,
        maxLetters = 50,
        OnAccept = function(self)
            LocalUI_DeviceName = self.editBox:GetText()
            print("LUI: Renamed device to '" .. LocalUI_DeviceName .. "'")
            LocalUI:UpdateUIDisplay()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true
    }
    StaticPopup_Show("LUI_RENAME_DEVICE")
end)

-- Refresh dropdown when panel is shown
frame:SetScript("OnShow", function()
    LocalUI:UpdateUIDisplay()
end)

-- Register with the new Settings API
if Settings and Settings.RegisterCanvasLayoutCategory then
    local category = Settings.RegisterCanvasLayoutCategory(frame, "LocalUI")
    Settings.RegisterAddOnCategory(category)
    LocalUI.SettingsCategory = category
end
