local HttpService = game:GetService("HttpService")

-- API YeuMoney (1 dòng, không chia nhỏ)
local YEUMONEY_API = "https://yeumoney.com/QL_api.php?token=4a0ccb3738d1cf7b3660cbe52a249d13fd4d21e1c4f871f7a1567e28b9c14832&format=json&url=https://duchairoblox.github.io/Webkey/?ma="

-- Sinh key 7 số mới mỗi ngày (reset 00h VN)
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

-- Rút gọn link qua YeuMoney
local function shortenLink(key)
    local apiUrl = YEUMONEY_API .. tostring(key)
    local ok, res = pcall(function()
        return HttpService:GetAsync(apiUrl, true)
    end)
    if not ok then return nil, "API lỗi: " .. tostring(res) end

    local success, data = pcall(function()
        return HttpService:JSONDecode(res)
    end)
    if success and type(data) == "table" then
        -- YeuMoney trả JSON có trường short_url
        return data.short_url or data.short or data.url, nil
    end
    return nil, "Không lấy được link rút gọn"
end

-- Cập nhật key & link hôm nay
local TODAY_KEY, TODAY_DATE, SHORT_LINK
local VALID_KEYS = {}

local function updateKey(force)
    local newKey, newDate = generateDailyKey()
    if force or TODAY_DATE ~= newDate then
        TODAY_KEY, TODAY_DATE = newKey, newDate
        VALID_KEYS = {TODAY_KEY}
        local short, err = shortenLink(TODAY_KEY)
        if short then
            SHORT_LINK = short
            warn("Key hôm nay (" .. TODAY_DATE .. "): " .. TODAY_KEY)
            warn("Link rút gọn: " .. SHORT_LINK)
        else
            error("[YeuMoney] Không rút gọn được link: " .. tostring(err))
        end
    end
end

-- Lần đầu chạy
updateKey(true)

-- Auto refresh mỗi 1 phút (để qua 00h tự đổi key)
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
