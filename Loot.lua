-- Loot.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 2022/2/12下午5:25:11
--
---@class ns
local ns = select(2, ...)

local LOOT_MODE = ns.LOOT_MODE

---@class Loot: AceAddon-3.0, AceEvent-3.0
local Loot = ns.AddOn:NewModule('Loot', 'AceEvent-3.0')
Loot:Disable()

ns.Loot = Loot

function Loot:OnInitialize()
    self.chatFilter = function(_, _, msg)
        if msg:find('战利品') then
            if msg:find('需求') or msg:find('放弃') or msg:find('贪婪') then
                return true
            end
        end
    end
end

function Loot:OnEnable()
    self.lootMode = ns.c.lootMode
    self:RegisterEvent('START_LOOT_ROLL')

    SendSystemMessage(format('|cff00fffftdGroupLoot|r: 已开始工作，模式：%s', ns.LOOT_MODE_TEXT[self.lootMode]))

    ChatFrame_AddMessageEventFilter('CHAT_MSG_LOOT', self.chatFilter)
end

function Loot:OnDisable()
    ChatFrame_RemoveMessageEventFilter('CHAT_MSG_LOOT', self.chatFilter)
    SendSystemMessage('|cff00fffftdGroupLoot|r: 已停止工作。')
end

function Loot:START_LOOT_ROLL(_, id, rollTime)
    local lootMode = self:GetItemLootMode(id)
    if not lootMode then
        return
    end

    if lootMode == LOOT_MODE.Delay then
        C_Timer.After(0.1, function()
            self:START_LOOT_ROLL(nil, id, rollTime)
        end)
        return
    end

    if lootMode == self.lootMode or lootMode == LOOT_MODE.Misc then
        local icon, name, count, quality, bop, canNeed, canGreed, canDisenchant = GetLootRollItemInfo(id)
        if bop then
            ConfirmLootRoll(id, 1)
        else
            RollOnLoot(id, 1)
        end
    elseif lootMode ~= LOOT_MODE.Unknown then
        RollOnLoot(id, 0)
    end
end

function Loot:GetItemLootMode(id)
    local icon, name, count, quality, bop, canNeed, canGreed, canDisenchant = GetLootRollItemInfo(id)
    if not name then
        return
    end

    local link = GetLootRollItemLink(id)
    if not link then
        return LOOT_MODE.Delay
    end

    local itemId = GetItemInfoFromHyperlink(link)
    if not itemId then
        return
    end

    if ns.MATERIALS[itemId] then
        return LOOT_MODE.Materials
    end

    if ns.LEADERS[itemId] then
        return LOOT_MODE.Leader
    end

    if IsEquippableItem(itemId) then
        if bop and quality >= Enum.ItemQuality.Epic then
            return LOOT_MODE.Leader
        else
            return LOOT_MODE.Misc
        end
    end

    local classId = select(12, GetItemInfo(itemId))
    if classId == Enum.ItemClass.Recipe and quality >= Enum.ItemQuality.Epic then
        return LOOT_MODE.Leader
    end

    return LOOT_MODE.Unknown
end
