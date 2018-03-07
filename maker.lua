require "load"
require "cameram"
require "menu"

maker = {}
maker.indexback = 1

local endbound
local scrollX = 0
local delta = 0

function maker.load(index,dimension)

  maker.indexback = index
  scrollX = 0

  local m  = Background[maker.indexback]:getWidth()
  if  m > dimension   then
       m = dimension
  end

  endbound = (m*2.5) - width

  enemy1 = love.graphics.newQuad(579,340,35,38,imgX,imgY)
  enemy2 = love.graphics.newQuad(377,57 ,31,44,imgX,imgY)
  enemy3 = love.graphics.newQuad(350,225,48,49,imgX,imgY)

  enemy1x,enemy2x,enemy3x = width/2-150,width/2-30,width/2+130
  enemy1y,enemy2y,enemy3y = height-90,height-100,height-105

  --structure for all drag sprite
  draggedsprite = {}

  rect1 = {
    x = enemy1x,
    y = enemy1y,
    w = 64,
    h = 45,
    drag = {active = false,diffx = 0,diffy = 0}
  }
  rect2 = {
    x = enemy2x,
    y = enemy2y,
    w = 51,
    h = 44,
    drag = {active = false,diffx = 0,diffy = 0}
  }
  rect3 = {
    x = enemy3x,
    y = enemy3y,
    w = 88,
    h = 49,
    drag = {active = false,diffx = 0,diffy = 0}
  }
end

function maker.mousereleased(x, y, button)
  if button == 1 then
    for i,v in ipairs(draggedsprite)do
      if v.drag.active then
        v.drag.active = false
        v.y = 460
        v.x = v.x + delta
      end
      --print("--",v.x,v.dx,v.type)
    end
  end
end


function maker.mousepressed(x,y,button)
   if button == 1 then
     if x > rect1.x and x < rect1.x + rect1.w
      and y > rect1.y and rect1.y + rect1.h
     then
      table.insert(draggedsprite,{
        type = 0.1,
        t = enemy1,
        dx = enemy1x,
        x = enemy1x,
        y = enemy1y,
        w = 44,
        h = 35,
        drag = {active = true,diffx = x - enemy1x,diffy = y - enemy1y}
      })
     end
     if x > rect2.x and x < rect2.x + rect2.w
      and y > rect2.y and rect2.y + rect2.h
     then
      table.insert(draggedsprite,{
        type = 2,
        t = enemy2,
        dx = enemy2x,
        x = enemy2x,
        y = enemy2y,
        w = rect2.w,
        h = rect2.h,
        drag = {active = true,diffx = x-enemy2x,diffy = y-enemy2y}
      })
     end
     if x > rect3.x and x < rect3.x + rect3.w
      and y > rect3.y and rect3.y + rect3.h
     then
      table.insert(draggedsprite,{
        type = 5,
        t = enemy3,
        dx = enemy3x,
        x = enemy3x,
        y = enemy3y,
        w = rect3.w,
        h = rect3.h,
        drag = {active = true,diffx = x-enemy3x,diffy = y-enemy3y}
      })
     end
  end
end


function maker.update(dt)

  if love.keyboard.isDown("d") and scrollX > -endbound  then
    scrollX = scrollX - 500*dt
    delta   = delta   + 500*dt
    for _,v in ipairs(draggedsprite)do
      v.dx = v.dx - 500*dt
    end
  elseif love.keyboard.isDown("a") and scrollX < 0 then
    scrollX = scrollX + 500*dt
    delta   = delta   - 500*dt
    for _,v in ipairs(draggedsprite)do
      v.dx = v.dx + 500*dt
    end
  end

  for i,v in ipairs(draggedsprite)do
    if v.drag.active then
      v.x = love.mouse.getX() - v.drag.diffx
      v.dx = love.mouse.getX() - v.drag.diffx
      v.y = love.mouse.getY() - v.drag.diffy
    end
  end
end


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
  return inside and love.mouse.isDown(1)
end

function Playmakergame()
  StateGame = player
  --change camera
  StateGame.loadedit(maker.indexback,endbound)
  menu.loadplayer = 1
  --insert enemy at position
  for i,v in ipairs(draggedsprite)do
    enemy = loadenemy(v.x,v.type)
    table.insert(enemies,enemy)
  end

end

local function drawstaticsprite()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(imagenemy,enemy1,enemy1x,enemy1y,0,2,2)
    love.graphics.draw(imagenemy,enemy2,enemy2x,enemy2y,0,2,2)
    love.graphics.draw(imagenemy,enemy3,enemy3x,enemy3y,0,2,2)
end

function maker.draw()

    if button("Back","Back",50,50) then
      StateGame = menu
      scrollX,delta = 0,0
      camera:ToMenueditor()
    end
    if button("Play","Play",700,50)then
      Playmakergame()
      scrollX,delta = 0,0
    end
    --draw static sprite
    drawstaticsprite()

end

--draw all positioned enemy
function maker.drawbackground()

    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(Background[maker.indexback],scrollX,20,0,2.5,2.5)

    for i,v in ipairs(draggedsprite)do

      if v.drag.active then
        love.graphics.draw(imagenemy,v.t,v.x,v.y,0,2,2)
      else
        love.graphics.draw(imagenemy,v.t,v.dx,v.y,0,2,2)
      end
    end


end
