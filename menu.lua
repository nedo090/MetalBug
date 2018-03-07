require "load"
require "cameram"

menu = {}
menu.loadplayer = 0

--animated image for menu background
function menu.load()

background1 = love.graphics.newImage("scrollbackground.png")
background2 = love.graphics.newImage("scrollbackground.png")

positiontitleY,positiontitleX= titlefont:getHeight() , width/2 - titlefont:getWidth("Metal Bug")/2

--width of the button
widthButton = {}
heightOptionFont = menufont:getHeight()
--button play, Option, editor and quit
widthButton.Play,widthButton.Quit = menufont:getWidth("Play"),menufont:getWidth("Quit")
widthButton.Options,widthButton.editor = menufont:getWidth("Options"),menufont:getWidth("Editor")

--TODO make instruction menu

positionPlayY,positionPlayX = positiontitleY + titlefont:getHeight()+20,width/2 - widthButton["Play"]/2
positionEditorY,positionEditorX = positionPlayY + heightOptionFont+20,width/2 - widthButton["editor"]/2
positionOptionsY,positionOptionsX = positionEditorY + heightOptionFont+20,width/2 - widthButton["Options"]/2
positionQuitY,positionQuitX = positionOptionsY + heightOptionFont+20,width/2 - widthButton["Quit"]/2

--option
widthButton.Controls = menufont:getWidth("Controls")
widthButton.Credit = menufont:getWidth("Credit")
widthButton.Back = menufont:getWidth("Back")
--option editor
widthButton.Dimension = menufont:getWidth("Dimension")
widthButton.Background = menufont:getWidth("Background")
--widthButton.x500   = menufont:getWidth("500x224")
widthButton.x918   = menufont:getWidth("900x224")
widthButton.x1247  = menufont:getWidth("1247x224")
widthButton.x1602  = menufont:getWidth("1602x224")
widthButton.x2000  = menufont:getWidth("2000x224")
widthButton.x2568  = menufont:getWidth("2568x224")
widthButton.W      = menufont:getWidth("w")
widthButton.S      = menufont:getWidth("s")
widthButton.A      = menufont:getWidth("a")
widthButton.D      = menufont:getWidth("d")
widthButton.J      = menufont:getWidth("j")
widthButton.K      = menufont:getWidth("k")
widthButton.L      = menufont:getWidth("l")


positionControlsY,positionControlsX = positiontitleY + titlefont:getHeight()+20,width/2 - widthButton["Controls"]/2
positionCreditY,positionCreditX = positionControlsY+heightOptionFont+20,width/2 - widthButton["Credit"]/2
positionBackY,positionBackX = positionCreditY + heightOptionFont+20,width/2 - widthButton["Back"]/2

positionBackgroundY,positionBackgroundX = positiontitleY + titlefont:getHeight()+20,width/2 - widthButton["Background"]/2

positionDimensionY,positionDimensionX = positiontitleY + titlefont:getHeight()+20,width/2 - widthButton["Dimension"]/2
--position of the dimension
--position500x224Y,position500x224X   = positionDimensionY + heightOptionFont+10,width/2 - widthButton.x500/2
position918x224Y,position918x224X   = positionDimensionY  + heightOptionFont+10,width/2  - widthButton.x918/2
position1247x224Y,position1247x224X = position918x224Y  + heightOptionFont+10,width/2  - widthButton.x1247/2
position1602x224Y,position1602x224X = position1247x224Y + heightOptionFont+10,width/2  - widthButton.x1602/2
position2000x224Y,position2000x224X = position1602x224Y + heightOptionFont+10,width/2  - widthButton.x2000/2
position2568x224Y,position2568x224X = position2000x224Y + heightOptionFont+10,width/2  - widthButton.x2568/2

--see when finish the image
backgroundend = background1:getWidth()
scrollX = 0
scrollX1 = backgroundend
nextimg = 0

--thumbnail for the Editor
Background.quad1 = love.graphics.newQuad(0,0,500,224,Background[1]:getDimensions())
Background.quad2 = love.graphics.newQuad(0,0,500,224,Background[2]:getDimensions())
Background.quad3 = love.graphics.newQuad(0,0,500,224,Background[3]:getDimensions())
Background.quad4 = love.graphics.newQuad(0,0,500,224,Background[4]:getDimensions())
Background.quad5 = love.graphics.newQuad(0,0,500,224,Background[5]:getDimensions())
Background.quad6 = love.graphics.newQuad(0,0,500,224,Background[6]:getDimensions())


Background.quad1Y,Background.quad1X = positiontitleY + titlefont:getHeight()+10,width/2 - 300
Background.quad2Y,Background.quad2X = Background.quad1Y + 120,width/2 - 300
Background.quad3Y,Background.quad3X = Background.quad2Y + 120,width/2 - 300
Background.quad4Y,Background.quad4X = positiontitleY + titlefont:getHeight()+10,width/2
Background.quad5Y,Background.quad5X = Background.quad4Y + 120,width/2
Background.quad6Y,Background.quad6X = Background.quad5Y + 120,width/2



camera:newLayer(0.9,backgroundraw)
camera:newLayer(1,menu.draw)

end

--add event resize
function menu.resize(w,h)

  positiontitleX   = w/2 - titlefont:getWidth("Metal Bug")/2
  positionPlayX    = w/2 - widthButton["Play"]/2
  positionEditorX  = w/2 - widthButton["editor"]/2
  positionOptionsX = w/2 - widthButton["Options"]/2
  positionBackgroundX = w/2 - widthButton["Background"]/2
  positionDimensionX = w/2 - widthButton["Dimension"]/2
  positionCreditX    = w/2 - widthButton["Credit"]/2
  positionBackX    = w/2 - widthButton["Back"]/2
  positionQuitX    = w/2 - widthButton["Quit"]/2


  Background.quad1X = w/2 - 300
  Background.quad2X = w/2 - 300
  Background.quad3X = w/2 - 300
  Background.quad4X = w/2
  Background.quad5X = w/2
  Background.quad6X = w/2

end

local function movebackground()

  --move backgroundcondition use dt instead of int
  scrollX = scrollX - 1/2
  scrollX1 = scrollX1 - 1/2
  --transition 2 image to draw
  if scrollX   < -backgroundend then
    nextimg = 1
    scrollX = backgroundend
    scrollX1 =  0
  elseif scrollX1  < -backgroundend  then
    nextimg = 0
    scrollX1 = backgroundend
    scrollX = 0
  else
    nextimg = 0
  end

end

--update
function menu.update(dt)

  --variable scale calculate width only one time
  movebackground()

end

local released = false
function menu.mousereleased(x, y, button)
  if button == 1 then
    released = true
  end
end

--check if optionmode or menumode or else
--draw all option on screen

--see when mouse is over option for change color
function overbutton(text,x,y)
  local mouseX,mouseY = love.mouse.getPosition()
  if mouseX >= x and mouseX <= x+widthButton[text] and mouseY >= y and mouseY <= y+heightOptionFont then
    return true
  else
    return false
  end
end

local function overimage(x,y)
  local mouseX,mouseY = love.mouse.getPosition()

  if mouseX >= x and mouseX <= x+250 and mouseY >= y and mouseY <= y+112 then
    love.graphics.setColor(222, 255, 0)
    love.graphics.rectangle("line", x, y, 250, 112)
    love.graphics.setColor(255, 255, 255)
    return true
  else
    love.graphics.setColor(255, 255, 255)
    return false
  end

end

--draw button on screen
local function button(text,i,x,y)

  local inside = false
  --check if pointer is over the button
  if overbutton(i,x,y) then

    love.graphics.setColor(0,0,0,255)
    inside = true
  else
    love.graphics.setColor(255,255,255,255)

  end

  love.graphics.setFont(menufont)
  love.graphics.print(text,x,y)

  --if click the button return true
  return inside and released

end

function backgroundraw()

  love.graphics.setColor(255, 255, 255 )
  if nextimg == 1 then
    love.graphics.draw(background2,scrollX1,30,0,1,2)
  elseif nextimg == 2 then
    love.graphics.draw(background1,scrollX,30,0,1,2)
  else
    love.graphics.draw(background1,scrollX,30,0,1,2)
    love.graphics.draw(background2,scrollX1,30,0,1,2)
  end

end

--add function for draw option and editor
--remove layer menu.draw and add layer of drawing editor or option
local function playbutton()

    StateGame = player
    if menu.loadplayer == 0 then
      print("loading...player")
      menu.loadplayer = 1
      StateGame.load(nil,nil)
    else
      camera:ToGame()
    end

end

local function DrawCredit()


  love.graphics.setFont(CreditFont)
  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.rectangle("fill", 8, 100, 190, 15)
  love.graphics.rectangle("fill", 8, 150, 550, 15)
  love.graphics.rectangle("fill", 8, 200, 920, 15)
  love.graphics.rectangle("fill", 8, 250, 850, 15)
  love.graphics.rectangle("fill", 8, 300, 660, 15)
  love.graphics.rectangle("fill", 8, 350, 510, 15)

  love.graphics.setColor(255, 0, 0, 255)
  love.graphics.print("Thanks To:",10,100 )
  love.graphics.print("MAD SOLDIER:enemy spridesheet",10,150)
  love.graphics.print("Kevin Huff(keeavin@yahoo.com):marco spritesheet",10,200 )
  love.graphics.print("Alessio Vanni:sprite of rock and another stuff",10,250)
  love.graphics.print("Elia Ruggeri:Highlighted the errors",10,300 )
  love.graphics.print("Ivan Carosi:He knows french",10,350 )

  if button("Back","Back",positionBackX,500) then
    camera:removeLayer(DrawCredit)
    camera:newLayer(1,DrawOptionbutton)
  end

  released = false
end


local function isclicked(text,i,x,y)

  if text == "w" and overbutton(i,x,y) and released then
    BindKey.click = 1
  elseif text == "s" and overbutton(i,x,y) and released then
    BindKey.click = 2
  elseif text == "a" and overbutton(i,x,y) and released then
    BindKey.click = 3
  elseif text == "d" and overbutton(i,x,y) and released then
    BindKey.click = 4
  elseif text == "j" and overbutton(i,x,y) and released then
    BindKey.click = 5
  elseif text == "k" and overbutton(i,x,y) and released then
    BindKey.click = 6
  elseif text == "l" and overbutton(i,x,y) and released then
    BindKey.click = 7
  end

  if BindKey.click ~= 0 then
    if BindKey.click == 1 and text == "w" then
      love.graphics.setColor(255,255,255,255)
      love.graphics.print(BindKey[text],x,y)
    elseif BindKey.click == 2 and text == "s" then
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.print(BindKey[text],x,y)
    elseif BindKey.click == 3 and text == "a" then
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.print(BindKey[text],x,y)
    elseif BindKey.click == 4 and text == "d" then
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.print(BindKey[text],x,y)
    elseif BindKey.click == 5 and text == "j" then
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.print(BindKey[text],x,y)
    elseif BindKey.click == 6 and text == "k" then
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.print(BindKey[text],x,y)
    elseif BindKey.click == 7 and text == "l" then
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.print(BindKey[text],x,y)
    end
  else
    love.graphics.print(BindKey[text],x,y)
  end

    love.graphics.setColor(0,0,0,255)
end


function menu.keyreleased(key)

  if BindKey.click == 1 then
    BindKey["w"] = key
  elseif BindKey.click == 2 then
    BindKey["s"] = key
  elseif BindKey.click == 3 then
    BindKey["a"] = key
  elseif BindKey.click == 4 then
    BindKey["d"] = key
  elseif BindKey.click == 5 then
    BindKey["j"] = key
  elseif BindKey.click == 6 then
    BindKey["k"] = key
  elseif BindKey.click == 7 then
    BindKey["l"] = key
  end
    BindKey.click = 0
end

local function DrawControls()


  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.print("lookup:",50,100 )
  isclicked("w","W",600,100)

  love.graphics.print("move left:",50,150 )
  isclicked("a","A",600,150 )

  love.graphics.print("move right:",50,200)
  isclicked("d","D",600,200)

  love.graphics.print("crouch:",50,250)
  isclicked("s","S",600,250)

  love.graphics.print("shoot:",50,300 )
  isclicked("j","J",600,300 )

  love.graphics.print("jump:",50,350 )
  isclicked("k","K",600,350 )

  love.graphics.print("throw rock:",50,400 )
  isclicked("l","L",600,400 )

  if button("Back","Back",positionBackX,500) then
    camera:removeLayer(DrawControls)
    camera:newLayer(1,DrawOptionbutton)
  end
  released = false
end

function DrawOptionbutton()

  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.setFont(titlefont)
  love.graphics.print("Metal Bug",positiontitleX,positiontitleY)


  if button("Controls","Controls",positionControlsX,positionControlsY)then
    camera:removeLayer(DrawOptionbutton)
    camera:newLayer(1,DrawControls)
  end

  --setting instruction
  if button("Credit","Credit",positionCreditX,positionCreditY)then
    camera:removeLayer(DrawOptionbutton)
    camera:newLayer(1,DrawCredit)
  end

  if button("Back","Back",positionBackX,positionBackY) then
    camera:removeLayer(DrawOptionbutton)
    camera:newLayer(1,menu.draw)
  end
  released = false
end

--variable to choose which background
local index = 1
local function EditorLevel(dimension)

  StateGame = maker
  StateGame.load(index,dimension)
  print(index)
  camera:ToMaker()
end

function DrawselectDimension()

  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.setFont(titlefont)
  love.graphics.print("Metal Bug",positiontitleX,positiontitleY)

  --button("Dimension","Dimension",positionDimensionX,positionDimensionY)

  love.graphics.setColor(255,255,255,255)
  love.graphics.setFont(menufont)
  love.graphics.print("Dimension",positionDimensionX,positionDimensionY)

  --setting button for various dimension
  if index == 1 then
    if button("918x224","x918",position918x224X,position918x224Y)then
      EditorLevel(918)
    end
  elseif index == 2 then
    if button("918x224","x918",position918x224X,position918x224Y)then
      EditorLevel(918)
    end
    if button("1247x224","x1247",position1247x224X,position1247x224Y)then
      EditorLevel(1247)
    end
  elseif index == 3 or index == 4 or index == 5  then
    if button("918x224","x918",position918x224X,position918x224Y)then
      EditorLevel(918)
    end
    if button("1247x224","x1247",position1247x224X,position1247x224Y)then
      EditorLevel(1247)
    end
    if button("1602x224","x1602",position1602x224X,position1602x224Y)then
      EditorLevel(1602)
    end
  else
    if button("918x224","x918",position918x224X,position918x224Y)then
      EditorLevel(918)
    end
    if button("1247x224","x1247",position1247x224X,position1247x224Y)then
      EditorLevel(1247)
    end
    if button("1602x224","x1602",position1602x224X,position1602x224Y)then
      EditorLevel(1602)
    end
    if button("2000x224","x2000",position2000x224X,position2000x224Y)then
      EditorLevel(2000)
    end
    if button("2568x224","x2568",position2568x224X,position2568x224Y)then
      EditorLevel(2568)
    end
  end

  if button("Back","Back",positionBackX,position2568x224Y + heightOptionFont+20) then
    camera:removeLayer(DrawselectDimension)
    camera:newLayer(1,DrawThumbnail)
  end

  released = false
end

function DrawThumbnail()

  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.setFont(titlefont)
  love.graphics.print("Metal Bug",positiontitleX,positiontitleY)

  --set width of the line
  love.graphics.setLineWidth(10)
  local s = false

  --draw rectangle over image
    if overimage(Background.quad1X,Background.quad1Y) and released then
      index = 1
      camera:removeLayer(DrawThumbnail)
      camera:newLayer(1,DrawselectDimension)
    end
    love.graphics.draw(Background[1],Background.quad1,
      Background.quad1X,
      Background.quad1Y,
      0,
      0.5,
      0.5
    )
    if overimage(Background.quad2X,Background.quad2Y) and released then
      index = 2
      camera:removeLayer(DrawThumbnail)
      camera:newLayer(1,DrawselectDimension)
    end
    love.graphics.draw(Background[2],Background.quad2,
      Background.quad2X,
      Background.quad2Y,
      0,
      0.5,
      0.5
    )
    if overimage(Background.quad3X,Background.quad3Y) and released then
      index = 3
      camera:removeLayer(DrawThumbnail)
      camera:newLayer(1,DrawselectDimension)
    end
    love.graphics.draw(Background[3],Background.quad3,
      Background.quad3X,
      Background.quad3Y,
      0,
      0.5,
      0.5
    )
    if overimage(Background.quad4X,Background.quad4Y) and released then
      index = 4
      camera:removeLayer(DrawThumbnail)
      camera:newLayer(1,DrawselectDimension)

    end
    love.graphics.draw(Background[4],Background.quad4,
      Background.quad4X,
      Background.quad4Y,
      0,
      0.5,
      0.5
    )
    if overimage(Background.quad5X,Background.quad5Y) and released then
      index = 5
      camera:removeLayer(DrawThumbnail)
      camera:newLayer(1,DrawselectDimension)

    end
    love.graphics.draw(Background[5],Background.quad5,
      Background.quad5X,
      Background.quad5Y,
      0,
      0.5,
      0.5
    )
    if overimage(Background.quad6X,Background.quad6Y) and released then
      index = 6
      camera:removeLayer(DrawThumbnail)
      camera:newLayer(1,DrawselectDimension)

    end
    love.graphics.draw(Background[6],Background.quad6,
      Background.quad6X,
      Background.quad6Y,
      0,
      0.5,
      0.5
    )

    if button("Back","Back",positionBackX,Background.quad6Y+130) then
    camera:removeLayer(DrawThumbnail)
    camera:newLayer(1,menu.draw)
    end

  released = false
end




function menu.draw()

  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.setFont(titlefont)
  love.graphics.print("Metal Bug",positiontitleX,positiontitleY)

  if button("Play","Play",positionPlayX,positionPlayY)then
    playbutton()
  end

  if button("Editor","editor",positionEditorX,positionEditorY)then
    camera:removeLayer(menu.draw)
    camera:newLayer(1,DrawThumbnail)
  end

  if button("Options","Options",positionOptionsX,positionOptionsY)then
    camera:removeLayer(menu.draw)
    camera:newLayer(1,DrawOptionbutton)
  end

  if button("Quit","Quit",positionQuitX,positionQuitY) then
      love.event.quit()
  end
  released = false
end
