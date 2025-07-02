local NUM_ACTIONBAR_SLOTS = 120

-- Save current action bars and keybindings to a profile
function LocalUI:SaveUI(profileName)
    if not profileName or profileName == "" then
        print("LUI: Please specify a profile name.")
        return
    end

    LocalUIPrefs[profileName] = { actionBars = {}, keybinds = {} }

    -- Save action bar assignments
    for i = 1, NUM_ACTIONBAR_SLOTS do
        local t, id, sub = GetActionInfo(i)
        if t then
            LocalUIPrefs[profileName].actionBars[i] = { type = t, id = id, sub = sub }
        end
    end

    -- Save keybindings
    for i = 1, GetNumBindings() do
        local cmd, k1, k2 = GetBinding(i)
        if cmd then
            LocalUIPrefs[profileName].keybinds[cmd] = { k1, k2 }
        end
    end

    print("LUI: Profile '" .. profileName .. "' saved.")
end

-- Load a saved profile
function LocalUI:LoadUI(profileName)
    local data = LocalUIPrefs[profileName]
    if not data then
        print("LUI: Profile '" .. profileName .. "' not found.")
        return
    end

    -- Clear all keybindings first
    SaveBindings(2) -- account-wide
    for i = 1, GetNumBindings() do
        local cmd = GetBinding(i)
        if cmd then
            SetBinding(cmd)
        end
    end

    -- Restore action bars
    for i = 1, NUM_ACTIONBAR_SLOTS do
        local slot = data.actionBars and data.actionBars[i]
        if slot then
            local t, id = slot.type, slot.id

            if t == "spell" then
                if C_Spell and C_Spell.PickupSpell then
                    C_Spell.PickupSpell(id)
                end

            elseif t == "item" then
                PickupItem(id)

            elseif t == "macro" then
                PickupMacro(id)

            elseif t == "equipmentset" then
                if C_EquipmentSet and C_EquipmentSet.PickupEquipmentSet then
                    C_EquipmentSet.PickupEquipmentSet(id)
                end

            elseif t == "summonpet" then
                if C_PetJournal and C_PetJournal.PickupPet then
                    C_PetJournal.PickupPet(id)
                end

            elseif t == "summonmount" then
                if C_MountJournal and C_MountJournal.Pickup then
                    C_MountJournal.Pickup(id)
                end
            end

            PlaceAction(i)
            ClearCursor()
        end
    end

    -- Restore keybindings
    for cmd, keys in pairs(data.keybinds or {}) do
        if keys[1] then SetBinding(keys[1], cmd) end
        if keys[2] then SetBinding(keys[2], cmd) end
    end

    SaveBindings(2) -- commit restored bindings
    print("LUI: Profile '" .. profileName .. "' loaded.")
end
