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

    --positions and scores player 1
    
    p1s = 0
    
    --positions and scores player 2
    
    p2s = 0
    
    -- ball initial position
    -- ballX = V_Width / 2 - 2 
    -- ballY = V_Height / 2 -2

    --ball speed
    -- ballDX = math.random(2) == 1 and 200 or -100
    -- ballDY = math.random(-50, 50)

    gameState = 'idle'


    -- love.window.setMode(W_Width, W_Height, {
    --     fullscreen = false, 
    --     resizable = false,
    --     vsync = true
    -- })
end

function love.update(dt)

    --collisions 
    if gameState == 'play' then
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
        end

        if ball.y >= V_Height - 4 then
            ball.y = V_Height - 4
            ball.dy = -ball.dy
        end

        if ball:collides(player1) then
            ball.dx = -ball.dx * JuJuSpeed
            ball.x = player1.x + 5
            if ball.dy < 0 then
                ball.dy = -math.random(10,150) -- new direction
            else
                ball.dy = math.random(10,150) -- new direction
            end
        end

        if ball:collides(player2) then
            ball.dx = -ball.dx * JuJuSpeed
            ball.x = player2.x - 4
            if ball.dy < 0 then
                ball.dy = -math.random(10,150) -- new direction
            else
                ball.dy = math.random(10,150) -- new direction
            end
        end
    end

    if ball.x < 0 then
        p2s = p2s + 1
        ball:reset()
        gameState = 'idle'
    end
    
    if ball.x > V_Width then
        p1s = p1s + 1
        ball:reset()
        gameState = 'idle'
    end

    --player 1
    if love.keyboard.isDown('w') then 
        -- p1y = math.max(0, p1y + -(SPEED * dt)) --smaller y is up
        player1.dy = -SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy =  SPEED
        -- p1y = math.min(V_Height - P_H, p1y + (SPEED * dt)) --bigger y is down
    else
        player1.dy = 0
    end

    --player 2
    if love.keyboard.isDown('up') then 
        player2.dy = -SPEED
        -- p2y = math.max( 0, p2y + -(SPEED * dt)) --smaller y is up
    elseif love.keyboard.isDown('down') then
        player2.dy =  SPEED
        -- p2y = math.min( V_Height - P_H, p2y + (SPEED * dt)) --bigger y is down
    else
        player2.dy =  0
    end

    if gameState == 'play' then 
        ball:update(dt)
        -- ballX = ballX + ballDX * dt
        -- ballY = ballY + ballDY * dt
    end

    player1:update(dt)
    player2:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then 
        if gameState == 'idle' then 
            gameState = 'play'
        else 
            gameState = 'idle'
            -- --move ball to origin
            -- ballX = V_Width / 2 - 2 
            -- ballY = V_Height / 2 -2
            -- --reset movement speed
            -- ballDX = math.random(2) == 1 and 200 or -200
            -- ballDY = math.random(-50, 50)
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
    else 
        love.graphics.printf('Hood Pong', 0, 20, V_Width, 'center') 
    end
    -- scores
    love.graphics.setFont(scorefont)
    love.graphics.print(tostring(p1s), 180, V_Height/6) --score p1
    love.graphics.print(tostring(p2s), 230, V_Height/6) --score p2

    --paddles
    player1:render()
    player2:render()
    ball:render()
    -- love.graphics.rectangle('fill', 10, p1y, P_W, P_H)
    -- love.graphics.rectangle('fill', V_Width - 15, p2y, P_W, P_H)
    -- ball
    -- love.graphics.rectangle('fill', ballX, ballY, 4, 4)
    --


    push:apply('end')
end
