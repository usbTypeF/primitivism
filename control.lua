local scale, research_limit, researched, cost_scale

function space_age_check()
    space_age = false

    for name, _ in pairs(script.active_mods) do
        if name == "space-age" then
            research_limit = research_limit * 2
        end
    end
end

function primitivism_init()
    if(settings.global["primitivism-difficulty"].value == "caveman") then
        scale = 1.03
        research_limit =  45
    elseif(settings.global["primitivism-difficulty"].value == "alchemist") then
        scale = 1.025
        research_limit =  50
    elseif(settings.global["primitivism-difficulty"].value == "scientist") then
        scale = 1.02
        research_limit =  60
    end

    researched = 0
    cost_scale = 1

    if(settings.global["primitivism-cost_scaling"].value == false) then
        scale = 1
    end

    space_age_check()
end

function scale_cost()
    game.difficulty_settings.technology_price_multiplier = cost_scale
end

function calculate_scale()
    cost_scale = cost_scale * scale
end

function count_researched()
    researched = researched + 1
end

function on_research_finished()
    count_researched()

    if researched > research_limit then
        game.difficulty_settings.technology_price_multiplier = 1000
    else
        calculate_scale()
        scale_cost()
    end

end

--

do primitivism_init() end

script.on_event(defines.events.on_research_finished, function(event)
    if not event.by_script then
        on_research_finished()
        game.print("You Have "..research_limit - researched.." Researches Remaining")
    end
end)