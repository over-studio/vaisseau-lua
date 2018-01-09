-- vaisseau spacial

Lander = {}
Lander.x = 0
Lander.y = 0
Lander.angle = 270
Lander.speed = 5
Lander.vx = 0
Lander.vy = 0
Lander.img = love.graphics.newImage("images/ship.png")
Lander.imgEngine = love.graphics.newImage("images/engine.png")
Lander.isMoving = false

Vector2 = {
    mt = {},
    x = 0,
    y = 0,
    distance = function(self)
        return (self.x * self.x + self.y * self.y) ^ 0.5
    end,
    normalized = function(self)
        return self.x/Vector2.distance(self), self.y/Vector2.distance(self)
    end
}

Vector2.x = 5
Vector2.y = 3
v1, v2 = Vector2:normalized()



function love.load()
    largeur = love.graphics.getWidth()
    hauteur = love.graphics.getHeight()

    Lander.x = largeur / 2
    Lander.y = hauteur / 2
end

function love.update(dt)
    if love.keyboard.isDown("space") then
        Lander.x = largeur / 2
        Lander.y = hauteur / 2
    end

    if love.keyboard.isDown("right") then
        Lander.angle = Lander.angle + 90 * dt
        if Lander.angle > 360 then Lander.angle = 0 end
    end
    
    if love.keyboard.isDown("left") then
        Lander.angle = Lander.angle - 90 * dt
        if Lander.angle < 0 then Lander.angle = 360 end
    end

    if love.keyboard.isDown("up") then
        Lander.isMoving = true
        
        -- on calcule l'angle en radians
        local angleRAD = math.rad(Lander.angle)
        -- on calcule la direction
        local directionX = math.cos(angleRAD)
        local directionY = math.sin(angleRAD)
        -- on calcule la force de mouvement à appliquer sur le lander pour le faire déplacer
        local forceX = directionX * Lander.speed * dt
        local forceY = directionY * Lander.speed * dt

        -- on calcule la vélocité du lander
        Lander.vx = Lander.vx + forceX
        Lander.vy = Lander.vy + forceY
        
        --[[if math.abs(Lander.vx) > 1 then
            if Lander.vx > 0 then Lander.vx = 1 end
            if Lander.vx < 0 then Lander.vx = -1 end
        end
        if math.abs(Lander.vy) > 1 then
            if Lander.vy > 0 then Lander.vy = 1 end
            if Lander.vy < 0 then Lander.vy = -1 end
        end --]]
    else
        Lander.isMoving = false
        
        -- on applique une force de frottement (Friction) sur le lander pour l'arrêter
        if math.abs(Lander.vx) > 0.01 then
            Lander.vx = Lander.vx * .95
        else
            Lander.vx = 0
        end
        if math.abs(Lander.vy) > 0.01 then
            Lander.vy = Lander.vy * .95
        else
            Lander.vy = 0
        end
    end

    -- ajouter la force de gravité au lander
    -- Lander.vy = Lander.vy + 0.001 * 60 * dt


    -- ajouter la vélocité au Lander pour changer sa position
    Lander.x = Lander.x + Lander.vx
    Lander.y = Lander.y + Lander.vy

    -- toujours afficher le Lander dans le stage
    if Lander.x < 0 then Lander.x = largeur end
    if Lander.x > largeur then Lander.x = 0 end
    if Lander.y < 0 then Lander.y = hauteur end
    if Lander.y > hauteur then Lander.y = 0 end
end

function love.draw()
    love.graphics.draw(Lander.img, 
                            Lander.x, Lander.y, 
                            math.rad(Lander.angle), 
                            1, 1, 
                            Lander.img:getWidth()/2, Lander.img:getHeight()/2
                        )
    
    if Lander.isMoving then
        love.graphics.draw(Lander.imgEngine, 
        Lander.x, Lander.y, 
        math.rad(Lander.angle), 
        1, 1, 
        Lander.imgEngine:getWidth()/2, Lander.imgEngine:getHeight()/2)
    end

    love.graphics.line( Lander.x,
                        Lander.y, 
                        Lander.x + math.cos(math.rad(Lander.angle)) * largeur * 2, 
                        Lander.y + math.sin(math.rad(Lander.angle)) * largeur * 2)

    local sDebug = ""
    sDebug = sDebug .. "Rotation = " .. tostring(Lander.angle) .. "\n"
    sDebug = sDebug .. "vx = " .. tostring(Lander.vx) .. "\n"
    sDebug = sDebug .. "vy = " .. tostring(Lander.vy)
    love.graphics.print(sDebug)
end
