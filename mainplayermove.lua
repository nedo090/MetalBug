require "loadsprite"
require "cameram"
require "load"

function getPosition(player)
  return player.x - width/2, player.y - height/2
end


function checkoutframe(curr_anim,curr_frame)
  --do a switch state for the animation
  if curr_anim =="throw" then
    return curr_frame >= 6 and 6 or curr_frame
  elseif curr_anim == "shoot_up" then
    return curr_frame > 9 and 1 or curr_frame
  elseif curr_anim == "idle_crouch" then
    return curr_frame > 9 and 1 or curr_frame
  else
    return curr_frame >= 12 and 1 or curr_frame
  end
end
--]]
function getplayer()
  local sprite  = {}

  sprite.player = loadplayer()
  if sprite.player == nil then return nil end

  sprite.curr_anim_body = "idle_body"
  sprite.curr_anim_leg = "idle_leg"
  sprite.curr_frame_body = 1
  sprite.curr_frame_leg = 1
  sprite.elapsedtime = 0
  sprite.timethrowbombs = 0
  sprite.time_scale = 1
  sprite.pointplayer = 0
  sprite.endanim = 0

  return sprite

end

alignement = 2

local function alignmentlegs( curr_frame_leg )

        if curr_frame_leg == 1 then
          alignement = 4
        elseif curr_frame_leg == 2 then
          alignement = 6
        elseif curr_frame_leg == 3 then
          alignement = 7
        elseif curr_frame_leg == 4 then
          alignement = 1
        elseif curr_frame_leg == 5 then
          alignement = -3
        elseif curr_frame_leg == 6 then
          alignement = 1
        elseif curr_frame_leg == 7 then
          alignement = 2
        elseif curr_frame_leg == 8 then
          alignement = 5
        elseif curr_frame_leg == 9 then
          alignement = 4
        elseif curr_frame_leg == 10 then
          alignement = -4
        elseif curr_frame_leg == 11 then
          alignement = -3
        else
          alignement = 0
        end
end
--update move of grenate
local function UpdateGrenate(player,dt)

  local gravity = 450.8
  local bombs = player.bombs
  local ground = player.ground+40
  --draw hope parabolic coordinates for grenate
  for i,v in ipairs(bombs) do

    v.elapsedbombs = v.elapsedbombs + dt

    v.x = v.x0 + v.speedx*v.elapsedbombs*v.reverse
    v.y = v.y0 - (v.speedy*v.elapsedbombs - 0.5*gravity*v.elapsedbombs^2)

  end

  --remove bombs if go outside of screen
  for i = #bombs,1,-1 do
    local v = bombs[i]
    if (v.x < camera.x -5 ) or (v.x > width + 5+camera.x )
    or (v.y > ground ) then --or (v.y > height + 5)then
      table.remove(bombs,i)
    end
  end
end

local function UpdateBullets(bullets,dt)

  for i,v in ipairs(bullets) do

    if v.up then
      v.y = v.y + v.speed*dt*-1
    else
      v.x = v.x + v.speed*dt*v.reverse
    end
  end
  --remove bullets from table
  for i = #bullets,1,-1 do
    local v = bullets[i]
    if (v.x < camera.x -10) or (v.x > width + camera.x )
    or (v.y < -5 ) or (v.y > height + 5)then
      table.remove(bullets,i)
    end
  end
end
--move the animation sprite iterate on array of animation
function UpdatePlayer(sprite,dt)

  sprite.elapsedtime = sprite.elapsedtime + dt

  local outl = sprite.player.movement[sprite.curr_anim_leg][sprite.curr_frame_leg]

  if sprite.elapsedtime > sprite.player.frame_duration * sprite.time_scale then

      if outl == nil then sprite.curr_frame_leg = 1 end

      if sprite.curr_frame_leg < #sprite.player.movement[sprite.curr_anim_leg] then
         sprite.curr_frame_leg = sprite.curr_frame_leg + 1

         alignmentlegs(sprite.curr_frame_leg)
      else
        sprite.curr_frame_leg = 1
        alignement = 0
      end
      --check if null
      local outb = sprite.player.movement[sprite.curr_anim_body][sprite.curr_frame_body]
      if outb == nil then sprite.curr_frame_body = 1 end

      --move sprite for body
      if sprite.curr_frame_body < #sprite.player.movement[sprite.curr_anim_body] then
         sprite.curr_frame_body = sprite.curr_frame_body + 1

      else
        --means end of sprite
        if sprite.player.dead then
          deathsound:play()
          sprite.endanim = 1
          return 
        end

          sprite.player.shoot = false
          sprite.player.throw = false
        if sprite.player.crouch  then
          sprite.curr_frame_body = 4
        else
          sprite.curr_frame_body = 1
        end
      end
     sprite.elapsedtime = 0
  end

  if #sprite.player.bombs > 0 then UpdateGrenate(sprite.player,dt) end
  if #sprite.player.bullets > 0 then UpdateBullets(sprite.player.bullets,dt) end

end

local function sign(x)
  return x > 0 and 1 or x < 0 and -1
end
--draw player only if run
--and check if shoot or throw bomb or only move
local function drawrunning(sprite,rev)

    sprite.curr_anim_leg = "move_leg"
      --alignment body and legs for run
      local alignment = alignement*sign(rev)

        love.graphics.draw(
          sprite.player.img_div,
          sprite.player.movement[sprite.curr_anim_leg][sprite.curr_frame_leg],
          sprite.player.x - (alignment)- rev*15,
          sprite.player.y + 40,
          0,
          rev,
          2
        )
    --check the state of player
    local  y = 0
    if sprite.player.shoot then
       sprite.curr_anim_body = "shoot_move"
       if sprite.player.up then
        sprite.curr_anim_body = "shoot_up"
          if sprite.curr_frame_body <= 3 then
            y = 80
          else
            y = 30
          end
       end
    elseif sprite.player.throw then
       sprite.curr_anim_body = "throw"
    elseif sprite.player.up then
      sprite.curr_anim_body = "body_up"
      y = 6
    else
       sprite.curr_anim_body = "move_body"
    end

    --print(sprite.curr_anim_body, sprite.curr_frame_body)
    --check if out of bounds
    sprite.curr_frame_body = checkoutframe(sprite.curr_anim_body,sprite.curr_frame_body)

        love.graphics.draw(
          sprite.player.img_div,
          sprite.player.movement[sprite.curr_anim_body][sprite.curr_frame_body],
          sprite.player.x- rev*15,
          sprite.player.y-y,
          0,
          rev,
          2
        )
        --]]
end

local function drawjump(sprite,rev)

   sprite.curr_anim_leg = "jump_leg"
  --local variable for alignment sprite body and legs
   local y = -1
   local d = 14
    --check if shoot in air
    if sprite.player.shoot then
      sprite.curr_anim_body = "shoot"
      d = 0
      if sprite.player.up then
       sprite.curr_anim_body = "shoot_up"
        if sprite.curr_frame_body <= 3 then
          y = 80
        else
          y = 30
        end
      end
    elseif sprite.player.throw then
       sprite.curr_anim_body = "throw"
       d = 0
    elseif sprite.player.up then
       sprite.curr_anim_body = "body_up"
       d,y = 0,4
    else
       sprite.curr_anim_body = "jump_body"
    end
    --alignment body and legs for the jump
    d = d*sign(rev)

        --draw legs
        love.graphics.draw(
          sprite.player.img_div,
          sprite.player.movement[sprite.curr_anim_leg][sprite.curr_frame_leg],
          sprite.player.x + d - rev*15,
          sprite.player.y + 40,
          0,
          rev,
          2
        )
        --print(sprite.curr_anim_body, sprite.curr_frame_body)

        --check if out of array
        sprite.curr_frame_body = checkoutframe(sprite.curr_anim_body,sprite.curr_frame_body)

        love.graphics.draw(
          sprite.player.img_div,
          sprite.player.movement[sprite.curr_anim_body][sprite.curr_frame_body],
          sprite.player.x- rev*15,
          sprite.player.y - y,
          0,
          rev,
          2
        )
    --]]

end

--draw player on crouch only one sprite
local function drawcrouch(sprite,rev)

    if sprite.curr_frame_body > 9 then
      sprite.curr_frame_body = 4 end

    local y = -25
    if sprite.player.shoot then
       sprite.curr_anim_body = "shoot_crouch"

    elseif sprite.player.throw then
       sprite.curr_anim_body = "throw_crouch"
    elseif sprite.player.run then
       sprite.curr_anim_body = "move_crouch"
    else
       sprite.curr_anim_body = "idle_crouch"
       if sprite.curr_frame_body <=3 then y = 0 end
    end

        --print(sprite.curr_anim_body, sprite.curr_frame_body)
        sprite.curr_frame_body = checkoutframe(sprite.curr_anim_body,sprite.curr_frame_body)

        love.graphics.draw(
          sprite.player.img_div,
          sprite.player.movement[sprite.curr_anim_body][sprite.curr_frame_body],
          sprite.player.x - rev*14,
          sprite.player.y - y,
          0,
          rev,
          2
        )

end

--check while look up if shoot
local function drawup(sprite,rev)

    --sprite.curr_frame_body
    if sprite.player.run then
      sprite.curr_anim_leg = "move_leg"
    else
      sprite.curr_anim_leg = "idle_leg_up"
    end
    love.graphics.draw(
          sprite.player.img_div,
          sprite.player.movement[sprite.curr_anim_leg][1],
          sprite.player.x - rev*15,
          sprite.player.y + 40,
          0,
          rev,
          2
    )
    local y = 6

    if sprite.player.shoot then
       sprite.curr_anim_body = "shoot_up"
       if sprite.curr_frame_body <= 3 then
          y = 80
       else
          y = 30
       end
    else
      sprite.curr_anim_body = "body_up"
    end

    --print(sprite.curr_anim_body, sprite.curr_frame_body)
    sprite.curr_frame_body = checkoutframe(sprite.curr_anim_body,sprite.curr_frame_body)

    love.graphics.draw(
          sprite.player.img_div,
          sprite.player.movement[sprite.curr_anim_body][sprite.curr_frame_body],
          sprite.player.x - rev*15,
          sprite.player.y - y,
          0,
          rev,
          2
    )
end

--check in idle if shoot of throw bomb and if go out of array
local function stateidledraw(sprite)

    sprite.curr_anim_body = "idle_body"

    if sprite.player.shoot then sprite.curr_anim_body = "shoot"

    elseif sprite.player.throw then sprite.curr_anim_body = "throw" return end

    if sprite.player.movement[sprite.curr_anim_body][sprite.curr_frame_body] == nil then
          sprite.curr_frame_body = 1
    end
end

function DrawPlayer(sprite)
--if run 2 draw for body and for legs

local rev = sprite.player.reverse*2

  --check  if there is bombs or bullet for draw on screen
  if #sprite.player.bombs > 0 then
     DrawGrenate(sprite.player.bombs,sprite.player.grenate)
  end

  if #sprite.player.bullets > 0 then
     DrawBullet(sprite.player.bullets,sprite.player)
  end

--check what state the player is jump crouch run up or idle
  if sprite.player.dead then
    drawdeath(sprite,rev)

  elseif sprite.player.y_speed ~= 0 then

    drawjump(sprite,rev)

  elseif sprite.player.crouch then

    drawcrouch(sprite,rev)

  elseif sprite.player.run then

    drawrunning(sprite,rev)

  elseif sprite.player.up then

    drawup(sprite,rev)

  else
    local y = 40
    stateidledraw(sprite)
    --call 2 draw for body and for leg
        love.graphics.draw(
          sprite.player.img_div,
          sprite.player.movement[sprite.curr_anim_leg][1],
          sprite.player.x- rev*15,
          sprite.player.y + y ,
          0,
          rev,
          2
        )
        --print(sprite.curr_anim_body,sprite.curr_frame_body)

        love.graphics.draw(
          sprite.player.img_div,
          sprite.player.movement[sprite.curr_anim_body][sprite.curr_frame_body],
          sprite.player.x- rev*15,
          sprite.player.y,
          0,
          rev,
          2
        )
  end
end


--jump character with is sprite associate
function Jump(player)
  if player.y_speed == 0 then
    player.y_speed = player.jumph
  end
end

--check gravity and ground after jump
function jumpgravity(sprite,dt)

  local player = sprite.player

  player.y = player.y + player.y_speed*dt
  player.y_speed = player.y_speed - player.gravity*dt

  if player.y > player.ground then
    player.y_speed = 0
    player.y = player.ground

    sprite.curr_anim_leg = "idle_leg"
    sprite.curr_frame_leg = 1
  end
end


local function drawdeathburn(sprite,rev)


  love.graphics.draw(
          sprite.player.img_div,
          sprite.player.movement[sprite.curr_anim_body][sprite.curr_frame_body],
          sprite.player.x- rev*15,
          sprite.player.y - 20 ,
          0,
          rev,
          2
        )
end

local function drawdeathroll(sprite,rev)

  love.graphics.draw(
          sprite.player.img_div,
          sprite.player.movement[sprite.curr_anim_body][sprite.curr_frame_body],
          sprite.player.x- rev*15,
          sprite.player.y ,
          0,
          rev,
          2
        )
end
local function drawdeathknife(sprite,rev)
  love.graphics.draw(
          sprite.player.img_div,
          sprite.player.movement[sprite.curr_anim_body][sprite.curr_frame_body],
          sprite.player.x- rev*15,
          sprite.player.y ,
          0,
          rev,
          2
        )

end

function drawdeath(sprite,rev)

  --check various type of death
  if sprite.curr_anim_body == "death_burn" then drawdeathburn(sprite,rev)
  elseif sprite.curr_anim_body == "death_rolling" then drawdeathroll(sprite,rev)
  else drawdeathknife(sprite,rev) end

end

--draw bombs image grenate
function DrawGrenate(bombs,grenate)

  for i,v in ipairs(bombs) do

    love.graphics.draw(grenate,v.x,v.y,0,2,2)

  end
end

--draw bullet on screen
function DrawBullet(bullets,player)

  for i,v in ipairs(bullets) do

    local rev = v.reverse*2
    if v.up then

      love.graphics.draw(player.img,player.bulletup,v.x,v.y,0,rev,2)

    else

      love.graphics.draw(player.img,player.bullet,v.x,v.y,0,rev,2)

    end
  end

end
