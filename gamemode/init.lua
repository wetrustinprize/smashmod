-- CS lua files
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

local function IncludeCSDir(dir)
    dir = dir .. "/"
    local File, Directory = file.Find("smashmod/gamemode/" .. dir .. "*", "LUA")

    for k, v in ipairs(File) do
        if string.Left(v, 3) == "cl_" then
            print("[SMASH CLIENT AUTOLOAD] Client file: " .. v)
            AddCSLuaFile(dir .. v)
        end
    end

    for k, v in ipairs(Directory) do
        print("[SMASH CLIENT AUTOLOAD] Directory: " .. v)
        IncludeCSDir(dir .. v)
    end
end

IncludeCSDir("client")
-- Includes
include("server/damagesystem.lua")