Builds = {}
Builds.__index = Builds

local defaultBuilds = {
    {
        name = "Hellvolver",
        model = "models/player/monk.mdl",
        initialDamage = 0,
        weapons = {
            "sfw_corruptor",
        },
    },
    {
        name = "Goobber",
        model = "models/player/soldier_stripped.mdl",
        initialDamage = 100,
        weapons = {
            "sfw_acidrain",
        },
    },
    {
        name = "Froozen",
        model = "models/player/mossman_arctic.mdl",
        initialDamage = 200,
        weapons = {
            "sfw_jotunn",
        },
    },
    {
        name = "Brawler",
        model = "models/player/p2_chell.mdl",
        initialDamage = 0,
        weapons = {
            "sfw_phasma",
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