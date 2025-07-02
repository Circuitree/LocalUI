local NUM_ACTIONBAR_SLOTS = 120

function LocalUI:SaveUI(profileName)
    if not profileName or profileName == "" then
        print("LUI: Please specify a profile name.")
        return
    end

    LocalUIPrefs[profileName] = {
        actionBars = {},
        keybinds = {}
    }

    for i = 1, NUM_ACTIONBAR_SLOTS do
        local t, id, sub = GetActionInfo(i)
        if t then
            LocalUIPrefs[profileName].actionBars[i] = {type = t, id = id, sub = sub}
        end
    end

    for i = 1, GetNumBindings() do
        local cmd, k1, k2 = GetBinding(i)
        if cmd then
            LocalUIPrefs[profileName].keybinds[cmd] = {k1, k2}
        end
    end

    print("LUI: Profile '" .. profileName .. "' saved.")
end

function LocalUI:LoadUI(profileName)
    local data = LocalUIPrefs[profileName]
    if not data then
        print("LUI: Profile not found: " .. profileName)
        return
    end

    -- Load actions
    for i = 1, NUM_ACTIONBAR_SLOTS do
        local slot = data.actionBars[i]
        if slot then
            PickupAction(i)
            if slot.type == "spell" then PickupSpell(slot.id)
            elseif slot.type == "macro" then PickupMacro(slot.id)
            elseif slot.type == "item" then PickupItem(slot.id) end
            PlaceAction(i)
        end
    end

    -- Load keybinds
    for i = 1, GetNumBindings() do SetBinding(nil, GetBinding(i)) end
    for cmd, keys in pairs(data.keybinds) do
        for _, key in ipairs(keys) do
            if key then SetBinding(key, cmd) end
        end
    end
    SaveBindings(2)

    print("LUI: Loaded profile '" .. profileName .. "'")
    if LocalUI.profileLabel and LocalUI.profileLabel.SetText then
        LocalUI.profileLabel:SetText("|cff00ff00Active Profile: " .. profileName .. "|r")
    end
end
