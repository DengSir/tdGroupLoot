-- Addon.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 2022/2/12下午5:13:18
--
---@class ns
local ns = select(2, ...)

---@class Addon: AceAddon-3.0, AceEvent-3.0, LibClass-2.0
local Addon = LibStub('AceAddon-3.0'):NewAddon('tdGroupLoot', 'AceEvent-3.0', 'LibClass-2.0')
ns.AddOn = Addon

function Addon:OnInitialize()
    -- self.db = LibStub('AceDB-3.0'):New('TDDB_GROUPLOOT', {}, true)

    TDCACHE_GROUPLOOT = TDCACHE_GROUPLOOT or {}
    ns.c = TDCACHE_GROUPLOOT
end

function Addon:OnEnable()
    self:RegisterEvent('GROUP_ROSTER_UPDATE', 'Check')
    self:RegisterEvent('PARTY_LOOT_METHOD_CHANGED', 'Check')
    self:RegisterEvent('ZONE_CHANGED_NEW_AREA', 'Check')

    C_Timer.After(5, function()
        self:Check()
    end)
end

function Addon:GROUP_ROSTER_UPDATE()
    if not IsInRaid(LE_PARTY_CATEGORY_HOME) then
        self.comfirmed = nil
    end
end

function Addon:Check()
    local allow = self:IsAllow()
    if allow then
        if ns.Loot:IsEnabled() then
            return
        end

        if not ns.c.lootMode then
            if not self.ComfirmFrame then
                local Frame = ns.ConfirmFrame:Bind(
                                  CreateFrame('Frame', nil, UIParent, 'tdGroupLootConfirmFrameTemplate'))
                Frame:SetCallback('OnSelect', function(_, lootMode)
                    if lootMode == 0 then
                        ns.c.lootMode = nil
                        self:DisableModule('Loot')
                    else
                        ns.c.lootMode = lootMode
                        self:EnableModule('Loot')
                    end
                    self.ComfirmFrame:Hide()
                end)

                self.ComfirmFrame = Frame
            end
            self.ComfirmFrame:Show()
        else
            self:EnableModule('Loot')
        end
    else
        ns.c.lootMode = nil
        self:DisableModule('Loot')
    end
end

function Addon:IsAllow()
    local name, instanceType = GetInstanceInfo()
    if instanceType ~= 'raid' then
        return false
    end

    local lootMethod = GetLootMethod()
    if lootMethod ~= 'group' then
        return false
    end

    if not IsInRaid(LE_PARTY_CATEGORY_HOME) then
        return false
    end
    return true
end
