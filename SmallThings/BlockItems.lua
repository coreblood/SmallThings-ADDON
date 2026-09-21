--[[ SmallThings — Block items
     Auto-destroy or prevent looting of specific items (e.g. Omokk's Head).
     Destroys item immediately when looted, or prevents pickup. ]]

local ADDON, ns = ...

-- Items to block (itemId -> true)
local BLOCKED_ITEMS = {
    [12534] = true, -- Omokk's Head
}

-- Hook into ItemLooted event to destroy blocked items
hooksecurefunc("LootSlot", function(slot)
    if not (ns.db and ns.db.blockOmokksHead) then return end

    local lootInfo = { GetLootSlotInfo(slot) }
    local itemLink = lootInfo[7]  -- Get item link from loot info

    if not itemLink then return end

    -- Extract item ID from link: |cff...|Hitem:ITEMID:...|h[Name]|h|r
    local itemId = tonumber(itemLink:match("item:(%d+)"))

    if itemId and BLOCKED_ITEMS[itemId] then
        -- Loot and immediately destroy
        LootSlot(slot)

        -- Find item in bags and destroy it
        for bag = 0, 4 do
            for slot = 1, GetContainerNumSlots(bag) do
                local id = GetContainerItemID(bag, slot)
                if id == itemId then
                    PickupContainerItem(bag, slot)
                    DeleteCursorItem()
                    return
                end
            end
        end
    end
end)
