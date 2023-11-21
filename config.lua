Config = {}

QBCore = exports['qb-core']:GetCoreObject()  -- uncomment if you use QBCore
-- ESX = exports["es_extended"]:getSharedObject() -- uncomment if you use ESX

Config.Settings = {
    Framework = "QB", -- QB/ESX/ST (ST - Standalone).
    Target = "OX", -- OX/QB/BT/ST (ST - None/Standalone).
    InteractKey = 38, -- Interact key used for Standalone Target.
    SpikeModel = "p_ld_stinger_s", -- model of the spikes.
    ItemName = 'spikestrips', -- Name of the item.
    RemoveItem = true, -- if the item should be removed.
    ReturnItem = true, -- if the item should be given back when picked up.
    Webhook = '', -- discord webhook used for logs.
    Blips = { -- Blips of the spikes shown on the minimap.
        Enabled = true,
        Sprite = 364,
        Color = 1,
        Scale = 0.8,
    },
}

