require "cameram"
require "load"
require "player"
require "menu"
require "enemy"
require "mainplayermove"
require "maker"
require "winner"

--variable for change state of game
StateGame = menu

function love.load()

    pausa = false
    --load map and load image
    loadworld()

    StateGame.load()
    imgpause =  nil
    
end

function love.update(dt)

    pause()
    if (pausa) then
      return
    end
    StateGame.update(dt)

end

--change function for state of the game
function love.keyreleased(key)
  if StateGame.keyreleased then StateGame.keyreleased(key) end
end

function love.keypressed(key,unicode)
    if StateGame == player then
      love.keyboard.keyspressed[key] = true
    end
end

function love.mousereleased(x, y, button, isTouch)
  if StateGame.mousereleased then StateGame.mousereleased(x,y,button)end
end

function love.mousepressed(x, y, button, isTouch)
  if StateGame.mousepressed then StateGame.mousepressed(x,y,button)end
end



function pause()
    if(love.keyboard.waspressed("p"))then pausa = not pausa
        love.keyboard.keyspressed.p = false
        imgpause = love.graphics.newScreenshot()
        imgpause:encode('png',"screen.png")
        imgpause = love.graphics.newImage(imgpause)
    end
end

function love.resize(w, h)

  if StateGame.resize then StateGame.resize(w,h) end
  print("new size : " .. w .. " - " .. h)

end


function love.draw()

      if(pausa)then
        love.graphics.setColor(255, 255, 255, 100)
        love.graphics.draw(imgpause,centerimg(imgpause))
        love.graphics.setColor(255, 255, 255)
        return
      end

      camera:draw()

    end
