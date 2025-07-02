function LocalUI:AutoLoad()
    if not LocalUI_DeviceName then
        StaticPopupDialogs["LUI_SET_DEVICE_NAME"] = {
            text = "We've noticed you're on a new device.\nWhat would you like to call this device?",
            button1 = "Save",
            button2 = "Cancel",
            hasEditBox = true,
            maxLetters = 50,
            OnAccept = function(self)
                local name = self.editBox:GetText()
                if name and name ~= "" then
                    LocalUI_DeviceName = name
                    print("LUI: Device name set to '" .. name .. "'")
                    if LocalUIPrefs[name] then
                        LocalUI:LoadUI(name)
                    else
                        print("LUI: No profile found for '" .. name .. "'. Use /lui save " .. name .. " to create one.")
                    end
                end
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 5,
        }
        StaticPopup_Show("LUI_SET_DEVICE_NAME")
    elseif LocalUIPrefs[LocalUI_DeviceName] then
        LocalUI:LoadUI(LocalUI_DeviceName)
        print("LUI: Auto-loaded profile for device '" .. LocalUI_DeviceName .. "'")
    else
        print("LUI: No saved profile for this device.")
    end
end

function LocalUI:OnInit()
    LocalUI.CoreFrame:RegisterEvent("PLAYER_LOGIN")
    LocalUI.CoreFrame:SetScript("OnEvent", function(_, event)
        if event == "PLAYER_LOGIN" then
            LocalUI:AutoLoad()
        end
    end)
end
