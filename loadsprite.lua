
function loadplayer()
  --load image sprite and see if null abort not such file
  local image = love.graphics.newImage("Marco.png")
  if image == nil then return nil end

  local img_div = love.graphics.newImage("marcospritesheetdiv.png")
  if img_div == nil then return nil end


  local sasso = love.graphics.newImage("rock.png")

  local img_divX,img_divY = img_div:getDimensions()
  local imgX,imgY = image:getDimensions()


  local player = {}
  player.img = image

  player.img_div = img_div
  player.grenate = sasso
  player.bullet  = love.graphics.newQuad(502, 801 , 10, 6, imgX, imgY)
  player.bulletup = love.graphics.newQuad(345, 891, 6, 10, imgX, imgY)



  --setting attribute for the player
  player.y       = 460
  player.x       = 100
  player.w       = 30
  player.h       = 60
  player.reverse = 1
  player.run     = false
  player.shoot   = false
  player.throw   = false
  player.dead    = false
  player.up      = false
  player.crouch  = false
  player.speed   = 300
  player.speedcrouch = 100
  player.ground  = 460
  player.y_speed = 0
  player.jumph   = -400
  player.gravity = -700


  player.bombs = {}
  player.bullets = {}


  player.frame_duration = 0.08


  player.name_movement = {
    "idle_leg",
    "idle_body",
    "body_up",
    "idle_leg_up",
    "move_body",
    "move_leg",
    "move_crouch",
    "shoot",
    "shoot_up",
    "shoot_move",
    "shoot_crouch",
    "jump_body",
    "jump_leg",
    "idle_crouch",
    "throw",
    "throw_crouch",
    "machine_gun_idle",
    "machine_gun_up",
    "machine_gun_up_shoot",
    "machine_gun_move",
    "machine_gun_shoot",
    "machine_gun_shoot_crouch",
    "death_rolling",
    "death_burn",
    "death_knife",
    "win"

  }

  player.movement = {

    --sprite for stanby
    idle_leg  = {

      --love.graphics.newQuad(167, 1511, 21, 16, img_divX,img_divY),
      --love.graphics.newQuad(191, 1511, 21, 16, img_divX,img_divY),
      love.graphics.newQuad(215, 1511, 21, 16, img_divX, img_divY)
      --love.graphics.newQuad(239, 1511, 21, 16, img_divX,img_divY)

    },
    --sprite for look up for leg
    idle_leg_up = {

      love.graphics.newQuad(705,1509,21, 18, img_divX, img_divY)

    },
    --sprite for stanby back
    idle_body = {
      [1] = love.graphics.newQuad(19 , 18, 30, 29, img_divX, img_divY),
      [2] = love.graphics.newQuad(52 , 18, 30, 29, img_divX, img_divY),
      [3] = love.graphics.newQuad(85 , 18, 30, 29, img_divX, img_divY),
      [4] = love.graphics.newQuad(119, 19, 31, 27, img_divX, img_divY),

    },
    --same size of move_body for if look up when run go out of table
    body_up = {

      love.graphics.newQuad(22 , 67, 29, 26, img_divX, img_divY),
      love.graphics.newQuad(55 , 67, 29, 26, img_divX, img_divY),
      love.graphics.newQuad(88 , 67, 29, 26, img_divX, img_divY),
      love.graphics.newQuad(121, 67, 29, 26, img_divX, img_divY),
      love.graphics.newQuad(121, 67, 29, 26, img_divX, img_divY),
      love.graphics.newQuad(88 , 67, 29, 26, img_divX, img_divY),
      love.graphics.newQuad(55 , 67, 29, 26, img_divX, img_divY),
      love.graphics.newQuad(22 , 67, 29, 26, img_divX, img_divY),
      love.graphics.newQuad(22 , 67, 29, 26, img_divX, img_divY),
      love.graphics.newQuad(55 , 67, 29, 26, img_divX, img_divY),
      love.graphics.newQuad(88 , 67, 29, 26, img_divX, img_divY),
      love.graphics.newQuad(121, 67, 29, 26, img_divX, img_divY),
      love.graphics.newQuad(22 , 67, 29, 26, img_divX, img_divY),
    },

    --sprite body for running without shooting
    move_body = {

      love.graphics.newQuad(20 , 159, 32, 29, img_divX, img_divY),
      love.graphics.newQuad(54 , 159, 30, 29, img_divX, img_divY),
      love.graphics.newQuad(86 , 159, 29, 28, img_divX, img_divY),
      love.graphics.newQuad(116, 159, 29, 27, img_divX, img_divY),
      love.graphics.newQuad(146, 159, 29, 28, img_divX, img_divY),
      love.graphics.newQuad(178, 159, 30, 28, img_divX, img_divY),
      love.graphics.newQuad(211, 159, 32, 30, img_divX, img_divY),
      love.graphics.newQuad(246, 159, 32, 30, img_divX, img_divY),
      love.graphics.newQuad(281, 159, 32, 29, img_divX, img_divY),
      love.graphics.newQuad(315, 159, 31, 27, img_divX, img_divY),
      love.graphics.newQuad(349, 159, 31, 28, img_divX, img_divY),
      love.graphics.newQuad(383, 159, 31, 28, img_divX, img_divY),
      love.graphics.newQuad(349, 159, 31, 28, img_divX, img_divY),

    },

    --sprite for shoting
    shoot = {

      love.graphics.newQuad(234, 18, 50, 23, img_divX, img_divY),
      love.graphics.newQuad(288, 18, 51, 23, img_divX, img_divY),
      love.graphics.newQuad(343, 18, 52, 23, img_divX, img_divY),
      love.graphics.newQuad(400, 18, 37, 23, img_divX, img_divY),
      love.graphics.newQuad(443, 18, 37, 25, img_divX, img_divY),
      love.graphics.newQuad(485, 18, 37, 25, img_divX, img_divY),
      love.graphics.newQuad(526, 18, 37, 23, img_divX, img_divY),
      love.graphics.newQuad(567, 18, 34, 26, img_divX, img_divY),
      love.graphics.newQuad(605, 18, 33, 27, img_divX, img_divY),
      love.graphics.newQuad(642, 18, 32, 27, img_divX, img_divY),

    },

    shoot_move = {

      love.graphics.newQuad(684, 18, 48, 23, img_divX, img_divY),
      love.graphics.newQuad(736, 18, 50, 23, img_divX, img_divY),
      love.graphics.newQuad(790, 18, 50, 23, img_divX, img_divY),
      love.graphics.newQuad(843, 18, 35, 23, img_divX, img_divY),
      love.graphics.newQuad(881, 18, 36, 23, img_divX, img_divY),
      love.graphics.newQuad(920, 18, 37, 25, img_divX, img_divY),
      love.graphics.newQuad(960, 18, 37, 23, img_divX, img_divY),
      love.graphics.newQuad(1000,18, 34, 25, img_divX, img_divY),
      love.graphics.newQuad(1037,18, 33, 27, img_divX, img_divY),
      love.graphics.newQuad(1073,18, 32, 27, img_divX, img_divY),

    },

    --shoot while look up
    shoot_up = {

      love.graphics.newQuad(154, 29, 22, 64, img_divX, img_divY),
      love.graphics.newQuad(180, 29, 22, 64, img_divX, img_divY),
      love.graphics.newQuad(206, 29, 22, 66, img_divX, img_divY),
      love.graphics.newQuad(232, 54, 22, 39, img_divX, img_divY),
      love.graphics.newQuad(258, 55, 25, 38, img_divX, img_divY),
      love.graphics.newQuad(287, 53, 25, 40, img_divX, img_divY),
      love.graphics.newQuad(315, 52, 24, 41, img_divX, img_divY),
      love.graphics.newQuad(343, 53, 26, 40, img_divX, img_divY),
      love.graphics.newQuad(372, 56, 26, 37, img_divX, img_divY),
      --love.graphics.newQuad(401, 66, 29, 27, img_divX, img_divY)
    },

    jump_body = {

      love.graphics.newQuad(565, 156, 29, 27, img_divX, img_divY),
      love.graphics.newQuad(597, 156, 29, 26, img_divX, img_divY),
      love.graphics.newQuad(629, 157, 29, 25, img_divX, img_divY),
      love.graphics.newQuad(661, 158, 29, 24, img_divX, img_divY),
      love.graphics.newQuad(694, 155, 29, 22, img_divX, img_divY),
      love.graphics.newQuad(726, 158, 29, 24, img_divX, img_divY),
      love.graphics.newQuad(694, 155, 29, 22, img_divX, img_divY),
      love.graphics.newQuad(661, 158, 29, 24, img_divX, img_divY),
      love.graphics.newQuad(629, 157, 29, 25, img_divX, img_divY),
      love.graphics.newQuad(597, 156, 29, 26, img_divX, img_divY),
      love.graphics.newQuad(565, 156, 29, 27, img_divX, img_divY),

    },

    jump_leg = {

      love.graphics.newQuad(792, 1502, 18, 25, img_divX, img_divY),
      love.graphics.newQuad(813, 1502, 19, 25, img_divX, img_divY),
      love.graphics.newQuad(835, 1502, 20, 25, img_divX, img_divY),
      love.graphics.newQuad(858, 1502, 20, 23, img_divX, img_divY),
      love.graphics.newQuad(881, 1502, 21, 20, img_divX, img_divY),
      love.graphics.newQuad(905, 1502, 21, 20, img_divX, img_divY),
      love.graphics.newQuad(905, 1502, 21, 20, img_divX, img_divY),
      love.graphics.newQuad(881, 1502, 21, 20, img_divX, img_divY),
      love.graphics.newQuad(858, 1502, 20, 23, img_divX, img_divY),
      love.graphics.newQuad(835, 1502, 20, 25, img_divX, img_divY),
      love.graphics.newQuad(813, 1502, 19, 25, img_divX, img_divY),
      love.graphics.newQuad(792, 1502, 18, 25, img_divX, img_divY),
    },

    throw = {

      love.graphics.newQuad(1083, 63, 31, 29, img_divX,img_divY),
      love.graphics.newQuad(1117, 63, 33, 29, img_divX,img_divY),
      love.graphics.newQuad(1153, 63, 31, 30, img_divX,img_divY),
      love.graphics.newQuad(1188, 63, 31, 28, img_divX,img_divY),
      love.graphics.newQuad(1222, 63, 31, 28, img_divX,img_divY),
      love.graphics.newQuad(1222, 63, 31, 28, img_divX,img_divY),

    },

    move_leg = {

      love.graphics.newQuad(267, 1507, 21, 20, img_divX, img_divY),
      love.graphics.newQuad(291, 1507, 28, 20, img_divX, img_divY),
      love.graphics.newQuad(322, 1507, 31, 20, img_divX, img_divY),
      love.graphics.newQuad(356, 1507, 19, 20, img_divX, img_divY),
      love.graphics.newQuad(378, 1507, 15, 20, img_divX, img_divY),
      love.graphics.newQuad(396, 1507, 16, 20, img_divX, img_divY),
      love.graphics.newQuad(415, 1507, 21, 20, img_divX, img_divY),
      love.graphics.newQuad(439, 1507, 26, 20, img_divX, img_divY),
      love.graphics.newQuad(468, 1507, 31, 20, img_divX, img_divY),
      love.graphics.newQuad(502, 1507, 20, 20, img_divX, img_divY),
      love.graphics.newQuad(524, 1507, 15, 20, img_divX, img_divY),
      love.graphics.newQuad(541, 1507, 18, 20, img_divX, img_divY),

    },

    --movement for crouch
    move_crouch = {

      love.graphics.newQuad(533, 255, 34, 24, img_divX, img_divY),
      love.graphics.newQuad(570, 255, 34, 24, img_divX, img_divY),
      love.graphics.newQuad(606, 255, 34, 24, img_divX, img_divY),
      love.graphics.newQuad(642, 255, 34, 24, img_divX, img_divY),
      love.graphics.newQuad(678, 255, 34, 24, img_divX, img_divY),
      love.graphics.newQuad(715, 255, 34, 24, img_divX, img_divY),
      love.graphics.newQuad(752, 255, 34, 24, img_divX, img_divY),
      love.graphics.newQuad(789, 255, 34, 24, img_divX, img_divY),
      love.graphics.newQuad(826, 255, 34, 24, img_divX, img_divY),
      love.graphics.newQuad(864, 255, 34, 24, img_divX, img_divY),
      love.graphics.newQuad(902, 255, 34, 24, img_divX, img_divY),

    },

    idle_crouch = {

      love.graphics.newQuad(292, 240, 29, 39, img_divX, img_divY),
      love.graphics.newQuad(325, 240, 29, 41, img_divX, img_divY),
      love.graphics.newQuad(358, 240, 29, 38, img_divX, img_divY),
      love.graphics.newQuad(391, 253, 32, 26, img_divX, img_divY),
      love.graphics.newQuad(426, 253, 32, 26, img_divX, img_divY),
      love.graphics.newQuad(461, 253, 31, 26, img_divX, img_divY),
      love.graphics.newQuad(495, 253, 32, 26, img_divX, img_divY),
      love.graphics.newQuad(495, 253, 32, 26, img_divX, img_divY),
      love.graphics.newQuad(461, 253, 31, 26, img_divX, img_divY),

    },

    throw_crouch = {

      --love.graphics.newQuad(179, 332, 32, 33, img_divX, img_divY),
      love.graphics.newQuad(217, 339, 33, 26, img_divX, img_divY),
      love.graphics.newQuad(253, 339, 28, 26, img_divX, img_divY),
      love.graphics.newQuad(284, 339, 31, 26, img_divX, img_divY),
      love.graphics.newQuad(318, 337, 41, 28, img_divX, img_divY),
      love.graphics.newQuad(362, 339, 38, 26, img_divX, img_divY),
      love.graphics.newQuad(402, 339, 36, 26, img_divX, img_divY),
    },

    shoot_crouch  = {

      --love.graphics.newQuad(647, 292, 38, 27, img_divX, img_divY),
      love.graphics.newQuad(690, 292, 50, 28, img_divX, img_divY),
      love.graphics.newQuad(743, 292, 51, 28, img_divX, img_divY),
      love.graphics.newQuad(797, 292, 52, 28, img_divX, img_divY),
      love.graphics.newQuad(852, 292, 37, 28, img_divX, img_divY),
      love.graphics.newQuad(892, 292, 37, 30, img_divX, img_divY),
      love.graphics.newQuad(932, 292, 37, 30, img_divX, img_divY),
      love.graphics.newQuad(972, 292, 37, 28, img_divX, img_divY),
      love.graphics.newQuad(1012, 292, 34, 28,img_divX, img_divY),
      love.graphics.newQuad(1012, 292, 34, 28,img_divX, img_divY),

    },

    death_rolling = {



      love.graphics.newQuad(229, 2992, 27, 37, img_divX, img_divY),
      love.graphics.newQuad(259, 2992, 31, 37, img_divX, img_divY),
      love.graphics.newQuad(294, 2992, 32, 38, img_divX, img_divY),
      love.graphics.newQuad(329, 2992, 42, 37, img_divX, img_divY),
      love.graphics.newQuad(374, 2992, 47, 39, img_divX, img_divY),
      love.graphics.newQuad(423, 2992, 48, 37, img_divX, img_divY),
      love.graphics.newQuad(474, 3003, 47, 26, img_divX, img_divY),
      love.graphics.newQuad(525, 3002, 48, 28, img_divX, img_divY),
      love.graphics.newQuad(576, 2997, 42, 32, img_divX, img_divY),
      love.graphics.newQuad(621, 2989, 32, 40, img_divX, img_divY),
      love.graphics.newQuad(656, 2992, 31, 37, img_divX, img_divY),
      love.graphics.newQuad(690, 2997, 38, 32, img_divX, img_divY),
      love.graphics.newQuad(731, 3002, 48, 27, img_divX, img_divY),
      love.graphics.newQuad(782, 3001, 45, 28, img_divX, img_divY),
      love.graphics.newQuad(830, 2990, 47, 39, img_divX, img_divY),
      love.graphics.newQuad(880, 2990, 44, 39, img_divX, img_divY),
      love.graphics.newQuad(927, 2990, 45, 37, img_divX, img_divY),
      love.graphics.newQuad(975, 2990, 48, 39, img_divX, img_divY),
      love.graphics.newQuad(1026, 2990, 49, 39, img_divX, img_divY),

    },
    death_knife = {
      love.graphics.newQuad(115,3040,28,40,img_divX,img_divY),
      love.graphics.newQuad(146,3040,31,40,img_divX,img_divY),
      love.graphics.newQuad(180,3040,31,40,img_divX,img_divY),
      love.graphics.newQuad(214,3040,30,40,img_divX,img_divY),
      love.graphics.newQuad(248,3040,31,40,img_divX,img_divY),
      love.graphics.newQuad(282,3040,32,40,img_divX,img_divY),
      love.graphics.newQuad(316,3040,32,40,img_divX,img_divY),
      love.graphics.newQuad(350,3040,29,40,img_divX,img_divY),
      love.graphics.newQuad(381,3040,28,40,img_divX,img_divY),
      love.graphics.newQuad(411,3040,27,40,img_divX,img_divY),
      love.graphics.newQuad(441,3040,28,40,img_divX,img_divY),
      love.graphics.newQuad(469,3040,24,40,img_divX,img_divY),
      love.graphics.newQuad(497,3040,21,40,img_divX,img_divY),
      love.graphics.newQuad(521,3040,22,40,img_divX,img_divY),
      love.graphics.newQuad(547,3040,23,40,img_divX,img_divY),
      love.graphics.newQuad(573,3040,27,40,img_divX,img_divY),
      love.graphics.newQuad(603,3040,30,40,img_divX,img_divY),
      love.graphics.newQuad(636,3040,34,40,img_divX,img_divY),
      love.graphics.newQuad(673,3040,38,40,img_divX,img_divY),
    },

    death_burn = {

      love.graphics.newQuad(15 ,3239,44,55,img_divX,img_divY),
      love.graphics.newQuad(62 ,3239,47,55,img_divX,img_divY),
      love.graphics.newQuad(112,3239,54,60,img_divX,img_divY),
      love.graphics.newQuad(169,3239,54,58,img_divX,img_divY),
      love.graphics.newQuad(227,3239,50,59,img_divX,img_divY),
      love.graphics.newQuad(281,3239,53,55,img_divX,img_divY),
      love.graphics.newQuad(340,3239,57,60,img_divX,img_divY),
      love.graphics.newQuad(402,3239,58,58,img_divX,img_divY),
      love.graphics.newQuad(465,3239,54,59,img_divX,img_divY),
      love.graphics.newQuad(524,3239,56,59,img_divX,img_divY),
      love.graphics.newQuad(584,3239,58,60,img_divX,img_divY),
      love.graphics.newQuad(646,3239,58,58,img_divX,img_divY),
      love.graphics.newQuad(708,3239,58,59,img_divX,img_divY),
      love.graphics.newQuad(771,3239,54,59,img_divX,img_divY),
      love.graphics.newQuad(829,3239,55,59,img_divX,img_divY),
      love.graphics.newQuad(888,3239,57,59,img_divX,img_divY),
      love.graphics.newQuad(949,3239,57,58,img_divX,img_divY),
      love.graphics.newQuad(15,3239,44,59,img_divX,img_divY),
      love.graphics.newQuad(1011,3239,59,57,img_divX,img_divY),
      love.graphics.newQuad(1074,3239,56,59,img_divX,img_divY),
      love.graphics.newQuad(1134,3239,60,60,img_divX,img_divY),
      love.graphics.newQuad(1199,3239,44,59,img_divX,img_divY),
      love.graphics.newQuad(290,3304,57,58,img_divX,img_divY),
      love.graphics.newQuad(352,3304,59,61,img_divX,img_divY),
      love.graphics.newQuad(415,3304,60,59,img_divX,img_divY),
      love.graphics.newQuad(479,3304,60,59,img_divX,img_divY),
      love.graphics.newQuad(544,3304,59,61,img_divX,img_divY),
      love.graphics.newQuad(604,3304,55,59,img_divX,img_divY),
      love.graphics.newQuad(665,3304,57,59,img_divX,img_divY),
      love.graphics.newQuad(727,3304,59,40,img_divX,img_divY),

    },

    win = {
      love.graphics.newQuad(1038,1385,47,44,img_divX,img_divY),
      love.graphics.newQuad(1089,1385,45,44,img_divX,img_divY),
      love.graphics.newQuad(1138,1385,43,44,img_divX,img_divY),
      love.graphics.newQuad(1185,1385,43,44,img_divX,img_divY),
    }


  }

  return player
end
