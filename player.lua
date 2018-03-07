require "cameram"
require "load"
require "mainplayermove"
require "enemy"


width = love.graphics.getWidth()
height = love.graphics.getHeight()



player = {}
enemies = {}
bullets = {}
PlayerSprite = {}


local function WinPlayer()

    StateGame = winner
    camera:removeAllLayer()
    StateGame.load(PlayerSprite)

    PlayerSprite.player.up = false
    PlayerSprite.player.run = false
    PlayerSprite.player.crouch = false
    PlayerSprite.player.shoot = false
    PlayerSprite.player.throw = false
    PlayerSprite.player.y = 460
    PlayerSprite.player.reverse = 1

end

function endgame()

    for i = #enemies,1,-1 do
      table.remove(enemies)
    end
    for v = #enemies.bullets,1,-1 do
      table.remove(enemies.bullets)
    end
    if enemies.edit ~= nil then
      enemies.edit = nil
      BackGround.index = 1
    end
    camera:ToMenu()
    StateGame = menu

    PlayerSprite.player.up = false
    PlayerSprite.player.crouch = false
    PlayerSprite.player.y = 460
    PlayerSprite.player.run = false
    PlayerSprite.player.reverse = 1
    PlayerSprite.endanim = 0

end


--change background image for different level
--change with id a number for image
local function changeBackground()

    if enemies.edit == true then
      BackGround.index = 1
      WinPlayer()
    elseif BackGround.index < 6 then
      BackGround.index = BackGround.index +1
      camera:setX(0)
      PlayerSprite.player.x = 70
      camera:setBounds(0,0,BackGround.endback[BackGround.index],height)
    else
      --PlayerSprite.player.dead = true
      BackGround.index = 1
      WinPlayer()
    end
end


local function loadingbackground()


    --background map for player add editor for choose platform
    local background = {}
    background[1] = Background[1]
    background[2] = Background[2]
    background[3] = Background[3]
    background[4] = Background[4]
    background[5] = Background[5]
    background[6] = Background[6]
    background[7] = Background[7]
    --index for change background
    background.index = 1
    background.scale = {}
    background.endback = {}

    for i,v in ipairs(background)do

      background.scale[i] = v:getWidth()*2.5
      background.endback[i] = background.scale[i] - width

      --backgroundheight = BackgroundPlayer[1]:getHeight()
    end

    return background

end

--load sprite of player, enemy and background
function player.load()

  --load player if nil is first time call
  if PlayerSprite.player == nil then
    PlayerSprite = getplayer()
    --loading Background
    BackGround = loadingbackground()
  end
  --timer for create enemy
  enemies.spawntimer = 2
  --if level edited not spawnenemy and end level
  enemies.edit = nil
  --table for all bullet of enemy
  enemies.bullets = {}
  --loading all background for all level

  --add layer to camera for drawing
  camera:ToGame()

  end

--function call by the editor
function player.loadedit(index,endbound)
  --if the first time load
  if PlayerSprite.player == nil then
    PlayerSprite = getplayer()
    BackGround = loadingbackground()
    enemies.bullets = {}
    enemies.spawntimer = 2
  end
    BackGround.index = index
    enemies.edit = true

    PlayerSprite.pointplayer = 0

    BackGround.scale[index] = endbound + width
    BackGround.endback[index] = endbound
    camera:ToGame()

end

--function for movement of player
function player.move(dt)
  local dead = PlayerSprite.player.dead

  if not dead then
    if love.keyboard.isDown(BindKey["d"]) then --press the right arrow key to push the player to the right
      PlayerSprite.player.reverse = 1
      PlayerSprite.player.run = true
      --check if crouch and then if shooting or throwing if true dont move
      --and if crouch move slower
      if PlayerSprite.player.crouch and (PlayerSprite.player.shoot or PlayerSprite.player.throw) then
        --not move
      elseif PlayerSprite.player.crouch and not PlayerSprite.player.shoot then
        PlayerSprite.player.x = PlayerSprite.player.x + PlayerSprite.player.speedcrouch*dt
      else
        PlayerSprite.player.x = PlayerSprite.player.x + PlayerSprite.player.speed*dt
      end
    elseif love.keyboard.isDown(BindKey["a"]) and PlayerSprite.player.x > 50 then
      PlayerSprite.player.reverse = -1
      PlayerSprite.player.run = true
      --check if crouch and then if shooting or throwing if true dont move
      --and if crouch move slower
      if PlayerSprite.player.crouch and (PlayerSprite.player.shoot or PlayerSprite.player.throw) then
        --not move
      elseif PlayerSprite.player.crouch and not PlayerSprite.player.shoot then
        PlayerSprite.player.x = PlayerSprite.player.x - PlayerSprite.player.speedcrouch*dt
      else
        PlayerSprite.player.x = PlayerSprite.player.x - PlayerSprite.player.speed*dt
      end
    end
  --in death rolling go back roll and die
  elseif dead and PlayerSprite.curr_frame_body < 12 and PlayerSprite.curr_anim_body ~="death_knife" then
      PlayerSprite.player.x = PlayerSprite.player.x + (PlayerSprite.player.reverse*-1)*PlayerSprite.player.speedcrouch*dt
  end


  if love.keyboard.isDown(BindKey["w"]) and not dead then
    PlayerSprite.player.up = true
  elseif love.keyboard.isDown(BindKey["s"]) and PlayerSprite.player.y_speed == 0 and not dead then
    PlayerSprite.player.crouch = true
  end

  --see jump
  if love.keyboard.waspressed(BindKey["k"]) and not dead then
    PlayerSprite.player.crouch = false
    Jump(PlayerSprite.player)
  end
  love.keyboard.keyspressed[BindKey["k"]] = false

  if PlayerSprite.player.y_speed ~= 0 then
    jumpgravity(PlayerSprite,dt)
  end

end

function player.keyreleased(key)
  if key == BindKey["d"] then
    PlayerSprite.curr_anim_leg = "idle_leg"
    PlayerSprite.curr_frame_leg = 1
    PlayerSprite.player.run = false
  elseif key == BindKey["a"] then
    PlayerSprite.curr_anim_leg = "idle_leg"
    PlayerSprite.curr_frame_leg = 1
    PlayerSprite.player.run = false
  elseif key == BindKey["w"] and not PlayerSprite.player.dead then
    PlayerSprite.player.up = false
    PlayerSprite.curr_frame_body = 1
  elseif key ==BindKey["s"] then
    PlayerSprite.player.crouch = false
  elseif key == "q" and PlayerSprite.player.dead then
    endgame()
  end
end

--insert bombs
local function fillbomb()

  local rev = PlayerSprite.player.reverse
  local speedplayer = (PlayerSprite.player.run  and 200 or 0)
  local crouch = PlayerSprite.player.crouch and 1 or 0
  --print(speedplayer)
  table.insert(PlayerSprite.player.bombs, {
    x  = PlayerSprite.player.x + (10*rev),
    y  = PlayerSprite.player.y + (crouch)*20,
    x0 = PlayerSprite.player.x + (10*rev),
    y0 = PlayerSprite.player.y + (crouch)*20,
    w = 20,
    h = 15,
    reverse = rev,
    speedx = speedplayer + 650*math.sin(math.pi/6),
    speedy = 260*math.cos(math.pi/6),
    elapsedbombs = 0
  })

end

local function fillbullet()

  local rev = PlayerSprite.player.reverse
  local crouch = PlayerSprite.player.crouch and 1 or 0
--insert bullet in up or horizontal
  if PlayerSprite.player.up then
    table.insert(PlayerSprite.player.bullets, {
      x = PlayerSprite.player.x - 15*rev,
      y = PlayerSprite.player.y - 42,
      w = 6,
      h = 10,
      reverse = rev,
      up = true,
      speed = 1000
    })
  else
    table.insert(PlayerSprite.player.bullets, {
      x = PlayerSprite.player.x + 80*rev,
      y = PlayerSprite.player.y + 15+crouch*30,
      w = 10,
      h = 6,
      reverse = rev,
      up = false,
      speed = 1000
    })
  end
end

--shoot bulllet and bombs
function player.shoot(dt)

  local dead = PlayerSprite.player.dead
  local up   = PlayerSprite.player.up
  local crouch = PlayerSprite.player.crouch
  --add bullets in table
  if love.keyboard.waspressed(BindKey["j"]) and not dead then
    PlayerSprite.player.shoot = true
    PlayerSprite.player.throw = false
    fillbullet()
    PlayerSprite.curr_frame_body = 1

  end
  love.keyboard.keyspressed[BindKey["j"]] = false

  if love.keyboard.waspressed(BindKey["l"]) and not up and not dead then
    if PlayerSprite.timethrowbombs > 1 then
      PlayerSprite.player.throw = true
      PlayerSprite.player.up = false
      PlayerSprite.player.shoot = false
      fillbomb()
      PlayerSprite.curr_frame_body = 1
      PlayerSprite.timethrowbombs = 0
    end
  end
  love.keyboard.keyspressed[BindKey["l"]] = false
  PlayerSprite.timethrowbombs = PlayerSprite.timethrowbombs +dt

  for i,v in ipairs(enemies) do
    if v.curr_anim == "idle_laugh" and PlayerSprite.player.shoot then
      v.curr_anim = "scare"
      v.curr_frame = 1
    end
  end

end

--update worlds
function player.resize(w,h)

    width = w
    height = h

end

--check if sprite intersect then return true
--this means a collision
local function intersect(r1,r2)
  if r1.x < r2.x and r1.x + r1.w > r2.x and
     r1.y < r2.y and r1.y + r1.h > r2.y then
    return true
  else
    return false
  end
end


function intersectEnemy(r1,r2)
  if not PlayerSprite.player.crouch then
      if r1.x > (r2.x+r2.w) or r2.x > (r1.x + r1.w) then
        return false
      end
      if r1.y > (r2.y +r2.h) or r2.y > (r1.y + r1.h) then
        return false
      end
  else
      if r1.y > (r2.y -20  +r2.h ) or r2.y > (r1.y -20 + r1.h ) then
        return false
      end
      if r1.x > (r2.x+r2.w) or r2.x > (r1.x + r1.w) then
        return false
      end

  end
    return true
end
--]]

--check for collision
function checkcollision()
  local dead = PlayerSprite.player.dead

  --check collison with bullet and with bombs
  for i,enemy in ipairs(enemies)do
    --collision with bullet
    for j,v in ipairs(PlayerSprite.player.bullets)do
      if (intersect(v,enemy) or intersect(enemy,v)) and not enemy.dead then
        if enemy.curr_anim == "jump_knife" then
          table.remove(PlayerSprite.player.bullets,j)
          enemy.dead = true
          enemy.curr_anim = "death_knife"
          enemy.curr_frame = 1
          PlayerSprite.pointplayer = PlayerSprite.pointplayer + 30
        elseif enemy.curr_anim == "shoot_rifle" then
          table.remove(PlayerSprite.player.bullets,j)
          enemy.dead = true
          enemy.curr_anim = "brutal_death"
          enemy.curr_frame = 1
          PlayerSprite.pointplayer = PlayerSprite.pointplayer + 10
        elseif enemy.curr_anim == "shoot" then
          table.remove(PlayerSprite.player.bullets,j)
          enemy.dead = true
          enemy.curr_anim = "brutal_death"
          enemy.curr_frame = 1
          PlayerSprite.pointplayer = PlayerSprite.pointplayer + 20
        else
          table.remove(PlayerSprite.player.bullets,j)
          enemy.dead = true
          enemy.curr_anim = "brutal_death"
          enemy.curr_frame = 1
          PlayerSprite.pointplayer = PlayerSprite.pointplayer - 50
        end
      end
    end

    --collison with rock
    for j,v in ipairs(PlayerSprite.player.bombs)do
      if (intersect(v,enemy) or intersect(enemy,v)) and not enemy.dead then
        if enemy.curr_anim == "jump_knife" then
          table.remove(PlayerSprite.player.bombs,j)
          enemy.dead = true
          enemy.curr_anim = "death_rock"
          enemy.curr_frame = 1
          PlayerSprite.pointplayer = PlayerSprite.pointplayer + 200
        elseif enemy.curr_anim == "shoot" then
          table.remove(PlayerSprite.player.bombs,j)
          enemy.dead = true
          enemy.curr_anim = "death_rock"
          enemy.curr_frame = 1
          PlayerSprite.pointplayer = PlayerSprite.pointplayer + 150
        elseif enemy.curr_anim == "shoot_rifle" then
          table.remove(PlayerSprite.player.bombs,j)
          enemy.dead = true
          enemy.curr_anim = "death_rock"
          enemy.curr_frame = 1
          PlayerSprite.pointplayer = PlayerSprite.pointplayer + 100
        else
          table.remove(PlayerSprite.player.bombs,j)
          enemy.dead = true
          enemy.curr_anim = "death_rock"
          enemy.curr_frame = 1
          PlayerSprite.pointplayer = PlayerSprite.pointplayer - 150
        end
      end
    end

    --if there is enemy with knife
    if (intersectEnemy(enemy,PlayerSprite.player) or intersectEnemy(PlayerSprite.player,enemy))
    and enemy.curr_anim == "jump_knife" and not dead then
        PlayerSprite.curr_anim_body  = "death_knife"
        PlayerSprite.curr_frame_body = 1
        PlayerSprite.player.dead = true
    end

  end

  --collison with the player and bullet of enemy
  for i,b in ipairs(enemies.bullets) do
    if (intersectEnemy(b,PlayerSprite.player) or intersectEnemy(PlayerSprite.player,b))
    and not dead then
      PlayerSprite.curr_anim_body = "death_burn"
      PlayerSprite.curr_frame_body = 1
      PlayerSprite.player.dead = true
    end
  end
end

function player.update(dt)

    if PlayerSprite.endanim == 0 then
      UpdatePlayer(PlayerSprite,dt)
      player.move(dt)
      player.shoot(dt)
      checkcollision()
      updatenemy(enemies,width,PlayerSprite.player,dt)
    else
      PlayerSprite.endanim = PlayerSprite.endanim + dt
      if PlayerSprite.endanim > 6 then
        endgame()
      end
    end

    --player in center of screen depend on coordinates
    if not PlayerSprite.player.dead then
      camera:setPosition(PlayerSprite.player.x - width/4)
      if PlayerSprite.player.x > BackGround.scale[BackGround.index]  then
        changeBackground()
      end
    end
end

--function for drawing background and point
function backgroundplayerdraw()

  love.graphics.draw(BackGround[BackGround.index],0,20,0,2.5,2.5)
  love.graphics.print("point: " .. tostring(PlayerSprite.pointplayer),camera.x,height - 40 )
end

--main function for draw player and enemies
function player.draw()

      DrawPlayer(PlayerSprite)
      Drawenemy(enemies)

end
