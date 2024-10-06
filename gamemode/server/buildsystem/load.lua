Builds = {}
Builds.__index = Builds

local defaultBuilds = {
    {
        name = "Corruptor",
        model = "models/player/monk.mdl",
        weapons = {
            "sfw_corruptor",
        },
    },
    {
        name = "Meteor",
        model = "models/player/combine_soldier_prisonguard.mdl",
        initialDamage = 200,
        weapons = {
            "sfw_meteor",
        },
    },
    {
        name = "Jotunn",
        model = "models/player/mossman_arctic.mdl",
        weapons = {
            "sfw_jotunn",
        },
    },
    {
        name = "Ember",
        model = "models/player/soldier_stripped.mdl",
        initialDamage = 200,
        weapons = {
            "sfw_ember"
        }
    },
    {
        name = "Eblade",
        model = "models/player/p2_chell.mdl",
        damageReduction = 0.5,
        speedMultiplier = 1.5,
        weapons = {
            "sfw_eblade",
        },
    }
}

if file.Exists("smashmod_loadouts.json", "DATA") then
    local loadedBuilds = util.JSONToTable(file.Read("smashmod_Builds.json", "DATA"))
    if type(loadedBuilds) == "table" then
        Builds.loadouts = loadedBuilds
    else
        Builds.loadouts = defaultBuilds
    end
else
    Builds.loadouts = defaultBuilds
end

-- Gets a random build
function Builds:GetRandom()
    return table.Random(self.loadouts)
end