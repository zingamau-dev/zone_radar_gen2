local mod = ...

mod.hooks:wrap("ui.start_menu.items", function(next, game, items)
  local result = next(game, items) or items

  mod.ui.insertBefore(result, "SAVE", {
    label = "ZONE RADAR",
    onSelect = function()
      -- Close the pause menu
      if game.stack then game.stack:pop() end
      
      -- Load the native TextBox
      local ok_tb, TextBox = pcall(require, "src.render.TextBox")
      if not ok_tb or not TextBox then return end

      -- Safety check: if we are not in Gen 2, warn and exit
      if not game.world then
        game.stack:push(TextBox.new(game, "Zone Radar\nGen 2 Only."))
        return
      end
      
      -- Map ID
      local mapId = game.world.map and game.world.map.id or "UNKNOWN"
      local targetId = mapId:gsub(" ", "_")
      
      -- Surf check (Gen 2)
      local isSurfing = false
      if game.world.player and game.world.player.spriteDef then
        local spriteId = game.world.player.spriteDef.id
        if spriteId == "SPRITE_SURF" or spriteId == "SPRITE_SURF_PIKA" then
          isSurfing = true
        end
      end
      
      -- Fetch encounter data
      local scanType = isSurfing and "water" or "grass"
      local ok, encounterReg = pcall(function() return mod.content.encounters:get(scanType) end)
      
      if not ok or not encounterReg then
        game.stack:push(TextBox.new(game, "Registry error."))
        return
      end

      local encounterData = encounterReg[targetId] or encounterReg[mapId]
      local baseSlots = encounterData and (encounterData.slots or encounterData)

      if not baseSlots then
        game.stack:push(TextBox.new(game, mapId .. "\nNo POKéMON here."))
        return
      end

      -- Parse data and percentages based on time of day
      local slots
      local percs
      local header = mapId

      if isSurfing then
        slots = baseSlots
        header = header .. " - [SURF]\f"
        percs = {"60%", "30%", "10%"} 
      else
        local daytime = "DAY"
        if game.world.timeOfDay then
          if type(game.world.timeOfDay) == "function" then
            daytime = game.world:timeOfDay()
          else
            daytime = game.world.timeOfDay
          end
        end
        
        -- Normalize time strings
        if daytime == "DARK" then daytime = "NITE" end
        if type(daytime) ~= "string" then daytime = "DAY" end
        
        slots = baseSlots[daytime] or baseSlots.DAY
        header = header .. " - [" .. daytime .. "]\f"
        percs = {"30%", "30%", "20%", "10%", "5%", "4%", "1%"} 
      end

      if not slots or #slots == 0 then
        game.stack:push(TextBox.new(game, mapId .. "\nData format error."))
        return
      end

      -- Safe pagination for GameBoy hardware (max 2 lines)
      local text = header
      for i, slot in ipairs(slots) do
        local perc = percs[i] or "?%"
        local spec = slot.species or "Empty"
        local lvl = slot.level or 0
        
        text = text .. perc .. ": " .. spec .. " L" .. lvl
        
        if i < #slots then
          if i % 2 == 0 then
            text = text .. "\f" -- New page
          else
            text = text .. "\n" -- New line
          end
        end
      end

      -- Print to screen
      game.stack:push(TextBox.new(game, text))
    end,
  })

  return result
end)