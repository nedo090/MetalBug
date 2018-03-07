camera = {}
camera.x = 0
camera.y = 0
camera.scaleX = 1
camera.scaleY = 1
camera.rotation = 0
camera.layers = {}

function camera:set()
    love.graphics.push()
    love.graphics.rotate(-self.rotation)
    love.graphics.scale( self.scaleX)
    love.graphics.translate(-self.x, -self.y)
end

function camera:unset()
    love.graphics.pop()
end

function camera:move(dx, dy)
    self.x = self.x + (dx or 0)
    self.y = self.y + (dy or 0)
end

function camera:rotate(dr,dt)
  self.rotation = self.rotation + dr*dt
end

function camera:translate(x, y ,dt)
  self.x = self.x + x*dt
  self.y = self.y + y*dt
end

function camera:scale(sx)
  sx = sx or 1
  self.scaleX =  sx
    --self.scaleY = self.scaleY * (sy or sx)
end

function camera:setX(value)
  if self.bounds then
    self.x = math.block(value, self.bounds.x1, self.bounds.x2)
  else
    self.x = value
  end
end

function camera:setY(value)
  if self.bounds then
    self.y = math.block(value, self.bounds.y1, self.bounds.y2)
  else
    self.y = value
  end
end

function camera:setPosition(x, y)
  if x then self:setX(x) end
  if y then self:setY(y) end
end

function camera:setScale(sx, sy)
  self.scaleX = sx or self.scaleX
  self.scaleY = sy or self.scaleY
end

function camera:setBounds(x1,y1,x2,y2)
  self.bounds = {x1 = x1, y1 = y1, x2 = x2, y2 = y2}
end

function camera:newLayer(scale, fun)
  table.insert(self.layers, {draw = fun, scale = scale})
  table.sort(self.layers,function(a,b) return a.scale < b.scale end)
end

function camera:removeLayer(fun)
  for i,v in ipairs(self.layers) do
    if v.draw == fun then
      table.remove(self.layers,i)
    end
  end
end

function camera:removeAllLayer()

  for i = #self.layers,1,-1 do
    --print(i)
    --print(self.layers[i].draw)
    table.remove(self.layers)
  end
  self.x = 0
--]]
end

function camera:draw()
  local bx,by = self.x, self.y

  for i,v in ipairs(self.layers) do
    self.x = bx * v.scale
    self.y = by * v.scale
    camera:set()
    v.draw()
    camera:unset()
  end
end

function camera:ToMenu()
  camera:removeAllLayer()
  camera:newLayer(0.9,backgroundraw)
  camera:newLayer(1,menu.draw)
  self.x = 0

end
function camera:ToMenueditor()
  camera:removeAllLayer()
  camera:newLayer(0.9,backgroundraw)
  camera:newLayer(1,DrawThumbnail)
  self.x = 0
end

function camera:ToGame()

  camera:removeAllLayer()
  camera:newLayer(1,backgroundplayerdraw)
  camera:newLayer(1,player.draw)

  --reset position player,camera and dead
  PlayerSprite.player.dead = false
  PlayerSprite.player.win  = false
  PlayerSprite.player.x = 70
  self.x = 0
  camera:setBounds(0,0,BackGround.endback[BackGround.index],height)
end


function camera:ToMaker()
  camera:removeAllLayer()
  camera:newLayer(1,maker.drawbackground)
  camera:newLayer(1,maker.draw)
  --camera:newLayer(1,maker.drawdraggedsprite)
  self.x = 0
end

function camera:mousePosition()
    return love.mouse.getX() * self.scaleX + self.x, love.mouse.getY() * self.scaleY + self.y
end

--setting camera in player bounds
function math.block(x,min,max)
  return x < min and min or (x > max and max or x )
end

function centerimg(img)
    return love.graphics.getWidth()/2 - img:getWidth()/2, love.graphics.getHeight()/2 - img:getHeight()/2
end
