local bounds = {
  x = 0,
  y = 0
  };

local player = {
  x = 0,
  y= 0
};

local pickup = {
  x = 0,
  y = 0,
  alive = false,
  mod = 1
};

local score = 0
local dead = false

function distance(a, b) 
  
  return math.sqrt(math.pow(b.x - a.x, 2) + math.pow(b.y - a.y, 2))
  
end

function reset_pickup()
  
    if (player.x < bounds.x / 2) then
      pickup.x = math.random(bounds.x / 2 + 50, bounds.x - 1)
    else
      pickup.x = math.random(1, bounds.x / 2 -50)
    end
    
    pickup.y = 30;
    pickup.alive = true;
    pickup.mod = 0.8 + math.random()
    
end

function love.load() 
  
  love.window.setFullscreen(true, "desktop")
    
  bounds.x, bounds.y = love.graphics.getDimensions();
  
  dropspeed = bounds.y / 10;
  
  player.x = bounds.x / 2;
  player.y = bounds.y / 4;
  
  reset_pickup()
  
end

function love.update()
  
  if love.keyboard.isDown("escape") then
    love.event.quit()
  end

  if not dead then

    score = score + (love.timer.getDelta() * (1 + dropspeed))
    dropspeed = dropspeed + love.timer.getDelta() * 4;

    local delta = love.timer.getDelta();
    local playerdrop = (math.log10(dropspeed) * 4 * delta * (bounds.y / 40));
    local pickupdrop = (math.log10(dropspeed) * 4 * delta * (bounds.y / 20)) * pickup.mod;
    local mpos = {
      x = love.mouse.getX(),
      y = love.mouse.getY()
    };
    
    player.y = player.y + playerdrop;
    
    if pickup.alive then
      pickup.y = pickup.y + pickupdrop
      
      if (distance(pickup, mpos) < 60) then
        pickup.alive = false
        player.x = pickup.x
        player.y = pickup.y
        
        reset_pickup()
        
      end
      
      
    end
    
    if bounds.y < player.y then
      dead = true
    end
  
  end
  
end



function love.draw()
  
  if dead then
    
    love.graphics.setBackgroundColor(255, 0, 0, 255);
    love.graphics.clear();
    
    love.graphics.setColor(255, 255, 255, 255);
    love.graphics.print("Game over. Final score: " .. math.floor(score), 20, 20)
    
    love.graphics.print("Game over. Final score: " .. math.floor(score), 20, 20)
    
  else
  
    local mx,my = love.mouse.getPosition();
  
    love.graphics.setColor(100, 100, 100, 255);
    love.graphics.print("Score: " .. math.floor(score), 20, 20)
    
    love.graphics.setColor(255, 255, 255, 50);
    love.graphics.circle("fill", mx, my, 60, 20);
    
    if pickup.alive then
      love.graphics.setColor(255, 255, 0, 255);
    love.graphics.circle("fill", pickup.x, pickup.y, 10 , 20);  
      end
    
    love.graphics.setColor(0, 255, 255, 255);
    love.graphics.circle("fill", player.x, player.y, 20, 20);
  
  end
  
end