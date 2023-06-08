-- https://www.aseprite.org/api/

app.command.ImportSpriteSheet {
   ui=true,
   type=SpriteSheetType.ROWS,
   frameBounds=Rectangle(0, 0, 32, 32),
   padding=Size(0, 0),
   partialTiles=false
   }

local spr = app.activeSprite
if spr == nil then
   return app.alert("There's no active script")
end

app.command.DuplicateSprite()
local sprite1 = app.activeSprite
app.command.DuplicateSprite()
local sprite2 = app.activeSprite

for i = 1, 50 do
   sprite1:deleteFrame(1)
   sprite2:deleteFrame(51)
end

-- Function to create animation tags
function create_animation_tags(spr, names, frames_per_tag, frameDuration)
   for i, name in ipairs(names) do
      local from_frame = (i-1) * frames_per_tag + 1
      local to_frame = from_frame + frames_per_tag - 1

      if from_frame > #spr.frames or to_frame > #spr.frames then
         return app.alert("The sprite does not have enough frames for the " .. name .. " animation.")
      end

      local tag = spr:newTag(from_frame, to_frame)
      tag.name = name
      tag.aniDir = AniDir.FORWARD
      tag.color = Color(math.random(0,255), math.random(0,255), math.random(0,255))
      for j = from_frame, to_frame do
         spr.frames[j].duration = frameDuration
      end
   end
end

local loopNames = { 'idle', 'gesture', 'walk', 'attack', 'death' }
create_animation_tags(sprite1, loopNames, 10, 0.1)
create_animation_tags(sprite2, loopNames, 10, 0.1)

app.refresh()
