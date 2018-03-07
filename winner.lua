require "load"
require "player"
require "cameram"


winner = {}
function winner.load(Player)

  sprite = Player
  winner.time = 0

  sprite.player.x = width/2 - 45
  sprite.curr_anim_body = "win"
  sprite.curr_frame_body = 1
  camera:newLayer(1,winner.draw)
  winsound:play()
end

local function endwin()
    camera:ToMenu()
    StateGame = menu
    enemies.edit = nil
    PlayerSprite.pointplayer = 0

end


function winner.update(dt)

  sprite.elapsedtime = sprite.elapsedtime + dt

  if sprite.elapsedtime > sprite.player.frame_duration * sprite.time_scale then
      --check if null
      local outb = sprite.player.movement[sprite.curr_anim_body][sprite.curr_frame_body]
      if outb == nil then sprite.curr_frame_body = 1 end
      --move sprite for body
      if sprite.curr_frame_body < #sprite.player.movement[sprite.curr_anim_body] then
         sprite.curr_frame_body = sprite.curr_frame_body + 1
      else
        sprite.curr_frame_body = 1
      end
     sprite.elapsedtime = 0
  end
  winner.time = winner.time + dt
  if winner.time > 5 then
    endwin()
  end

end

function winner.keyreleased(key)

  if key == "q" then
    endwin()
  end

end


function winner.draw()

      love.graphics.setColor(247, 255, 0,255)
      love.graphics.print("WINNER",width/2-150,250)
      love.graphics.print("Point:" .. sprite.pointplayer,width/2-150,300)
      love.graphics.setColor(255, 255, 255)
      love.graphics.draw(
          sprite.player.img_div,
          sprite.player.movement[sprite.curr_anim_body][sprite.curr_frame_body],
          sprite.player.x,
          sprite.player.y,
          0,
          2,
          2
      )
end
