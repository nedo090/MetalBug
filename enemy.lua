require "load"


local imgBenemy = love.graphics.newImage("Enemies.png")
local imgBX,imgBY = imgBenemy:getDimensions()

local BigBulletEnemy = love.graphics.newQuad(256,519,59,24,imgBX,imgBY)
local RifleBulletEnemy = love.graphics.newQuad(628,707,30,4,imgBX,imgBY)


function loadenemy(x,type)


  --local imgX,imgY = imagenemy:getDimensions()
  imgAX,imgAY = imgAenemy:getDimensions()

  local enemy = {}

  enemy.img = imagenemy
  --enemy.imgB = imgBenemy
  enemy.imgA = imgAenemy
  --enemy.bullet = love.graphics.newQuad(260,510,51,23,imgBX,imgBY)

  enemy.y = 460
  enemy.x = x
  enemy.rev = 1
  enemy.w = 25
  enemy.h = 60
  enemy.bounds = 10
  enemy.speed = 1100
  enemy.ground = 460
  enemy.jump = false
  enemy.dead = false
  enemy.reverse = 1
  enemy.curr_frame = 1

  enemy.elapsedtime = 0
  enemy.frame_duration = 0.09

  if type < 1 then
    enemy.curr_anim = "idle_laugh"
  elseif type < 3 then
    enemy.curr_anim = "shoot"
  elseif type == 3 or type == 4 then
    enemy.curr_anim = "jump_knife"
  else
    enemy.curr_anim = "shoot_rifle"
  end
  enemy.name_movement = {
    "idle",
    "idle_laugh",
    "scare",
    "shoot",
    "move",
    "shoot",
    "shoot_rifle",
    "jump_knife",
    "move_scare",
    "death_knife",
    "death_rock",
    "brutal_death"
  }

  enemy.movement = {

    idle = {
      love.graphics.newQuad(412,8,24,39,imgX,imgY),
      love.graphics.newQuad(446,8,24,39,imgX,imgY),
      love.graphics.newQuad(481,8,24,39,imgX,imgY),
      love.graphics.newQuad(515,8,24,39,imgX,imgY),
      love.graphics.newQuad(551,8,24,39,imgX,imgY),
      love.graphics.newQuad(586,8,24,39,imgX,imgY),
      love.graphics.newQuad(620,8,24,39,imgX,imgY),
      love.graphics.newQuad(656,8,24,39,imgX,imgY)
    },

    idle_laugh = {
      love.graphics.newQuad(494,340,35,38,imgX,imgY),
      love.graphics.newQuad(537,341,33,37,imgX,imgY),
      love.graphics.newQuad(579,340,35,38,imgX,imgY),
      love.graphics.newQuad(623,341,33,37,imgX,imgY),
      love.graphics.newQuad(665,342,31,36,imgX,imgY),
      love.graphics.newQuad(704,341,33,37,imgX,imgY),
      love.graphics.newQuad(744,342,31,36,imgX,imgY),
      love.graphics.newQuad(785,343,29,35,imgX,imgY),
      love.graphics.newQuad(824,342,31,36,imgX,imgY),
      love.graphics.newQuad(866,343,29,35,imgX,imgY),
      love.graphics.newQuad(8  ,394,29,35,imgX,imgY),
      love.graphics.newQuad(46 ,393,31,36,imgX,imgY),
      love.graphics.newQuad(86 ,392,33,37,imgX,imgY)
    },

    scare = {
      love.graphics.newQuad(633,387,38,42,imgX,imgY),
      love.graphics.newQuad(679,387,39,41,imgX,imgY),
      love.graphics.newQuad(726,387,38,42,imgX,imgY),
      love.graphics.newQuad(771,387,38,42,imgX,imgY)

    },

    move_scare = {
      love.graphics.newQuad(8  ,341,30,37,imgX,imgY),
      love.graphics.newQuad(48 ,341,27,38,imgX,imgY),
      love.graphics.newQuad(85 ,341,30,39,imgX,imgY),
      love.graphics.newQuad(124,341,33,39,imgX,imgY),
      love.graphics.newQuad(167,341,33,38,imgX,imgY),
      love.graphics.newQuad(210,341,31,37,imgX,imgY),
      love.graphics.newQuad(251,341,30,37,imgX,imgY),
      love.graphics.newQuad(290,341,29,38,imgX,imgY),
      love.graphics.newQuad(329,341,30,39,imgX,imgY),
      love.graphics.newQuad(368,341,32,39,imgX,imgY),
      love.graphics.newQuad(411,341,32,38,imgX,imgY),
      love.graphics.newQuad(454,341,29,37,imgX,imgY)

    },

    shoot = {
      love.graphics.newQuad(269,57 ,24,44,imgX,imgY),
      love.graphics.newQuad(304,57 ,23,44,imgX,imgY),
      love.graphics.newQuad(341,57 ,24,44,imgX,imgY),
      love.graphics.newQuad(377,57 ,31,44,imgX,imgY),
      love.graphics.newQuad(417,57 ,38,44,imgX,imgY),
      love.graphics.newQuad(465,57 ,56,44,imgX,imgY),
      love.graphics.newQuad(530,57 ,56,44,imgX,imgY),
      love.graphics.newQuad(596,57 ,55,44,imgX,imgY),
      love.graphics.newQuad(663,57 ,56,44,imgX,imgY),

    },
    shoot_rifle = {
      love.graphics.newQuad(350,225,48,49,imgX,imgY),
      love.graphics.newQuad(426,225,46,49,imgX,imgY),
      love.graphics.newQuad(506,225,42,47,imgX,imgY),
      love.graphics.newQuad(591,225,41,47,imgX,imgY),
      love.graphics.newQuad(671,225,47,47,imgX,imgY),
      love.graphics.newQuad(742,225,46,47,imgX,imgY),
      love.graphics.newQuad(812,225,45,47,imgX,imgY),
      love.graphics.newQuad(881,225,45,47,imgX,imgY),
      love.graphics.newQuad(23 ,281,45,48,imgX,imgY),
      love.graphics.newQuad(88 ,281,48,48,imgX,imgY),
      love.graphics.newQuad(159,281,48,48,imgX,imgY),
      love.graphics.newQuad(229,281,47,48,imgX,imgY),
      love.graphics.newQuad(299,281,47,48,imgX,imgY),
      love.graphics.newQuad(366,281,48,48,imgX,imgY),
      --reload
      love.graphics.newQuad(424,281,46,48,imgX,imgY),
      love.graphics.newQuad(480,281,40,48,imgX,imgY),
      love.graphics.newQuad(529,281,40,48,imgX,imgY),
      love.graphics.newQuad(581,281,40,48,imgX,imgY),
      love.graphics.newQuad(632,281,40,48,imgX,imgY),
      love.graphics.newQuad(684,281,40,48,imgX,imgY),
      love.graphics.newQuad(735,281,40,48,imgX,imgY),
      love.graphics.newQuad(787,281,40,48,imgX,imgY),
    },

    death_knife = {
      love.graphics.newQuad(420,645,32,47,imgX,imgY),
      love.graphics.newQuad(459,645,36,47,imgX,imgY),
      love.graphics.newQuad(503,645,40,47,imgX,imgY),
      love.graphics.newQuad(551,645,43,47,imgX,imgY),
      love.graphics.newQuad(602,645,45,47,imgX,imgY),
      love.graphics.newQuad(655,645,47,47,imgX,imgY),
      love.graphics.newQuad(712,645,46,47,imgX,imgY),
      love.graphics.newQuad(770,645,47,47,imgX,imgY),
      love.graphics.newQuad(829,645,48,47,imgX,imgY),
      love.graphics.newQuad(11 ,702,48,47,imgX,imgY),
      love.graphics.newQuad(70 ,702,48,47,imgX,imgY),
      love.graphics.newQuad(132,702,46,47,imgX,imgY),
    },

    jump_knife = {
      love.graphics.newQuad(76 ,1692,26,42,imgAX,imgAY),
      love.graphics.newQuad(106,1692,27,43,imgAX,imgAY),
      love.graphics.newQuad(136,1692,33,42,imgAX,imgAY),
      love.graphics.newQuad(171,1692,35,42,imgAX,imgAY),
      love.graphics.newQuad(210,1692,27,40,imgAX,imgAY),
      love.graphics.newQuad(248,1692,36,38,imgAX,imgAY),
      love.graphics.newQuad(289,1692,38,42,imgAX,imgAY),
      love.graphics.newQuad(335,1692,46,42,imgAX,imgAY),
      love.graphics.newQuad(385,1692,44,48,imgAX,imgAY),
      love.graphics.newQuad(439,1692,44,48,imgAX,imgAY),
      love.graphics.newQuad(491,1692,47,48,imgAX,imgAY),
      love.graphics.newQuad(546,1692,48,48,imgAX,imgAY),
      love.graphics.newQuad(611,1692,49,48,imgAX,imgAY),
    },


    --must define reverse
    death_rock = {
      love.graphics.newQuad(8  ,490,38,40,imgX,imgY),
      love.graphics.newQuad(53 ,489,38,41,imgX,imgY),
      love.graphics.newQuad(96 ,489,38,39,imgX,imgY),
      love.graphics.newQuad(145,489,42,44,imgX,imgY),
      love.graphics.newQuad(199,489,39,42,imgX,imgY),
      love.graphics.newQuad(251,489,43,42,imgX,imgY),
      love.graphics.newQuad(304,489,44,42,imgX,imgY),
      love.graphics.newQuad(354,489,45,42,imgX,imgY),
      love.graphics.newQuad(406,489,46,42,imgX,imgY),
      love.graphics.newQuad(461,489,48,42,imgX,imgY),
      love.graphics.newQuad(514,489,48,42,imgX,imgY),
      love.graphics.newQuad(570,489,48,42,imgX,imgY),
      love.graphics.newQuad(627,489,48,42,imgX,imgY),
      love.graphics.newQuad(684,489,50,42,imgX,imgY),
      love.graphics.newQuad(740,489,50,42,imgX,imgY),
      love.graphics.newQuad(797,489,50,42,imgX,imgY),
      love.graphics.newQuad(853,489,48,42,imgX,imgY),

    },

    brutal_death = {

      love.graphics.newQuad(8  ,546,28,40,imgX,imgY),
      love.graphics.newQuad(46 ,546,29,41,imgX,imgY),
      love.graphics.newQuad(85 ,546,31,43,imgX,imgY),
      love.graphics.newQuad(126,546,34,42,imgX,imgY),
      love.graphics.newQuad(172,546,37,42,imgX,imgY),
      love.graphics.newQuad(220,546,42,44,imgX,imgY),
      love.graphics.newQuad(272,546,42,41,imgX,imgY),
      love.graphics.newQuad(325,546,47,42,imgX,imgY),
      love.graphics.newQuad(384,546,46,44,imgX,imgY),
      love.graphics.newQuad(441,546,47,45,imgX,imgY),
      love.graphics.newQuad(501,546,47,43,imgX,imgY),
      love.graphics.newQuad(560,546,47,40,imgX,imgY),
      love.graphics.newQuad(617,546,46,40,imgX,imgY),
      love.graphics.newQuad(675,546,46,40,imgX,imgY),
      love.graphics.newQuad(733,546,47,40,imgX,imgY)

    }
  }

  return enemy

end

function spawnenemy(enemies,width,player)

  local type = math.random(0,7)
  local x
  if (type == 3 or type == 4) and player.x < BackGround.endback[BackGround.index] then
    x = (player.x - width/4)
  elseif  player.x+width < BackGround.scale[BackGround.index] then
    x = width+player.x
  else
    --not insert enemy
    x = -1
  end

  if x ~= -1 then
    local enemy = loadenemy(x,type)
    table.insert(enemies,enemy)

  end
  enemies.spawntimer = 2

end

local function movenemy(enemy,dt)
  if enemy.curr_anim == "jump_knife" and enemy.curr_frame < 10 then
    enemy.x = enemy.x +enemy.speed*2.2*dt
  else
    enemy.x = enemy.x + enemy.speed*dt
  end
end




local function updateEnemybullets(bullets,dt)

  for i,v in ipairs(bullets) do
      v.x = v.x - v.speed*dt*v.rev
  end
  --remove bullets from table
  for i = #bullets,1,-1 do
    local v = bullets[i]
    if (v.x < camera.x -10) or (v.x > width + 5 + camera.x )
    or (v.y < -25 ) or (v.y > height + 25)then
      table.remove(bullets,i)
    end
  end

end

local function shootenemy(enemies,enemy,player,t)
  local y = ((player.crouch and enemy.curr_anim ~= "shoot_rifle") and 30 or 0)
  table.insert(enemies.bullets,{
    x = enemy.x - 50,
    y = enemy.y + y,
    w = 25,
    h = 15,
    rev = 1,--temporary
    speed = 450*t,
    type = t
  })

end



function updatenemy(enemies,width,player,dt)

  --loop for all enemies
  if enemies.edit == nil and not player.win then
    if enemies.spawntimer > 0 then
      enemies.spawntimer = enemies.spawntimer - dt
    else
      spawnenemy(enemies,width,player)

    end
  end

  for i,enemy in ipairs(enemies)do
      enemy.elapsedtime = enemy.elapsedtime + dt

      local out = enemy.movement[enemy.curr_anim][enemy.curr_frame]

      if enemy.elapsedtime > enemy.frame_duration then
        if out ==nil then enemy.curr_frame = 1 end
        --animation frame
        if enemy.curr_frame < #enemy.movement[enemy.curr_anim] then
          enemy.curr_frame = enemy.curr_frame + 1

          if enemy.curr_anim == "shoot" and enemy.curr_frame == 6 then
              shootenemy(enemies,enemy,player,1)

          elseif enemy.curr_anim =="shoot_rifle" and enemy.curr_frame == 2 then
              shootenemy(enemies,enemy,player,2)

          elseif enemy.curr_anim == "move_scare" or enemy.curr_anim == "jump_knife" then
              movenemy(enemy,dt)

          elseif enemy.curr_anim == "death_rock" and enemy.curr_frame < 5 then
              movenemy(enemy,dt)
          end
        else
          --end animation sprite loop or do function
          enemy.curr_frame = 1
          if enemy.curr_anim == "scare" then
            enemy.curr_anim = "move_scare"
            enemy.curr_frame = 1
          elseif enemy.dead then
            table.remove(enemies,i)
          end
        end
        enemy.elapsedtime = 0
      end

      if enemy.x > player.x + width and enemy.curr_anim =="move_scare" then
        table.remove(enemies,i)
      end
  end

  if #enemies.bullets > 0 then updateEnemybullets(enemies.bullets,dt) end
  --print(enemy.movement[enemy.curr_anim][enemy.curr_frame])

end



function Drawenemy(enemies)

  for i,enemysprite in ipairs(enemies)do
    --if not enemysprite.dead then
      --local r = (enemysprite.curr_anim == "shoot_rifle") and 20 or 0
      if enemysprite.curr_anim == "jump_knife" then
          local j = (enemysprite.curr_frame < 10) and 20 or 15
          love.graphics.draw(
              enemysprite.imgA,
              enemysprite.movement[enemysprite.curr_anim][enemysprite.curr_frame],
              enemysprite.x ,
              enemysprite.y -j,
              0,
              2,
              2
          )
      elseif enemysprite.curr_anim == "shoot_rifle" then
          love.graphics.draw(
              enemysprite.img,
              enemysprite.movement[enemysprite.curr_anim][enemysprite.curr_frame],
              enemysprite.x,
              enemysprite.y - 20,
              0,
              2,
              2
          )
      else
      local s = (enemysprite.curr_anim == "shoot") and 15 or 0
      local v = (enemysprite.curr_anim == "shoot" and enemysprite.curr_frame > 5) and 42 or 0
          love.graphics.draw(
              enemysprite.img,
              enemysprite.movement[enemysprite.curr_anim][enemysprite.curr_frame],
              enemysprite.x -v,
              enemysprite.y -s,
              0,
              2,
              2
          )
      end
  end

  if #enemies.bullets > 0 then
    DrawBulletEnemy(enemies.bullets)
  end
end

function DrawBulletEnemy(bullets)
  for i,b in ipairs(bullets)do
    if b.type == 1 then
      love.graphics.draw(
          imgBenemy,
          BigBulletEnemy,
          b.x - 20,
          b.y - 15,
          0,
          2,
          2
      )
    else
      love.graphics.draw(
          imgBenemy,
          RifleBulletEnemy,
          b.x,
          b.y + 10,
          0,
          2,
          2
      )
    end
  end

end
