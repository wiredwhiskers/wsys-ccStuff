local sound = arg[1]
local volume = tonumber(arg[2]) or 1
local pitch = tonumber(arg[3]) or 1
local speaker = peripheral.find("speaker")
local instruments = {"harp", "basedrum", "snare", "hat", "bass", "flute", "bell", "guitar", "chime", "xylophone", "iron_xylophone", "cow_bell", "didgeridoo", "bit", "banjo", "pling"}

speaker.playSound(sound,volume,pitch) 
