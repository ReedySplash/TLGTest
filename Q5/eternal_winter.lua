
--Below is the code for how I thought of doing it, which is basically concatenating several areas that run with a delay on each to get the desired animation.
--It was a bit difficult to assign the area of the effect because sometimes it didn't seem to go quite right, as there are some bugs in the animations of the magics in general, 
--even so I was able to get something and I found it very interesting to be able to play all this.



local delay = 300 -- the time between spell effect iterations

local areas = {
    {
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 1, 1, 0, 0, 0, 0},
        {1, 1, 0, 2, 0, 1, 1},
        {0, 1, 1, 0, 0, 0, 0},
        {0, 0, 1, 1, 0, 0, 0},
        {0, 0, 0, 1, 1, 0, 0},
    },
    {
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 1, 1, 1, 0, 0},
        {0, 0, 1, 0, 1, 1, 0},
        {0, 0, 0, 2, 0, 1, 0},
        {0, 0, 1, 1, 1, 1, 0},
        {0, 0, 1, 1, 1, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
    },
    {
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 1, 0, 1, 0, 0},
        {0, 1, 1, 2, 1, 1, 0},
        {0, 0, 1, 0, 1, 0, 0},
        {0, 0, 0, 0, 1, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
    },
    {
        {0, 0, 0, 1, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0},
        {0, 0, 1, 1, 1, 0, 0},
        {0, 0, 0, 2, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
    }
}

local combats = {}

for i = 1, #areas * 3 do
    function onGetFormulaValues(player, level, magiclevel)
        local min = (level / 5) + (magiclevel * 5.5) + 25
        local max = (level / 5) + (magiclevel * 11) + 50
        return -min, -max
    end
    combats[i] = Combat()
    combats[i]:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
    combats[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
    combats[i]:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")
    combats[i]:setArea(createCombatArea(areas[((i-1) % #areas) + 1]))
end

function onCastSpell(player, var)
    --Function that execute every single spell inside combats with a delay.
    local function executeSpell(combat, var, playerId)
        local player = Player(playerId)
        if player then
            combat:execute(player, var)
        end
    end

    for i = 1, #combats do -- Iterate through all the combats and execute one after the other
        addEvent(executeSpell, (delay * (i - 1)) - delay, combats[i], var, player:getId())
    end
    return true
end