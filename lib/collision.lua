function collide(v1, v2)
local collision = aabb(v1, v2)
local horizontal, vertical
local mtd
    if collision then
       mtd = calculatemtd(v1, v2)
    end

    if mtd then
       if mtd.x ~= 0 then
          horizontal = true
       end
       if mtd.y ~= 0 then
          vertical = true
       end
    end
    if horizontal then
       v1.x = v1.x + mtd.x
       --At this point you should set your vertical speed to zero as well. For me it's xvel
        v1.xvel = 0
    end
    if vertical then
       v1.y = v1.y + mtd.y
       
      --colliding = true
    end
end

function aabb(v1,v2)

  local ax2,ay2,bx2,by2 = v1.x + v1.width, v1.y + v1.height, v2.x + v2.width, v2.y + v2.height
  return v1.x < bx2 and ax2 > v2.x and v1.y < by2 and ay2 > v2.y

end

function calculatemtd(v1, v2)
   local v1minx = v1.x --Min = top left
   local v1miny = v1.y
   local v2minx = v2.x
   local v2miny = v2.y
   local v1maxx = v1.x + v1.width -- Max = bottom right
   local v1maxy = v1.y + v1.height
   local v2maxx = v2.x + v2.width
   local v2maxy = v2.y + v2.height

   --K, we got our first set of values.

   local mtd = {} --Make our mtd table.

   local left = v2minx - v1maxx
   local right = v2maxx - v1minx
   local up = v2miny - v1maxy
   local down = v2maxy - v1miny
   if left > 0 or right < 0 or up > 0 or down < 0 then --Not colliding. This is the easy part.
      return false
   end

   if math.abs(left) < right then --Determine the collision on both axises? Axis'? I give up. On the x and y axis
      mtd.x = left
      if v1.jumping then
        v1.yvel = 0
        v1.jumping = true
      end
   else
      mtd.x = right
      if v1.jumping then
        v1.yvel = 0
        v1.jumping = true
      end
   end

   if math.abs(up) < down then
      mtd.y = up
      if v1.jumping then
        v1.yvel = 0
        v1.jumping = false
      end
      if v2.disapear ~= nil  then
        if v2.disapear == false then
          timer = timer - love.timer.getDelta()
          if timer <=0 then
            v2.disapear = true
            timer = timeLimit
          end
        end
      end
      if v2.button ~= nil then
        if v2.button == true then
          buttonActive = true
          v2.button = true
        end
      end
      if v2.death then
        death= true
      end
      if v2.Yellowbutton then
        player.Player.gravity = -player.Player.gravity
      end
      if v2.Greenbutton then
        player.Player.gravity = 500
      end
   else
      mtd.y = down
      if v1.jumping then
        v1.yvel = 0
        v1.jumping = true
      end
     if v2.Yellowbutton then
        player.Player.gravity = -player.Player.gravity
      end
      if v2.Greenbutton then
        player.Player.gravity = 500
      end
   end
   if math.abs(mtd.x) < math.abs(mtd.y) then
      mtd.y = 0
   else
      mtd.x = 0
   end
   return mtd
end
