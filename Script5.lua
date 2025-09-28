-- FULL: Script tạo key hằng ngày + rút gọn bằng Link4m + hiển thị menu (UI Lib)
local HttpService = game:GetService("HttpService")

-- Load UI lib (nếu không tải được sẽ dừng)
local okUi, UiLib = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/daucobonhi/Ui-Redz-V2/refs/heads/main/UiREDzV2.lua"))()
end)
if not okUi then
    warn("Không tải được UI Lib, dừng script.")
    return
end

-- === CONFIG (Link4m 1 dòng) ===
--注意: phần &url= cuối cùng để nối key-target url (không có khoảng trắng)
local LINK4M_API = "https://link4m.co/st?api=68d8dcd0c12fb80f470dc5dc&url="          -- <- 1 dòng như bạn yêu cầu
local WEB_SHOW_KEY = "https://duchairoblox.github.io/Webkey/"                       -- trang hiển thị key của bạn
-- ==============================

-- Sinh key 7 chữ số theo ngày (reset 00:00 giờ VN)
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

-- Build target url (web hiển thị key) kèm param ?ma=
local function buildTargetUrl(key)
    local base = WEB_SHOW_KEY
    -- ensure trailing slash for consistency (optional)
    if string.sub(base, -1) ~= "/" then base = base .. "/" end
    return base .. "?ma=" .. tostring(key)
end

-- Gọi Link4m API (1 dòng base) để rút gọn link
local function shortenWithLink4m(targetUrl)
    -- UrlEncode targetUrl khi nối
    local encoded = HttpService:UrlEncode(targetUrl)
    local apiUrl = LINK4M_API .. encoded
    local ok, res = pcall(function()
        -- true để bypass cache
        return HttpService:GetAsync(apiUrl, true)
    end)
    if not ok then
        return nil, "HTTP lỗi: "..tostring(res)
    end

    local body = tostring(res)

    -- link4m theo mẫu có thể trả plain text short url (ví dụ https://link4m.co/xxxxx)
    if body:match("^https?://") then
        return body, nil
    end

    -- try parse JSON in case the service returns JSON
    local parseOk, parsed = pcall(function() return HttpService:JSONDecode(body) end)
    if parseOk and type(parsed) == "table" then
        -- tìm các trường khả nghi
        for _,k in ipairs({"short","short_url","shortlink","url","link","result"}) do
            if parsed[k] and tostring(parsed[k]):match("^https?://") then
                return tostring(parsed[k]), nil
            end
        end
        -- scan nested for any url-like value
        local function scan(t)
            for kk,vv in pairs(t) do
                if type(vv) == "string" and vv:match("^https?://") then return vv end
                if type(vv) == "table" then
                    local nested = scan(vv)
                    if nested then return nested end
                end
            end
            return nil
        end
        local found = scan(parsed)
        if found then return found, nil end
    end

    return nil, "Response không chứa short url: "..body
end

-- GLOBAL state
local TODAY_KEY, TODAY_DATE, SHORT_LINK
local VALID_KEYS = {}

-- Cập nhật key + link (force = true để ép tạo/rút gọn lại)
local function updateKeyAndLink(force)
    force = force or false
    local newKey, newDate = generateDailyKey()
    if not force and TODAY_DATE == newDate and SHORT_LINK then
        return true -- đã là hôm nay, không cần làm gì
    end

    TODAY_KEY, TODAY_DATE = newKey, newDate
    VALID_KEYS = {TODAY_KEY}
    local target = buildTargetUrl(TODAY_KEY)
    local short, err = shortenWithLink4m(target)
    if short then
        SHORT_LINK = short
        warn("[Link4m] Short link: "..SHORT_LINK)
        return true, SHORT_LINK
    else
        -- fallback về web gốc (vẫn hoạt động)
        SHORT_LINK = target
        warn("[Link4m] Rút gọn thất bại: "..tostring(err)..". Dùng fallback: "..SHORT_LINK)
        return false, SHORT_LINK
    end
end

-- Run lần đầu trước khi tạo menu (quan trọng: phải có LINK để UI hiển thị)
local ok, resultOrLink = pcall(function() return updateKeyAndLink(true) end)
if not ok then
    warn("Lỗi khi khởi tạo key/link: "..tostring(resultOrLink))
    -- nếu lỗi nghiêm trọng thì dừng
    return
end

-- TẠO MENU SAU KHI CÓ LINK
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

-- UI color
getgenv().UiColor = Color3.fromRGB(255,255,255)

-- Minimize button (giữ nguyên)
MinimizeButton({
    Image = "https://anhsieuviet.com/image/atxniO",
    Size = {60, 60},
    Color = Color3.fromRGB(255, 255, 255),
    Corner = true,
    Stroke = false,
    StrokeColor = Color3.fromRGB(255, 255, 255)
})

-- Tabs
local TabInfo = MakeTab({Name = "Thông tin"})
local TabBF = MakeTab({Name = "Blox Fruits"})

-- Nút copy link lấy key (sẽ cập nhật lại link nếu cần)
AddButton(TabInfo, {
    Name = "Copy link lấy Key",
    Callback = function()
        -- đảm bảo link là mới nhất
        local ok, link = updateKeyAndLink(false)
        -- nếu updateKeyAndLink trả về boolean+link, chúng ta lấy SHORT_LINK
        if setclipboard and SHORT_LINK then
            setclipboard(SHORT_LINK)
        end
        Notify({Title="Hải Roblox", Text="Đã copy link key: "..tostring(SHORT_LINK), Duration=4})
    end
})

-- Nút force refresh (rút gọn lại, dùng khi token đổi hoặc muốn tạo link mới)
AddButton(TabInfo, {
    Name = "Refresh/Create short link (force)",
    Callback = function()
        local success, linkOrMsg = updateKeyAndLink(true)
        if SHORT_LINK then
            if setclipboard then setclipboard(SHORT_LINK) end
            Notify({Title="Hải Roblox", Text="Link mới: "..tostring(SHORT_LINK), Duration=4})
        else
            Notify({Title="Hải Roblox", Text="Không tạo được link.", Duration=4})
        end
    end
})

-- Thông tin khác
AddButton(TabInfo, {
    Name = "Discord",
    Callback = function()
        if setclipboard then setclipboard("https://t.me/nhanlinkduchai_bot") end
        Notify({Title="Hải Roblox", Text="Đã copy link Telegram!", Duration=3})
    end
})
AddButton(TabInfo, {
    Name = "Youtuber",
    Callback = function()
        if setclipboard then setclipboard("https://www.youtube.com/@VirtuousOcean") end
        Notify({Title="Hải Roblox", Text="Đã copy kênh Youtube!", Duration=3})
    end
})

-- Blox Fruits buttons (giữ nguyên)
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

-- Auto refresh background: kiểm tra mỗi 60s để bắt qua 00:00 VN
task.spawn(function()
    while true do
        task.wait(60)
        local ok, _ = pcall(updateKeyAndLink, false)
        if ok then
            -- nếu SHORT_LINK thay đổi, bạn có thể notify người dùng (tuỳ ý)
            -- Notify({Title="Hải Roblox", Text="Key/Link được cập nhật tự động.", Duration=3})
        end
    end
end)
