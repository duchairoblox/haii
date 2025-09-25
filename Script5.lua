--// Load UI Lib
local success, UiLib = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/daucobonhi/Ui-Redz-V2/refs/heads/main/UiREDzV2.lua"))()
end)
if not success then
    warn("Không tải được UI Lib")
    return
end

--// Cấu hình Key
local VALID_KEYS = {"9997"}  -- key hôm nay
local KEY_LINK = "https://yeumoney.com/Exrfa"
local STORAGE_NAME = "HaiRoblox_KeySystem"

-- Lấy thời gian hiện tại
local function getTime()
    return os.time()
end

-- Tính thời điểm reset (6h sáng hôm nay)
local function getResetTime()
    local now = os.date("!*t", getTime())
    now.hour, now.min, now.sec = 6, 0, 0
    return os.time(now)
end

-- Lấy key lưu trong 24h
local savedData = nil
pcall(function()
    if isfile(STORAGE_NAME) then
        savedData = game:GetService("HttpService"):JSONDecode(readfile(STORAGE_NAME))
    end
end)

local function isSavedKeyValid()
    if not savedData then return false end
    if savedData.Key and table.find(VALID_KEYS, savedData.Key) then
        -- Nếu key nhập trước 6h hôm nay thì vẫn hợp lệ
        if savedData.Expire and getTime() < savedData.Expire then
            return true
        end
    end
    return false
end

-- Nếu key hợp lệ, bỏ qua nhập lại
local useSavedKey = isSavedKeyValid()

--// Tạo cửa sổ chính
local Window = MakeWindow({
    Hub = {
        Title = "Hải Roblox",
        Animation = "YT: Trung IOS"
    },
    Key = {
        KeySystem = not useSavedKey,
        Title = "Key System",
        Description = "Key reset lúc 6h sáng mỗi ngày",
        KeyLink = KEY_LINK,
        Keys = VALID_KEYS,
        Notifi = {
            Notifications = true,
            CorrectKey = "Key đúng! Mở menu...",
            Incorrectkey = "Key sai!",
            CopyKeyLink = "Đã copy link key hôm nay"
        }
    }
})

-- Nếu nhập đúng key -> lưu lại 24h hoặc đến 6h sáng
if not useSavedKey then
    hookfunction(Window.CheckKey, function(self, key)
        local ok = table.find(VALID_KEYS, key)
        if ok then
            local expireTime = getResetTime()
            if getTime() >= expireTime then
                -- Nếu đã qua 6h hôm nay thì tính đến 6h ngày mai
                expireTime = expireTime + 24 * 60 * 60
            end
            local data = {
                Key = key,
                Expire = expireTime
            }
            writefile(STORAGE_NAME, game:GetService("HttpService"):JSONEncode(data))
        end
        return ok
    end)
end

--// Đổi màu toàn bộ UI sang tím
getgenv().UiColor = Color3.fromRGB(170, 0, 255)

--// Nút thu nhỏ
MinimizeButton({
    Image = "http://www.roblox.com/asset/?id=83190276951914",
    Size = {60, 60},
    Color = Color3.fromRGB(60, 0, 100),
    Corner = true,
    Stroke = false,
    StrokeColor = Color3.fromRGB(200, 0, 255)
})

------ Tab 1: Thông Tin ------
local TabInfo = MakeTab({Name = "Thông tin"})

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

------ Tab 2: Blox Fruits ------
local TabBF = MakeTab({Name = "Blox Fruits"})

AddButton(TabBF, {
    Name = "Redz Hub ( Chưa Sẵn Sàng )",
    Callback = function()
        local Settings = {
            JoinTeam = "Pirates", -- hoặc Marines
            Translator = true
        }
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
    Name = "Min ( Tiếng Việt )",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaCrack/Min/refs/heads/main/MinXt2Vn"))()
    end
})

print("Hải Roblox GUI đã load thành công!")
