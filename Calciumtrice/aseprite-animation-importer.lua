do
   app.command.ImportSpriteSheet {
      ui=true,
      type=SpriteSheetType.ROWS,
      frameBounds=Rectangle,
      padding=Size(0, 0),
      partialTiles=false
    }

   local spr = app.activeSprite
   if spr == nil then
      return app.alert("There's no active script")
   end

   local frameDuration = 0.1
   local loopNames = { 'idle', 'gesture', 'walk', 'attack', 'death' }
   for i, loopName in ipairs(loopNames) do
      local fromFrame = (i-1) * 10 + 1
      local toFrame = fromFrame + 9
      local newTag = spr:newTag(fromFrame, toFrame)
      newTag.name = loopName
      newTag.aniDir = AniDir.FORWARD
      newTag.color = Color(math.random(0,255), math.random(0,255), math.random(0,255))
      for j = fromFrame, toFrame do
         spr.frames[j].duration = frameDuration
      end
   end

   app.refresh()
end
