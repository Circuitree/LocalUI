function LocalUI:AutoLoad()
    if not LocalUI_DeviceName then
        -- Prompt user to name their device on first login
        StaticPopupDialogs["LUI_SET_DEVICE_NAME"] = {
            text = "LocalUI: You've logged in on a new device.\nWhat would you like to call this device?",
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
                        -- Delay loading to prevent action bar wipe after /reload
                        C_Timer.After(0.5, function()
                            LocalUI:LoadUI(name)
                        end)
                    else
                        print("LUI: No profile found for '" .. name .. "'. Creating a new profile.")
                        LocalUI:SaveUI(name)
                    end
                end
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 5,
            showAlert = true,
        }
        StaticPopup_Show("LUI_SET_DEVICE_NAME")

    elseif LocalUIPrefs[LocalUI_DeviceName] then
        -- Delay to avoid action bar race condition after reloads
        C_Timer.After(0.5, function()
            LocalUI:LoadUI(LocalUI_DeviceName)
        end)
        print("LUI: Auto-loaded profile for device '" .. LocalUI_DeviceName .. "'")
    else
        print("LUI: No saved profile found for this device.")
    end
end

-- Hook into login and logout events
function LocalUI:OnInit()
    LocalUI.CoreFrame:RegisterEvent("PLAYER_LOGIN")
    LocalUI.CoreFrame:RegisterEvent("PLAYER_LOGOUT")

    LocalUI.CoreFrame:SetScript("OnEvent", function(_, event)
        if event == "PLAYER_LOGIN" then
            LocalUI:AutoLoad()

        elseif event == "PLAYER_LOGOUT" then
            if LocalUI_DeviceName and LocalUIPrefs[LocalUI_DeviceName] then
                LocalUI:SaveUI(LocalUI_DeviceName)
                -- Optional: Uncomment to show confirmation
                -- print("LUI: Auto-saved profile on logout (" .. LocalUI_DeviceName .. ")")
            end
        end
    end)
end
