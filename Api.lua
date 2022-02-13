-- Api.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 2022/2/12下午5:37:02
--
---@class ns
local ns = select(2, ...)

ns.LOOT_MODE = { --
    None = 0,
    Leader = 1,
    Materials = 2,
    Misc = 3,
    Delay = 4,
    Unknown = 5,
}

ns.LOOT_MODE_TEXT = {
    [ns.LOOT_MODE.None] = CANCEL,
    [ns.LOOT_MODE.Leader] = '莫老板',
    [ns.LOOT_MODE.Materials] = '宝老板',
    [ns.LOOT_MODE.Misc] = '啥也不是',
}

ns.MATERIALS = { --
    [32428] = true, -- 黑暗之心
    [32897] = true, -- 伊利达雷印记

    [32228] = true, -- 天蓝宝石
    [32231] = true, -- 焚石
    [32229] = true, -- 狮眼石
    [32249] = true, -- 海浪翡翠
    [32230] = true, -- 影歌紫玉
    [32227] = true, -- 赤尖石

    [34664] = true, -- 太阳之尘

    -- [7720] = true,
    -- [7722] = true,
    -- [7721] = true,
}

ns.LEADERS = {
    [31089] = true,
    [31091] = true,
    [31090] = true,

    [31098] = true,
    [31100] = true,
    [31099] = true,

    [31092] = true,
    [31094] = true,
    [31093] = true,

    [31097] = true,
    [31095] = true,
    [31096] = true,

    [31101] = true,
    [31103] = true,
    [31102] = true,
}
