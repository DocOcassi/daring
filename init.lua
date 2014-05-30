-- Daring A widget for awesome. 
-- Draws a circle on the widget space and taggs it to a 0-100 input.
--
-- Colors from your beautifil theme.
-- theme.fg_focus
-- theme.fg_normal
-- theme.fg_disable

local wibox = require("wibox")
local beautiful = require("beautiful")

-- template the object?
function daring_temp()
    -- Create from base
    local daring = daring_widget()
    
    -- Create the draw function for your function
    --daring.draw() = function(daring, wibox, cr, width, height)
        -- ... Extra code here ...
    --end
        
    -- Start the timer with interval.
    daring:start_timer(0.5)

    return daring
end


-- A Volume Display, has no control options yet
function daring_volume()
    local daring = daring_widget()

    daring.draw = function(daring, wibox, cr, width, height)
        
        state, volume = daring.getMasterVol()
        if state == 'off' then
            daring.draw_ring(daring, cr, volume, daring.colorDisabled)
            daring.draw_disable(daring, cr, daring.colorDisabled)

        else
            daring.draw_ring(daring, cr, volume, daring.colorActive)
        end
        
    end

    daring.getMasterVol = function()
        local f=io.popen("amixer get Master")
        for line in f:lines() do
            if string.match(line, "%s%[%d+%%%]%s") ~= nil then
                volume=string.match(line, "%s%[%d+%%%]%s")
                volume=string.gsub(volume, "[%[%]%%%s]","")
                --helpers.dbg({volume})
            end
            if string.match(line, "%s%[[%l]+%]$") then
                state=string.match(line, "%s%[[%l]+%]$")
                state=string.gsub(state,"[%[%]%%%s]","")
            end
        end
        f:close()
        return state, volume
    end


    daring:start_timer(0.2)

    return daring
end



-- [ daring widget  ] ----------------------------------------------------------------

function daring_widget() 
    local daring = wibox.widget.base.make_widget()

    -- Cange hex colour into cairo,
    daring.getcairocolour = function(colour)
        c = {}
        table.insert(c, 1/255 * tonumber(string.sub(colour, 2, 3), 16))
        table.insert(c, 1/255 * tonumber(string.sub(colour, 4, 5), 16))
        table.insert(c, 1/255 * tonumber(string.sub(colour, 6, 7), 16))
        if string.count == 9 and false then
            -- not sure if this is right.
            table.insert(c, 1/255 * tonumber(string.sub(colour, 8, 9), 16))
        else
            table.insert(c, 1)
        end
        return c
    end

    daring.rad = 0 
    daring.border = 1
    daring.lineWidth = 1
    daring.colorActive = daring.getcairocolour(beautiful.fg_focus) 
    daring.colorDisabled = daring.getcairocolour(beautiful.fg_normal) 

    -- only used on the example
    daring.count = 1
    daring.dir = 0

    -- get the colour for the cairo context
    daring.colour = function(daring, colour)
        return colour[0], colour[1], colour[2], colour[3]
    end

    -- fit the drawing area.
    daring.fit = function(daring, width, height)
        if daring.rad == 0 then
            -- do calc
            dia = math.min(width, height)
            daring.rad = dia/2
        end
        return dia, dia
    end
 
    -- draw the widget, should be overwritten by subclass.
    daring.draw = function(daring, wibox, cr, width, height)
        if daring.count < 2 then
            daring.dir = 0
        elseif daring.count > 100 then
            daring.dir = 1
        end
        if daring.dir == 1 then
            daring.count = daring.count - 2
        else
            daring.count = daring.count + 2
        end
        percent = daring.count
        daring.draw_ring(daring, cr, percent, daring.colorActive)
        
    end

    -----------------------------------------------------
    -- draw a line across the circle to denote diabled
    -- @param daring   object persistence
    -- @param cr       cairo context
    -- @param colour   color to use
    daring.draw_disable = function(daring, cr, colour)
        dim = daring.rad*1.6
        rim = (daring.rad*2)-dim
        cr:move_to(dim, rim)
        cr:line_to(rim, dim)
 		    cr:set_source_rgba(daring.colour(daring, colour))
        cr:set_line_width (daring.rad/4)
 	      cr:stroke()
 
    end

    ------------------------------------------------------
    -- draws the arc percent clockways from 12 using color.
    -- @param daring   object persistence
    -- @param cr       cairo context
    -- @param percent  reference value as percentage
    -- @param colour   color to use
    daring.draw_ring = function(daring, cr, percent, colour)
        -- translate the range into radans.
        s = (math.pi/50) +math.pi*1.5
        e = (percent * math.pi/50) +math.pi*1.5
        -- CenterX, CenterY, Radius, start(rad), end(rad)
        cr:arc(daring.rad, daring.rad, daring.rad*0.8, s, e)
 		    cr:set_source_rgba(daring.colour(daring, colour))
        cr:set_line_width (daring.rad/4)
 	      cr:stroke()
    
    end
   
    ----------------------------------------
    -- start the timer with a pause time.
    -- @param daring   object persistence
    -- @param time     sleep time in seconds.
    daring.start_timer = function(daring, time)
        -- setup the timer and start it.
        daringtimer = timer { timeout = time }
        daringtimer:connect_signal("timeout",
            function() daring:emit_signal("widget::updated") end)
        daringtimer:start()
    end
    
    return daring
end



