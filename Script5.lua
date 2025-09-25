-- Tải lib
local success, UiLib = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/daucobonhi/Ui-Redz-V2/refs/heads/main/UiREDzV2.lua"))()
end)

if not success then
    warn("Không tải được UI Lib")
    return
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Intro GUI
local gui = Instance.new("ScreenGui")
gui.Name = "HaiRobloxIntro"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local msg = Instance.new("TextLabel")
msg.Parent = gui
msg.AnchorPoint = Vector2.new(0.5,0.5)
msg.Position = UDim2.new(0.5,0,0.5,0)
msg.Size = UDim2.new(0,600,0,120)
msg.BackgroundTransparency = 1
msg.Text = " Hải Roblox "
msg.TextColor3 = Color3.fromRGB(0,255,255)
msg.Font = Enum.Font.GothamBlack
msg.TextScaled = true
msg.TextStrokeTransparency = 0
msg.TextStrokeColor3 = Color3.fromRGB(0,0,0)
msg.TextTransparency = 1

-- Firework function
local function createFirework()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = false
    part.Size = Vector3.new(0.5,0.5,0.5)
    part.Position = player.Character.HumanoidRootPart.Position + Vector3.new(math.random(-10,10),math.random(5,15),math.random(-10,10))
    part.Transparency = 1
    part.Parent = workspace

    local firework = Instance.new("ParticleEmitter")
    firework.Texture = "rbxassetid://243660364"
    firework.Rate = 50
    firework.Lifetime = NumberRange.new(1)
    firework.Speed = NumberRange.new(10)
    firework.SpreadAngle = Vector2.new(360,360)
    firework.Color = ColorSequence.new(Color3.fromRGB(math.random(100,255),math.random(100,255),math.random(100,255)))
    firework.Parent = part

    game.Debris:AddItem(part,2)
end

-- Show text
local appear = TweenService:Create(msg, TweenInfo.new(1.5, Enum.EasingStyle.Quad), {TextTransparency=0})
appear:Play()
appear.Completed:Wait()

-- Loạn màu + firework
local startTime = tick()
while tick()-startTime < 5 do
    msg.TextColor3 = Color3.fromRGB(math.random(0,255),math.random(180,255),math.random(200,255))
    createFirework()
    task.wait(0.25) -- nhanh hơn để loạn màu
end

-- Hide text
local vanish = TweenService:Create(msg, TweenInfo.new(2, Enum.EasingStyle.Sine), {TextTransparency=1})
vanish:Play()
vanish.Completed:Wait()
gui:Destroy()

-- Main UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local ImageButton = Instance.new("ImageButton")
ImageButton.Parent = ScreenGui
ImageButton.BackgroundColor3 = Color3.fromRGB(0,0,0)
ImageButton.BorderSizePixel = 0
ImageButton.Position = UDim2.new(0.1,0,0.15,0)
ImageButton.Size = UDim2.new(0,40,0,40)
ImageButton.Draggable = true
ImageButton.Image = "http://www.roblox.com/asset/?id=124682499503385"

local UICorner = Instance.new("UICorner")
UICorner.Parent = ImageButton
UICorner.CornerRadius = UDim.new(1,10)

ImageButton.MouseButton1Down:Connect(function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true,Enum.KeyCode.End,false,game)
end)

-- Load Fluent
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
repeat task.wait() until game:IsLoaded()
local Window = Fluent:CreateWindow({
    Title="VTD Roblox 2.4.9",
    SubTitle="Blox Fruit",
    TabWidth=157,
    Size=UDim2.fromOffset(450,300),
    Acrylic=true,
    Theme="Light",
    MinimizeKey=Enum.KeyCode.End
})

local Tabs = {
    Main0=Window:AddTab({Title="Thông Tin"}),
    Main1=Window:AddTab({Title="Script Blox fruit"}),
    Main2=Window:AddTab({Title="Grow A Garden"}),
    Main3=Window:AddTab({Title="99 đêm"}),
    Main4=Window:AddTab({Title="ink game"}),
    Main5=Window:AddTab({Title="Script của Yuta"}),
    Main6=Window:AddTab({Title="Fisch"}),
    Main7=Window:AddTab({Title="Dead Rails"}),
}

-- Tab 0
Tabs.Main0:AddButton({Title="Discord",Description="Hai Roblox Community",Callback=function() setclipboard("https://t.me/nhanlinkduchai_bot") end})
Tabs.Main0:AddButton({Title="Youtuber",Description="Trung IOS",Callback=function() setclipboard("https://www.youtube.com/@VirtuousOcean") end})

-- Tab 1
Tabs.Main1:AddButton({Title="Redz Hub",Callback=function()
    local Settings={JoinTeam="Pirates",Translator=true}
    loadstring(game:HttpGet("https://raw.githubusercontent.com/newredz/BloxFruits/refs/heads/main/Source.luau"))(Settings)
end})

Tabs.Main1:AddButton({Title="w-azure Hub",Callback=function()
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/85e904ae1ff30824c1aa007fc7324f8f.lua"))()
end})

Tabs.Main1:AddButton({Title="fix lag",Callback=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/TurboLite/Script/main/FixLag.lua"))()
end})

-- Tab 2
Tabs.Main2:AddButton({Title="nat hub",Callback=function()
    loadstring(game:HttpGet("https://get.nathub.xyz/loader"))()
end})

-- Tab 5: Nhà tù
Tabs.Main5:AddButton({Title="Nhà tù",Description="Nhà siêu to khổng lồ",Callback=function()
    local Workspace=game:GetService("Workspace")
    local player=game.Players.LocalPlayer
    local char=player.Character or player.CharacterAdded:Wait()
    local hrp=char:WaitForChild("HumanoidRootPart")

    local function createPart(size,pos,color,anchored,parent)
        local p=Instance.new("Part")
        p.Size=size
        p.Position=pos
        p.Anchored=anchored
        p.BrickColor=BrickColor.new(color)
        p.Parent=parent
        return p
    end

    local house=Instance.new("Model")
    house.Name="GiantHouse"
    house.Parent=Workspace

    local hw,hd,hh=50,50,30
    createPart(Vector3.new(hw,1,hd),hrp.Position+Vector3.new(0,-0.5,0),"Earth green",true,house)
    createPart(Vector3.new(1,hh,hd),hrp.Position+Vector3.new(-hw/2,hh/2,0),"Reddish brown",true,house)
    createPart(Vector3.new(1,hh,hd),hrp.Position+Vector3.new(hw/2,hh/2,0),"Reddish brown",true,house)
    createPart(Vector3.new(hw,hh,1),hrp.Position+Vector3.new(0,hh/2,-hd/2),"Reddish brown",true,house)
    createPart(Vector3.new(hw,hh,1),hrp.Position+Vector3.new(0,hh/2,hd/2),"Reddish brown",true,house)
    createPart(Vector3.new(hw+2,1,hd+2),hrp.Position+Vector3.new(0,hh+0.5,0),"Medium stone grey",true,house)
    local door=createPart(Vector3.new(6,10,1),hrp.Position+Vector3.new(0,5,-hd/2),"Brown",true,house)
    door.Transparency=0.5
    door.CanCollide=false
end})

-- Tab 6: Fisch
Tabs.Main6:AddButton({Title="Speed Hub X",Callback=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua",true))()
end})

Tabs.Main6:AddButton({Title="Solix v2 Loader",Callback=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/debunked69/solixloader/refs/heads/main/solix%20v2%20new%20loader.lua"))()
end})

Tabs.Main6:AddButton({Title="Lunor Loader",Callback=function()
    loadstring(game:HttpGet("https://lunor.dev/loader"))()
end})

Tabs.Main6:AddButton({Title="Luarmor Loader",Callback=function()
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/672a0ae340e8ce7e21a51e37c6bf0cc1.lua"))()
end})

-- Tab 7: Dead Rails
Tabs.Main7:AddButton({Title="SpeedHubX",Callback=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua",true))()
end})

Tabs.Main7:AddButton({Title="NatHub",Callback=function()
    loadstring(game:HttpGet("https://get.nathub.xyz/loader"))()
end})

Tabs.Main7:AddButton({Title="SolixHub",Callback=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/debunked69/solixloader/refs/heads/main/solix%20v2%20new%20loader.lua"))()
end})

Tabs.Main7:AddButton({Title="Trung tâm Beecon",Callback=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/BaconBossScript/BeeconHub/main/BeeconHub"))()
end})
-- Tab 3: 99 đêm
Tabs.Main3:AddButton({Title="Demo 99 đêm", Description="Chạy thử tính năng 99 đêm", Callback=function()
    print("Tính năng 99 đêm chưa được triển khai.")
end})

-- Tab 4: ink game
Tabs.Main4:AddButton({Title="Demo Ink Game", Description="Chạy thử Ink Game", Callback=function()
    print("Ink Game chưa có script.")
end})

-- Tab 5: Script của Yuta (tiện ích bổ sung)
Tabs.Main5:AddButton({Title="Teleport về spawn", Description="Di chuyển nhanh về spawn", Callback=function()
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,5,0))
    end
end})

Tabs.Main5:AddButton({Title="Xóa tất cả vật thể", Description="Dọn sạch Workspace", Callback=function()
    for i,v in pairs(game.Workspace:GetChildren()) do
        if not v:IsA("Terrain") and v.Name ~= "GiantHouse" then
            v:Destroy()
        end
    end
end})

-- Tab 7: Dead Rails (bổ sung)
Tabs.Main7:AddButton({Title="Beecon + SpeedHub Combo", Description="Chạy Beecon và SpeedHub cùng lúc", Callback=function()
    -- Load Beecon
    loadstring(game:HttpGet("https://raw.githubusercontent.com/BaconBossScript/BeeconHub/main/BeeconHub"))()
    -- Load SpeedHub
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua",true))()
end})

-- Tab 7: thêm nút khác
Tabs.Main7:AddButton({Title="Reset Player", Description="Reset lại nhân vật", Callback=function()
    local player = game.Players.LocalPlayer
    if player.Character then
        player.Character:BreakJoints()
    end
end})

-- Tab 5: Script của Yuta (thêm nút build)
Tabs.Main5:AddButton({Title="Tạo Platform lớn", Description="Tạo platform dưới chân bạn", Callback=function()
    local player = game.Players.LocalPlayer
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local part = Instance.new("Part")
        part.Size = Vector3.new(50,1,50)
        part.Position = hrp.Position - Vector3.new(0,3,0)
        part.Anchored = true
        part.BrickColor = BrickColor.new("Really black")
        part.Parent = game.Workspace
    end
end})

print("VTD Roblox GUI loaded successfully!")
-- Tab 1: Script Blox Fruit
Tabs.Main1:AddButton({Title="Redz Hub", Callback=function()
    local Settings={JoinTeam="Pirates", Translator=true}
    loadstring(game:HttpGet("https://raw.githubusercontent.com/newredz/BloxFruits/refs/heads/main/Source.luau"))(Settings)
end})

Tabs.Main1:AddButton({Title="w-azure Hub", Callback=function()
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/85e904ae1ff30824c1aa007fc7324f8f.lua"))()
end})

Tabs.Main1:AddButton({Title="fix lag", Callback=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/TurboLite/Script/main/FixLag.lua"))()
end})

Tabs.Main1:AddButton({Title="xero", Callback=function()
    getgenv().Team="Marines"
    getgenv().Hide_Menu=false
    getgenv().Auto_Execute=false
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Xero2409/XeroHub/refs/heads/main/main.lua"))()
end})

Tabs.Main1:AddButton({Title="hiru hub", Callback=function()
    repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
    loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaStupid/ExecuteGames/main/QuestGames.lua"))()
end})

Tabs.Main1:AddButton({Title="banana hub free", Callback=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/kimprobloxdz/Banana-Free/refs/heads/main/Protected_5609200582002947.lua.txt"))()
end})

Tabs.Main1:AddButton({Title="speed hub", Callback=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
end})

Tabs.Main1:AddButton({Title="script taro", Callback=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/gumanba/Scripts/main/GrowaGarden"))()
end})

-- Tab 2: Grow A Garden
Tabs.Main2:AddButton({Title="nat hub", Callback=function()
    loadstring(game:HttpGet("https://get.nathub.xyz/loader"))()
end})

Tabs.Main2:AddButton({Title="cutay hub", Callback=function()
    loadstring(game:HttpGet('https://github.com/diemquy/CutTayHub/blob/main/Cuttayhubreal.lua'))()
end})

Tabs.Main2:AddButton({Title="limid hub", Callback=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/PanjuII/LimitHub/refs/heads/main/LimitHub_Luarmor_E.lua"))()
end})

Tabs.Main2:AddButton({Title="script no lag", Callback=function()
    loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/NoLag-id/No-Lag-HUB/refs/heads/main/Loader/LoaderV1.lua"))()
end})

Tabs.Main2:AddButton({Title="script ảo", Callback=function()
    loadstring(game:HttpGet("https://pastefy.app/XgLKMqtd/raw"))()
end})

Tabs.Main2:AddButton({Title="SolixHub", Callback=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/debunked69/solixloader/refs/heads/main/solix%20v2%20new%20loader.lua"))()
end})

Tabs.Main2:AddButton({Title="Speed Hub X", Callback=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
end})

Tabs.Main2:AddButton({Title="Beecon Hub", Callback=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/BaconBossScript/BeeconHub/main/BeeconHub"))()
end})
-- Tab 3: 99 Đêm Trong Rừng
Tabs.Main3:AddButton({Title="99NDR AutoFarm", Callback=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/duonggiahuy/99NDR/main/AutoFarm.lua"))()
end})

Tabs.Main3:AddButton({Title="99NDR Hub V2", Callback=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Script999D/99NDRhub/main/Loader.lua"))()
end})

Tabs.Main3:AddButton({Title="99NDR Boss Farm", Callback=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/duonggiahuy/99NDR/main/BossFarm.lua"))()
end})

Tabs.Main3:AddButton({Title="99NDR Kill Aura", Callback=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/duonggiahuy/99NDR/main/KillAura.lua"))()
end})

Tabs.Main3:AddButton({Title="99NDR All-in-One", Callback=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/duonggiahuy/99NDR/main/AllInOne.lua"))()
end})

-- Tab 4: Ink Game
Tabs.Main4:AddButton({Title="Ink Hub V1", Callback=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/InkHubDev/InkHub/main/Loader.lua"))()
end})

Tabs.Main4:AddButton({Title="Ink Game AutoFarm", Callback=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/InkHubDev/InkHub/main/AutoFarm.lua"))()
end})

Tabs.Main4:AddButton({Title="Ink Game Boss Hub", Callback=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/InkHubDev/InkHub/main/Boss.lua"))()
end})

Tabs.Main4:AddButton({Title="Ink Game Misc", Callback=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/InkHubDev/InkHub/main/Misc.lua"))()
end})

Tabs.Main4:AddButton({Title="Ink Game Full Hub", Callback=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/InkHubDev/InkHub/main/InkFullHub.lua"))()
end})
Tabs.Main1:AddButton({
    Title="astral Hub VN",
    Description="Bản mới nhất Tiếng Việt ✅",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Overgustx2/Main/refs/heads/main/BloxFruits_25.html"))()
    end
})

Tabs.Main1:AddButton({
    Title="MinXt2Vn",
    Description="Tiếng Việt ✅",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaCrack/Min/refs/heads/main/MinXt2Vn"))()
    end
})
Tabs.Main1:AddButton({
    Title="BlueX Hub",
    Description="Blox Fruit Hub ✅",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Dev-BlueX/BlueX-Hub/refs/heads/main/Main.lua"))()
    end
})

-- Tạo cửa sổ
local Window = MakeWindow({
    Hub = {
        Title = "HaiRoblox",
        Animation = "Youtube:Trung IOS"
    },
    Key = {KeySystem = false} -- để false thì menu mới hiện ngay
})

-- Nút thu nhỏ
MinimizeButton({
    Image = "http://www.roblox.com/asset/?id=83190276951914",
    Size = {60, 60},
    Color = Color3.fromRGB(10, 10, 10),
    Corner = true,
    Stroke = false,
    StrokeColor = Color3.fromRGB(255, 0, 0)
})

------ Tab Farm ------
local TabFarm = MakeTab({Name = "Script Farm"})

AddButton(TabFarm, {
    Name = "Redz Hub",
    Callback = function()
        local Settings = {
            JoinTeam = "Pirates",
            Translator = true,
        }
        loadstring(game:HttpGet("https://raw.githubusercontent.com/realredz/BloxFruits/refs/heads/main/Source.lua"))(Settings)
    end
})

------ Tab Key ------
local VALID_KEYS = {"9997"}
local KEY_LINK = "https://yeumoney.com/Exrfa"
local savedKey

local TabKey = MakeTab({Name = "Key"})

AddTextbox(TabKey, {
    Name = "Nhập Key",
    Default = "",
    PlaceholderText = "Nhập key tại đây...",
    ClearTextOnFocus = false,
    Callback = function(value)
        _G.InputKey = value
    end
})

AddButton(TabKey, {
    Name = "Nhập Key",
    Callback = function()
        if table.find(VALID_KEYS, _G.InputKey) then
            savedKey = _G.InputKey
            Notify({Title="Key System", Text="Key đúng, lưu trong 24h!", Duration=3})
        else
            Notify({Title="Key System", Text="Key sai!", Duration=3})
        end
    end
})

AddButton(TabKey, {
    Name = "Get Key",
    Callback = function()
        setclipboard(KEY_LINK)
        Notify({Title="Key System", Text="Đã copy link key hôm nay", Duration=3})
    end
})