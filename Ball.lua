Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the ball can move in two dimensions
    -- self.dy = 0
    self.dy = math.random(2) == 1 and -80 or 80
    dir = math.random(2) == 1 and -1 or 1
    self.dx = (math.random(150) + 100 ) * dir
    -- self.dx = math.random(-250, 250)
end

--[[
    Places the ball in the middle of the screen, with an initial random velocity
    on both axes.
]]
function Ball:reset()
    self.x = V_Width / 2 - 2
    self.y = V_Height / 2 - 2
    -- self.dy = 0
    self.dy = math.random(2) == 1 and -200 or 200
    self.dx = math.random(-250, 250)
end

--collision
function Ball:collides(paddle)
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
      return false
    end
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then 
      return false
    end
    return true 
end
----
--[[
    Simply applies velocity to position, scaled by deltaTime.
]]
function Ball:update(dt)
    self.x = self.x + self.dx * dt * 1.1
    self.y = self.y + self.dy * dt * 0.4
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end