Builds = {}
Builds.__index = Builds

local defaultBuilds = {
    {
        name = "Gordon",
        description = "Gordon's build",
        initialDamage = 0,
        weapons = {
            "weapon_crowbar",
        },
    },
    {
        name = "Sniper",
        description = "Sniper's build",
        initialDamage = 100,
        weapons = {
            "weapon_crossbow",
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
    local build = table.Random(self.loadouts)
    return build
end