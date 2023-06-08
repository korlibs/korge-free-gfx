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

local loopNames = { 'idle', 'gesture', 'walk', 'attack', 'death' }
local frameTime = 0.1
local framesPerLoop = 10
local numberOfFramesPerSprite = #loopNames * framesPerLoop
local numberOfSprites = #spr.frames / numberOfFramesPerSprite

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

function delete_frames_range(spr, from, to)

   for j = from, to do
      spr:deleteFrame(from)
   end
end

function keep_frames_range(spr, from, to)
   delete_frames_range(spr, 1, from - 1)
   delete_frames_range(spr, to + 1, #spr.frames)
end

local sprites = {}
for i = 1, numberOfSprites do
   app.command.DuplicateSprite()
   local sprite = app.activeSprite
   table.insert(sprites, sprite)
end

--app.alert("sprites" .. tostring(#sprites))

for i, sprite in ipairs(sprites) do
   --app.alert("sprite" .. tostring(sprite))
   local from = 1 + (i - 1) * numberOfFramesPerSprite
   keep_frames_range(sprite, from, from + numberOfFramesPerSprite - 1)
   create_animation_tags(sprite, loopNames, framesPerLoop, frameTime)
end

app.refresh()
