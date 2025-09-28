-- Lib giao diện
local okUi, UiLib = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/daucobonhi/Ui-Redz-V2/refs/heads/main/UiREDzV2.lua"))()
end)
if not okUi then
    warn("Không tải được UI Lib")
    return
end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- === CONFIG ===
local LINK2M_API = "https://link2m.net/api-shorten/v2?api=6871d8e496904b549a1b4578&url="
local WEB_SHOW_KEY = "https://duchairoblox.github.io/Webkey/"
-- ==============

-- Hàm sinh key riêng cho user
local function generateUserKey(userId)
    local day = tonumber(os.date("%d")) -- ngày hiện tại
    local calc = (userId * day) - 12666
    local key = "realxmod" .. tostring(calc)
    return key
end

-- Gọi API Link2m rút gọn link
local function shortenLink(key)
    local target = WEB_SHOW_KEY .. "?ma=" .. key
    local apiUrl = LINK2M_API .. HttpService:UrlEncode(target)
    local ok, res = pcall(function()
        return HttpService:GetAsync(apiUrl, true)
    end)
    if not ok then
        warn("[Link2m] HTTP lỗi:", res)
        return target
    end

    local parsed
    local success = pcall(function()
        parsed = HttpService:JSONDecode(res)
    end)
    if success and parsed and parsed["shortenedUrl"] then
        return parsed["shortenedUrl"]
    else
        warn("[Link2m] API trả về:", res)
        return target
    end
end

-- Lấy UserId của người chơi local
local player = Players.LocalPlayer
local userId = player and player.UserId or 0

-- Tạo key và link khi cần
local function getKeyAndLink()
    local key = generateUserKey(userId)
    local link = shortenLink(key)
    return key, link
end

-- === UI ===
local Window = MakeWindow({
    Hub = {
        Title = "Hải Roblox",
        Animation = "YT: Trung IOS"
    },
    Key = {
        KeySystem = false, -- tắt KeySystem cũ, vì giờ key tạo riêng
        Title = "Lấy Key",
        Description = "Ấn nút để nhận key hôm nay",
        KeyLink = "",
        Keys = {},
        Notifi = {
            Notifications = true
        }
    }
})

-- Đổi màu toàn UI
getgenv().UiColor = Color3.fromRGB(255, 255, 255)

-- Tab Thông tin
local TabInfo = MakeTab({Name = "Thông tin"})

AddButton(TabInfo, {
    Name = "Lấy Key Hôm Nay",
    Callback = function()
        local key, link = getKeyAndLink()
        if setclipboard and link then
            setclipboard(link)
        end
        Notify({
            Title = "Hải Roblox",
            Text = "Key: " .. key .. "\nLink: " .. link .. "\nĐã copy link vào clipboard!",
            Duration = 6
        })
    end
})

AddButton(TabInfo, {
    Name = "Discord",
    Callback = function()
        setclipboard("https://t.me/nhanlinkduchai_bot")
        Notify({Title="Hải Roblox", Text="Đã copy link Telegram!", Duration=3})
    end
})

AddButton(TabInfo, {
    Name = "Youtuber",
    Callback = function()
        setclipboard("https://www.youtube.com/@VirtuousOcean")
        Notify({Title="Hải Roblox", Text="Đã copy kênh Youtube!", Duration=3})
    end
})

-- Tab Blox Fruits
local TabBF = MakeTab({Name = "Blox Fruits"})

AddButton(TabBF, {
    Name = "Redz Hub (Chưa sẵn sàng)",
    Callback = function()
        local Settings = {JoinTeam = "Pirates", Translator = true}
        loadstring(game:HttpGet("https://raw.githubusercontent.com/realredz/BloxFruits/refs/heads/main/Source.lua"))(Settings)
    end
})

AddButton(TabBF, {
    Name = "w-azure Hub",
    Callback = function()
        loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/85e904ae1ff30824c1aa007fc7324f8f.lua"))()
    end
})

AddButton(TabBF, {
    Name = "Min (Tiếng Việt)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaCrack/Min/refs/heads/main/MinXt2Vn"))()
    end
})
