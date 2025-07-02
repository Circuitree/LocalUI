-- Create the main frame
local frame = CreateFrame("Frame", "LocalUIFrame", UIParent, "BasicFrameTemplateWithInset")
frame:SetSize(280, 240)
frame:SetPoint("CENTER")
frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
frame.title:SetPoint("CENTER", frame.TitleBg, "CENTER", 0, 0)
frame.title:SetText("LocalUI Manager")
frame:Hide()
LocalUI.frame = frame

-- Input box for profile name
local input = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
input:SetSize(160, 20)
input:SetPoint("TOP", frame, "TOP", 0, -40)
input:SetAutoFocus(false)
input:SetText("MyProfile")

-- Dropdown menu populated with saved profile names
local dropdown = CreateFrame("Frame", "LocalUIDropdown", frame, "UIDropDownMenuTemplate")
dropdown:SetPoint("TOP", input, "BOTTOM", 0, -10)

function LocalUI:UpdateDropdown()
    local function OnClick(self)
        UIDropDownMenu_SetSelectedName(dropdown, self:GetText())
        input:SetText(self:GetText())
    end
    local function Initialize(_, level)
        local info = UIDropDownMenu_CreateInfo()
        for name in pairs(LocalUIPrefs) do
            info.text = name
            info.func = OnClick
            UIDropDownMenu_AddButton(info, level)
        end
    end
    UIDropDownMenu_Initialize(dropdown, Initialize)
    UIDropDownMenu_SetWidth(dropdown, 160)
    UIDropDownMenu_SetSelectedName(dropdown, input:GetText())
end
-- Device label
local deviceLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
deviceLabel:SetPoint("TOP", frame, "TOP", 0, -20)

local deviceTip = CreateFrame("Frame", nil, frame)
deviceTip:SetPoint("TOP", deviceLabel, "TOP")
deviceTip:SetSize(180, 20)
deviceTip:EnableMouse(true)
deviceTip:SetScript("OnEnter", function()
    GameTooltip:SetOwner(deviceTip, "ANCHOR_TOP")
    GameTooltip:SetText("This is the name you've given this device.\nLocalUI uses it to auto-load matching profiles.", nil, nil, nil, true)
    GameTooltip:Show()
end)
deviceTip:SetScript("OnLeave", GameTooltip_Hide)

-- Active profile label
local profileLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
profileLabel:SetPoint("TOP", deviceLabel, "BOTTOM", 0, -2)
LocalUI.profileLabel = profileLabel

local profileTip = CreateFrame("Frame", nil, frame)
profileTip:SetPoint("TOP", profileLabel, "TOP")
profileTip:SetSize(180, 20)
profileTip:EnableMouse(true)
profileTip:SetScript("OnEnter", function()
    GameTooltip:SetOwner(profileTip, "ANCHOR_TOP")
    GameTooltip:SetText("This shows the active profile (if auto-loaded or last loaded).\nUse /lui save <name> to create one.", nil, nil, nil, true)
    GameTooltip:Show()
end)
profileTip:SetScript("OnLeave", GameTooltip_Hide)

-- Method to refresh the labels
function LocalUI:UpdateUIDisplay()
    self:UpdateDropdown()
    local dev = LocalUI_DeviceName or "Not Set"
    local hasProfile = LocalUIPrefs[dev]
    local colorD = LocalUI_DeviceName and "|cff00ff00" or "|cffff0000"
    local colorP = hasProfile and "|cff00ff00" or "|cffffff00"
    deviceLabel:SetText(colorD .. "Device: " .. dev .. "|r")
    profileLabel:SetText(colorP .. "Active Profile: " .. (hasProfile and dev or "None") .. "|r")
end
-- Button builder
local function MakeBtn(label, x, y, handler)
    local b = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
    b:SetSize(80, 25)
    b:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", x, y)
    b:SetText(label)
    b:SetScript("OnClick", handler)
    return b
end

-- Save profile
MakeBtn("Save", 10, 10, function()
    LocalUI:SaveUI(input:GetText())
end)

-- Load profile
MakeBtn("Load", 100, 10, function()
    LocalUI:LoadUI(input:GetText())
end)

-- Delete profile
MakeBtn("Delete", 190, 10, function()
    local name = input:GetText()
    if LocalUIPrefs[name] then
        LocalUIPrefs[name] = nil
        print("LUI: Deleted '" .. name .. "'")
        input:SetText("")
        LocalUI:UpdateDropdown()
    end
end)

-- Export profile
MakeBtn("Export", 10, 40, function()
    LocalUI:ExportProfile(input:GetText())
end)

-- Import profile
MakeBtn("Import", 100, 40, function()
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

-- Share profile
MakeBtn("Share", 190, 40, function()
    local name = input:GetText()
    local data = LocalUIPrefs[name]
    if data then
        local s = LibStub("AceSerializer-3.0"):Serialize(data)
        local b64 = LocalUI:Base64Encode(s)
        StaticPopupDialogs["LUI_SHARE"] = {
            text = "Copy this profile string:",
            button1 = "Close",
            hasEditBox = true,
            editBoxWidth = 350,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true
        }
        local popup = StaticPopup_Show("LUI_SHARE")
        popup.editBox:SetText(b64)
        popup.editBox:HighlightText()
    else
        print("LUI: Profile '" .. name .. "' not found.")
    end
end)

-- Rename Device
MakeBtn("Rename Device", 90, 70, function()
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
