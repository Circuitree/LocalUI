-- Set up global storage and namespace
LocalUIPrefs = LocalUIPrefs or {}
LocalUI_DeviceName = LocalUI_DeviceName or nil
LocalUI = {}

-- Hook events
local frame = CreateFrame("Frame")
LocalUI.CoreFrame = frame
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(_, event, addon)
    if addon == "LocalUI" then
        if LocalUI.OnInit then
            LocalUI:OnInit()
        end
    end
end)
