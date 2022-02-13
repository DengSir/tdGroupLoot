-- ConfirmFrame.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 2022/2/13下午4:18:46
--
---@class ns
local ns = select(2, ...)

---@class ConfirmFrame: Object, Frame
---@field buttons Button[]
local ConfirmFrame = ns.AddOn:NewClass('ConfirmFrame', 'Frame')

ns.ConfirmFrame = ConfirmFrame

function ConfirmFrame:Constructor()
    local function OnClick(button)
        self:Fire('OnSelect', button:GetID())
    end

    for _, button in ipairs(self.buttons) do
        button:SetText(ns.LOOT_MODE_TEXT[button:GetID()])
        button:SetScript('OnClick', OnClick)
    end

    self.Title:SetText('选择拾取模式')
end
