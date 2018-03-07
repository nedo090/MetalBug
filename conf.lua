

function love.conf(t)
    t.window.title = "Metal Bug"
    t.window.width = 960
    t.window.height = 720
    t.window.resizable= false
    t.modules.touch=false
    t.console=false

    --per ridurre flickerin
    t.window.vsync=true
end
