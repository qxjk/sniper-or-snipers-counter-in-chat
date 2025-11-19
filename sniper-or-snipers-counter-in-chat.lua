sniper = sniper or { alive = 0 }
local s = sniper

local function warning_msg(text)
    if managers.chat then
        managers.chat:_receive_message(1, "WARNING", text, Color.red)
    elseif managers.hud then
        managers.hud:show_hint({ text = text })
    end
end

local function good_news_msg(text)
    if managers.chat then
        managers.chat:_receive_message(1, "GOOD NEWS", text, Color.green)
    elseif managers.hud then
        managers.hud:show_hint({ text = text })
    end
end

function s:reset()
    self.alive = 0
end

local function is_sniper(u)
    local b = alive(u) and u:base()
    return b and b.has_tag and b:has_tag("sniper")
end

function s:announce()
    if self.alive == 0 then
        good_news_msg("ALL SNIPERS KILLED")
    else
        local prefix = (self.alive == 1) and "SNIPER: " or "SNIPERS: "
        warning_msg(prefix .. tostring(self.alive))
    end
end

function s:scan()
    local enemies = managers.enemy and managers.enemy:all_enemies()
    if not enemies then return end

    local count = 0
    for _, data in pairs(enemies) do
        if is_sniper(data.unit) then
            count = count + 1
        end
    end

    local old = self.alive
    self.alive = count
    if count ~= old then
        self:announce()
    end
end

if RequiredScript == "lib/setups/gamesetup" then
    Hooks:PostHook(GameSetup, "init_game", "GameSetupInitGameReset", function()
        s:reset()
    end)

    Hooks:PostHook(GameSetup, "update", "GameSetupUpdateScan", function()
        s:scan()
    end)
end
