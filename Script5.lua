-- Lib giao diện
local okUi, UiLib = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/daucobonhi/Ui-Redz-V2/refs/heads/main/UiREDzV2.lua"))()
end)
if not okUi then
    warn("Không tải được UI Lib")
    return
end

local HttpService = game:GetService("HttpService")

-- === CONFIG (1 dòng API YeuMoney gộp luôn token + web) ===
local YEUMONEY_API = "https://yeumoney.com/QL_api.php?token=4a0ccb3738d1cf7b3660cbe52a249d13fd4d21e1c4f871f7a1567e28b9c14832&url=https://duchairoblox.github.io/Webkey/?ma="
-- =========================================================

-- Sinh key 7 số theo ngày (reset 00h VN)
local function generateDailyKey()
    local t = os.time()
    local vnTime = t + (7 * 60 * 60) -- GMT+7
    local dateStr = os.date("%Y-%m-%d", vnTime)
    local seed = tonumber(dateStr:gsub("%D","")) or vnTime
    math.randomseed(seed)
    for i=1,5 do math.random() end
    local key = ""
    for i=1,7 do key = key .. tostring(math.random(0,9)) end
    return key, dateStr
end

-- Gọi API YeuMoney (1 dòng url)
local function shortenWithYeuMoney(key)
    local apiUrl = YEUMONEY_API .. tostring(key)
    local ok, res = pcall(function()
        return HttpService:GetAsync(apiUrl, true)
    end)
    if ok and res and res:match("^https?://") then
        return res
    else
        warn("[YeuMoney] API fail:", res)
        return "https://duchairoblox.github.io/Webkey/?ma=" .. tostring(key)
    end
end

-- Biến toàn cục
local TODAY_KEY, TODAY_DATE, SHORT_LINK
local VALID_KEYS = {}

-- Cập nhật key + short link
local function updateKey(force)
    local newKey, newDate = generateDailyKey()
    if force or TODAY_DATE ~= newDate then
        TODAY_KEY, TODAY_DATE = newKey, newDate
        VALID_KEYS = {TODAY_KEY}
        SHORT_LINK = shortenWithYeuMoney(TODAY_KEY)
        warn("Key hôm nay:", TODAY_KEY)
        warn("Link:", SHORT_LINK)
    end
end

-- Khởi tạo lần đầu
updateKey(true)

-- Auto refresh key mỗi 60s để bắt mốc 00h
task.spawn(function()
    while task.wait(60) do
        updateKey(false)
    end
end)

-- === UI ===
local Window = MakeWindow({
    Hub = {
        Title = "Hải Roblox",
        Animation = "YT: Trung IOS"
    },
    Key = {
        KeySystem = true,
        Title = "Thông Báo",
        Description = "Lấy Key Xong Phải Lưu Lại Khi Đăng Nhập Sẽ Bắt Nhập Lại Key",
        KeyLink = SHORT_LINK,
        Keys = VALID_KEYS,
        Notifi = {
            Notifications = true,
            CorrectKey = "Key đúng! Mở menu...",
            Incorrectkey = "Key sai!",
            CopyKeyLink = "Đã copy link key hôm nay"
        }
    }
})

-- Đổi màu toàn UI
getgenv().UiColor = Color3.fromRGB(255, 255, 255)

-- Nút thu nhỏ
MinimizeButton({
    Image = "https://anhsieuviet.com/image/atxniO",
    Size = {60, 60},
    Color = Color3.fromRGB(255, 255, 255),
    Corner = true,
    Stroke = false,
    StrokeColor = Color3.fromRGB(255, 255, 255)
})

------ Tab 1: Thông Tin ------
local TabInfo = MakeTab({Name = "Thông tin"})

AddButton(TabInfo, {
    Name = "Copy link lấy Key",
    Callback = function()
        updateKey(false)
        if setclipboard and SHORT_LINK then
            setclipboard(SHORT_LINK)
        end
        Notify({Title="Hải Roblox", Text="Đã copy link key hôm nay!", Duration=3})
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

------ Tab 2: Blox Fruits ------
local TabBF = MakeTab({Name = "Blox Fruits"})

AddButton(TabBF, {
    Name = "Redz Hub ( Chưa Sẵn Sàng )",
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
    Name = "Min ( Tiếng Việt )",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaCrack/Min/refs/heads/main/MinXt2Vn"))()
    end
})
