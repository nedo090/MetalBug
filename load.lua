require "cameram"


Background = {}
BackgroundImage = {}
BindKey = {}

function LoadBackground()

    BackgroundImage[1] = "Middleson1999.png"
    BackgroundImage[2] = "backgroundPlayer2.png"
    BackgroundImage[3] = "hong_kong.png"
    BackgroundImage[4] = "Metal_slug_mission_4.png"
    BackgroundImage[5] = "Gerhardt_City_Road.png"
    BackgroundImage[6] = "Gerhardt_City_Residential_Area.png"

    Background[1] = love.graphics.newImage(BackgroundImage[1])
    Background[2] = love.graphics.newImage(BackgroundImage[2])
    Background[3] = love.graphics.newImage(BackgroundImage[3])
    Background[4] = love.graphics.newImage(BackgroundImage[4])
    Background[5] = love.graphics.newImage(BackgroundImage[5])
    Background[6] = love.graphics.newImage(BackgroundImage[6])

end

function loadworld()

    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    titlefont = love.graphics.newFont("fonts/horrendous/horrendo.ttf", 100)
    menufont = love.graphics.newFont("fonts/Army/Army_Expanded.ttf",50)
    CreditFont = love.graphics.newFont("fonts/Army/Army_Expanded.ttf", 22)
    CreditFontBack = love.graphics.newFont("fonts/Army/Army_Expanded.ttf", 23)

    imagenemy = love.graphics.newImage("enemy.png")
    imgAenemy = love.graphics.newImage("Enemy_sheet.png")

    imgX,imgY = imagenemy:getDimensions()
    imgAX,imgAY = imgAenemy:getDimensions()
    winsound = love.audio.newSource("metal-slug-mission-complete.mp3","static")
    deathsound = love.audio.newSource("Game-Over.mp3", "static")

    --structure for key keybinding
    BindKey["w"] = "w"
    BindKey["s"] = "s"
    BindKey["a"] = "a"
    BindKey["d"] = "d"
    BindKey["j"] = "j"
    BindKey["k"] = "k"
    BindKey["l"] = "l"

    BindKey.click = 0


    LoadBackground()

end

--function for control keyboard
love.keyboard.keyspressed  = {}
love.keyboard.keysreleased = {}

--avoid continuos pressing
function love.keyboard.waspressed(key)

      if (love.keyboard.keyspressed[key]) then
          return true
        else
          return false
      end
end

--not using must update key pressed
function love.keyboard.updateKeys()

    love.keyboard.keysreleased = {}
    love.keyboard.keyspressed  = {}
end
