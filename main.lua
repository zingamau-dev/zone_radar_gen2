local mod = ...

mod.hooks:wrap("ui.start_menu.items", function(next, game, items)
  local result = next(game, items) or items

  -- Inseriamo il pulsante sopra SAVE nel menu principale
  mod.ui.insertBefore(result, "SAVE", {
    label = "ZONE RADAR",
    onSelect = function()
      if game.stack then game.stack:pop() end
      
      local mapId = game.world and game.world.map and game.world.map.id or "UNKNOWN"
      local targetId = mapId:gsub(" ", "_")
      
      local ok, grassReg = pcall(function() return mod.content.encounters:get("grass") end)
      
      if not ok or not grassReg then
        local ok_tb, TextBox = pcall(require, "src.render.TextBox")
        if ok_tb and TextBox then game.stack:push(TextBox.new(game, "Registry error.")) end
        return
      end

      local grassData = grassReg[targetId] or grassReg[mapId]
      if not grassData and grassReg["ROUTE_30"] then
         grassData = grassReg["ROUTE_30"]
         targetId = "ROUTE_30 (Forced)"
      end

      if not grassData or not grassData.slots then
        local ok_tb, TextBox = pcall(require, "src.render.TextBox")
        if ok_tb and TextBox then game.stack:push(TextBox.new(game, targetId .. "\nNo grass data found.")) end
        return
      end

      local daytime = "DAY"
      if game.world and game.world.timeOfDay then
        if type(game.world.timeOfDay) == "function" then
          daytime = game.world:timeOfDay()
        else
          daytime = game.world.timeOfDay
        end
      end
      if daytime == "DARK" then daytime = "NITE" end
      if type(daytime) ~= "string" then daytime = "DAY" end

      local slots = grassData.slots[daytime] or grassData.slots.DAY
      if not slots then
        local ok_tb, TextBox = pcall(require, "src.render.TextBox")
        if ok_tb and TextBox then game.stack:push(TextBox.new(game, targetId .. "\nNo time data.")) end
        return
      end

      local text = targetId .. " (" .. daytime .. ")\n"
      text = text .. "30%: " .. tostring(slots[1] and slots[1].species or "Empty") .. " L" .. tostring(slots[1] and slots[1].level or 0) .. "\f"
      text = text .. "30%: " .. tostring(slots[2] and slots[2].species or "Empty") .. " L" .. tostring(slots[2] and slots[2].level or 0) .. "\n"
      text = text .. "20%: " .. tostring(slots[3] and slots[3].species or "Empty") .. " L" .. tostring(slots[3] and slots[3].level or 0) .. "\f"
      text = text .. "10%: " .. tostring(slots[4] and slots[4].species or "Empty") .. " L" .. tostring(slots[4] and slots[4].level or 0) .. "\n"
      text = text .. "5%: " .. tostring(slots[5] and slots[5].species or "Empty") .. " L" .. tostring(slots[5] and slots[5].level or 0) .. "\f"
      text = text .. "4%: " .. tostring(slots[6] and slots[6].species or "Empty") .. " L" .. tostring(slots[6] and slots[6].level or 0) .. "\n"
      text = text .. "1%: " .. tostring(slots[7] and slots[7].species or "Empty") .. " L" .. tostring(slots[7] and slots[7].level or 0)

      local ok_tb, TextBox = pcall(require, "src.render.TextBox")
      if ok_tb and TextBox then
        game.stack:push(TextBox.new(game, text))
      end
    end,
  })

  return result
end)