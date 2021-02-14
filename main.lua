push  = require 'push'
Class = require 'Class'

require 'Paddle'
require 'Ball'

-----

W_Width  = 1280
W_Height = 720

V_Width  = 432
V_Height = 243

SPEED = 220
P_H = 20
P_W = 8

JuJuSpeed = 1.05

function love.load()
    love.window.setTitle("Pacomarm Productions")
    --sound effects p1
    p1hit = love.audio.newSource("audio/steve.mp3", "static")
    p1win = love.audio.newSource("audio/win1.mp3", "static")
    p1score = love.audio.newSource("audio/gg1.mp3", "static")
    --sound effects p2
    p2hit = love.audio.newSource("audio/hehe.mp3", "static")
    p2win = love.audio.newSource("audio/win2.mp3", "static")
    p2score = love.audio.newSource("audio/gg2.mp3", "static")

    --sponsors
    sponsor1 = love.graphics.newImage("img/jorobas.jpg")
    sponsor2 = love.graphics.newImage("img/nutri.png")

    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())

    push:setupScreen(V_Width, V_Height, W_Width, W_Height, {
        fullscreen = false,
        resizable  = false,
        vsync      = false,
    })

    font = love.graphics.newFont('font.ttf', 18)
    scorefont = love.graphics.newFont('font.ttf', 30)
    love.graphics.setFont(font)


    player1 = Paddle(10, 30, P_W, P_H)
    player2 = Paddle(V_Width - 15, V_Height - 40, P_W, P_H)

    ball = Ball(V_Width / 2 - 2, V_Height / 2 -2, 4,4)

    p1s = 0
    p2s = 0

    servingPlayer = 1

    gameState = 'idle'
end

function love.update(dt)

    if gameState == 'serve' then
        if servingPlayer == 1 then
            ball.dx = -math.random(50, 100)*2
        else
            ball.dx =  math.random(50, 100)*2
        end
        ball.dy = (math.random(2) == 1 and -100 or 100) * 2
    --collisions 
    elseif gameState == 'play' then
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
        end

        if ball.y >= V_Height - 4 then
            ball.y = V_Height - 4
            ball.dy = -ball.dy
        end

        if ball:collides(player1) then
            p1hit:play()
            ball.dx = -ball.dx * JuJuSpeed
            ball.x = player1.x + 5
            if ball.dy < 0 then
                ball.dy = -math.random(10,150)*2 -- new direction
            else
                ball.dy = math.random(10,150)*2 -- new direction
            end
        end
        
        if ball:collides(player2) then
            p2hit:play()
            ball.dx = -ball.dx * JuJuSpeed
            ball.x = player2.x - 4
            if ball.dy < 0 then
                ball.dy = -math.random(10,150)*2 -- new direction
            else
                ball.dy = math.random(10,150)*2 -- new direction
            end
        end
    end

    if ball.x < 0 then
        p2s = p2s + 1
        if p2s == 5 then
            p2win:play()
            winningPlayer = 2
            p1s = ':('
            p2s = ':)'
            gameState = 'done'
        else
            p2score:play()
            servingPlayer = 1
            gameState = 'serve'
        end
        ball:reset()
    end
    
    if ball.x > V_Width then
        p1s = p1s + 1
        if p1s == 5 then 
            p1win:play()
            winningPlayer = 1
            p1s = ':)'
            p2s = ':('
            gameState = 'done'
        else
            p1score:play()
            servingPlayer = 2
            gameState = 'serve'
        end
        ball:reset()
    end

    --player 1
    if love.keyboard.isDown('w') then 
        player1.dy = -SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy =  SPEED
    else
        player1.dy = 0
    end

    --player 2
    if love.keyboard.isDown('up') then 
        player2.dy = -SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy =  SPEED
    else
        player2.dy =  0
    end

    if gameState == 'play' then 
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then 
        if gameState == 'idle' then 
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'done' then
            gameState = 'serve'
            ball:reset()
            p1s = 0
            p2s = 0
            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        else
            gameState = 'start'
            ball:reset()
        end
    end 
end

function love.draw()
    push:apply('start')
    --draw begin --------

    --main txt
    love.graphics.setFont(font)
    if gameState == 'idle' then 
        love.graphics.printf('Hood Pong, Press enter', 0, 20, V_Width, 'center') 
    elseif gameState == 'serve' then
        love.graphics.printf("Player " .. tostring(servingPlayer) .. " to serve", 0, 10, V_Width, 'center') 
        -- love.graphics.printf('Hood Pong', 0, 20, V_Width, 'center') 
    elseif gameState == 'play' then 
        love.graphics.printf('Hood Pong', 0, 20, V_Width, 'center') 
    elseif gameState == 'done' then
        love.graphics.printf("Player " .. tostring(winningPlayer) .. " wins!", 0, 10, V_Width, 'center') 
        love.graphics.printf('Press Enter to restart', 0, 90, V_Width, 'center') 
        love.graphics.printf('This game has been brought to you by Jorobas Beers and Nutrileche!', 100, 190, V_Width, 'center',0,.5,.5) 
    else
        love.graphics.printf('GG', 0, 20, V_Width, 'center') 
    end
    -- scores
    love.graphics.setFont(scorefont)
    love.graphics.print(tostring(p1s), 180, V_Height/6) --score p1
    love.graphics.print(tostring(p2s), 230, V_Height/6) --score p2

    --sponsors
    love.graphics.draw(sponsor1, 50,10, 0, .2, .2)
    love.graphics.draw(sponsor2, 320,170, 0, .3, .3)

    --paddles
    love.graphics.setColor(204,0,0)
    player1:render()
    love.graphics.setColor(0,0,252)
    player2:render()
    love.graphics.setColor(0,222,0)
    ball:render()
    
    push:apply('end')
end
