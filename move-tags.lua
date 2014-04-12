local mousegrabber = require("mousegrabber")
local awful = require("awful")
local naughty = require("naughty")
local ipairs = ipairs
local tostring = tostring
local type = type
local table = table
module("move-tags")

-- Work around bug in awesome 3.5, fixed in upstream on Apr 9, 2014 (setproperty
-- & setscreen)
function my_move(new_index, target_tag)
    local target_tag = target_tag or awful.tag.selected()
    local scr = awful.tag.getscreen(target_tag)
    local tmp_tags = awful.tag.gettags(scr)

    if (not new_index) or (new_index < 1) or (new_index > #tmp_tags) then
        return
    end

    for i, t in ipairs(tmp_tags) do
        if t == target_tag then
            table.remove(tmp_tags, i)
            break
        end
    end

    table.insert(tmp_tags, new_index, target_tag)

    for i, tmp_tag in ipairs(tmp_tags) do
        -- bugfix here: don't set screen, I only have one anyway
        awful.tag.setproperty(tmp_tag, "index", i)
    end
end

function move_tags(t)
    if nil then
        mousegrabber.run(
        function(_mouse)
            for _, v in ipairs(_mouse.buttons) do
                if v then
                    local w = awful.mouse.drawin_under_pointer()
                    if w and awful.widget.taglist.gettag(w) then
                        local target_tag = awful.widget.taglist.gettag(w)
                        if t ~= target_tag then
                            local target_idx = awful.tag.getproperty(target_tag, "index")
                            my_move(taget_idx, t)
                        end
                    end
                    return true
                end
            end
            return false
        end,
        "fleur")
    end
end

