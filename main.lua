-- GELİŞMİŞ VE AYARLANABİLİR TNCRMLU SCRIPTS MENÜSÜ (V2 - PRO FULL REPAIR)

if game.CoreGui:FindFirstChild("TncrmluMenu") then
    game.CoreGui.TncrmluMenu:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ContentFrame = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Name = "TncrmluMenu"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 360, 0, 480)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 85, 85) -- Kırmızı ikonik tema

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "tncrmlu scripts v2.8 (PRO)"
Title.TextColor3 = Color3.fromRGB(255, 85, 85)
Title.TextSize = 24.000

ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ContentFrame.Position = UDim2.new(0, 5, 0, 45)
ContentFrame.Size = UDim2.new(1, -10, 1, -50)
ContentFrame.CanvasSize = UDim2.new(0, 0, 4.5, 0)
ContentFrame.ScrollBarThickness = 6

UIListLayout.Parent = ContentFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

-- YARDIMCI FONKSİYONLAR
local function CreateButton(text, callback)
    local Button = Instance.new("TextButton")
    Button.Parent = ContentFrame
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Button.Size = UDim2.new(1, -10, 0, 35)
    Button.Font = Enum.Font.SourceSansBold
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 16.000
    Button.BorderSizePixel = 0
    Button.MouseButton1Click:Connect(callback)
    return Button
end

local function CreateTextBox(placeholder, callback)
    local TextBox = Instance.new("TextBox")
    TextBox.Parent = ContentFrame
    TextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TextBox.Size = UDim2.new(1, -10, 0, 35)
    TextBox.Font = Enum.Font.SourceSans
    TextBox.PlaceholderText = placeholder
    TextBox.Text = ""
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    TextBox.TextSize = 16.000
    TextBox.BorderSizePixel = 1
    TextBox.BorderColor3 = Color3.fromRGB(255, 85, 85)
    TextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then callback(TextBox.Text) end
    end)
    return TextBox
end

local function CreateLabel(text)
    local Label = Instance.new("TextLabel")
    Label.Parent = ContentFrame
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, -10, 0, 20)
    Label.Font = Enum.Font.SourceSansItalic
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 14.000
    return Label
end

-- DEĞİŞKENLER
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local InfJumpEnabled = false
local FlyEnabled = false
local FlySpeed = 50
local SavedPosition = nil
local AutoFlyTargetY = 150
local EspEnabled = false


local function getHumanoid()
    local char = LocalPlayer.Character
    if char then return char:FindFirstChildOfClass("Humanoid") end
    return nil
end

local function getRoot()
    local char = LocalPlayer.Character
    if char then return char:FindFirstChild("HumanoidRootPart") end
    return nil
end

-- --- ÖZELLİKLER ---

CreateLabel("=== ANTİ AFK & KORUMA ===")

CreateButton("Güvenli Anti-AFK Aktif Et", function()
    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0,0))
    end)
    print("Anti-AFK Aktif!")
end)

CreateLabel("=== TELEPORT (IŞINLANMA) SİSTEMİ ===")

CreateButton("Konumu Kaydet (Set Position)", function()
    local hrp = getRoot()
    if hrp then
        SavedPosition = hrp.CFrame
        print("Konum hafızaya kaydedildi!")
    end
end)

CreateButton("Kaydedilen Konuma Git (Teleport)", function()
    local hrp = getRoot()
    if hrp and SavedPosition then
        local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = SavedPosition})
        tween:Play()
    end
end)

-- ====================================================================
-- ESKİ ESP BUTONUNUN YERİNE SADECE BU BLOK GELECEK
-- ====================================================================

-- RADAR PANELİ TASARIMI (İlk çalıştırmada otomatik oluşur)
local RadarFrame = game.CoreGui:FindFirstChild("TncrmluRadar")
if RadarFrame then RadarFrame:Destroy() end

RadarFrame = Instance.new("Frame")
local RadarTitle = Instance.new("TextLabel")
local RadarContent = Instance.new("ScrollingFrame")
local RadarListLayout = Instance.new("UIListLayout")

RadarFrame.Name = "TncrmluRadar"
RadarFrame.Parent = ScreenGui
RadarFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
RadarFrame.Size = UDim2.new(0, 260, 0, 480)
RadarFrame.Visible = false
RadarFrame.BorderSizePixel = 2
RadarFrame.BorderColor3 = Color3.fromRGB(0, 170, 255)

RadarTitle.Name = "RadarTitle"
RadarTitle.Parent = RadarFrame
RadarTitle.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
RadarTitle.Size = UDim2.new(1, 0, 0, 40)
RadarTitle.Font = Enum.Font.SourceSansBold
RadarTitle.Text = "Haritadaki Aktif Petler"
RadarTitle.TextColor3 = Color3.fromRGB(0, 170, 255)
RadarTitle.TextSize = 18

RadarContent.Name = "RadarContent"
RadarContent.Parent = RadarFrame
RadarContent.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
RadarContent.Position = UDim2.new(0, 5, 0, 45)
RadarContent.Size = UDim2.new(1, -10, 1, -50)
RadarContent.CanvasSize = UDim2.new(0, 0, 5, 0)
RadarContent.ScrollBarThickness = 4

RadarListLayout.Parent = RadarContent
RadarListLayout.SortOrder = Enum.SortOrder.LayoutOrder
RadarListLayout.Padding = UDim.new(0, 5)

-- Ana menüyü sürüklediğinde yan panelin onu takip etme mekanizması
local function UpdateRadarPos()
    RadarFrame.Position = MainFrame.Position + UDim2.new(0, 370, 0, 0)
end
MainFrame:GetPropertyChangedSignal("Position"):Connect(UpdateRadarPos)
UpdateRadarPos()

-- YENİ GELİŞMİŞ ESP VE RADAR BUTONU
-- ====================================================================
-- GEREKSİZ UZAKTAKİ OBJELERİ ENGELLEYEN SÜPER HAFİF ESP BUTONU
-- ====================================================================
CreateButton("Brainrot & Yumurta ESP Aç/Kapat", function()
    EspEnabled = not EspEnabled
    RadarFrame.Visible = EspEnabled
    
    if EspEnabled then
        task.spawn(function()
            while EspEnabled do
                task.wait(0.5) -- Stabil döngü hızı
                local localHrp = getRoot()
                if not localHrp then continue end

                -- Radar listesini temizle
                for _, child in pairs(RadarContent:GetChildren()) do
                    if child:IsA("TextButton") or child:IsA("TextLabel") then 
                        child:Destroy() 
                    end
                end

                -- Hedefleri toplama
                local itemsToTrack = {}
                for _, obj in pairs(workspace:GetChildren()) do
                    if obj:IsA("Model") and (obj.Name:lower():find("brainrot") or obj.Name:lower():find("egg")) then
                        table.insert(itemsToTrack, obj)
                    end
                end
                
                local plots = workspace:FindFirstChild("Plots") or workspace:FindFirstChild("DroppedEggs")
                if plots then
                    for _, obj in pairs(plots:GetDescendants()) do
                        if obj:IsA("Model") and (obj.Name:lower():find("brainrot") or obj.Name:lower():find("egg")) then
                            table.insert(itemsToTrack, obj)
                        end
                    end
                end

                -- Mesafe filtreleme ve ekrana basma döngüsü
                for _, obj in pairs(itemsToTrack) do
                    if not obj or not obj.Parent then continue end
                    local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                    
                    if primary then
                        -- MESAFEYİ ÖNCEDEN HESAPLA
                        local distance = math.floor((localHrp.Position - primary.Position).Magnitude)
                        
                        -- CRITICAL FIX: 400 metreden uzak olan (ve o 1 milyon m ötedeki) nesneleri tamamen ENGELLE
                        if distance > 10000 then 
                            -- Eğer eski bir yazı etiketi kalmışsa onu da sil ki kasma yapmasın
                            if primary:FindFirstChild("ESPTextGui") then primary.ESPTextGui:Destroy() end
                            continue 
                        end
                        
                        -- Harita içi billboard ad etiketi
                        if not primary:FindFirstChild("ESPTextGui") then
                            local BillboardGui = Instance.new("BillboardGui", primary)
                            local TextLabel = Instance.new("TextLabel", BillboardGui)
                            
                            BillboardGui.Name = "ESPTextGui"
                            BillboardGui.AlwaysOnTop = true
                            BillboardGui.Size = UDim2.new(0, 160, 0, 40)
                            BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
                            
                            TextLabel.BackgroundTransparency = 1
                            TextLabel.Size = UDim2.new(1, 0, 1, 0)
                            TextLabel.Font = Enum.Font.SourceSansBold
                            TextLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
                            TextLabel.TextSize = 13
                            TextLabel.TextStrokeTransparency = 0
                        end
                        
                        local displayText = obj.Name .. " [" .. distance .. "m]"
                        local gui = primary:FindFirstChild("ESPTextGui")
                        if gui and gui:FindFirstChild("TextLabel") then
                            gui.TextLabel.Text = displayText
                        end
                        
                        -- RADAR PANELİ BUTONU
                        local RadarItem = Instance.new("TextButton", RadarContent)
                        RadarItem.BackgroundTransparency = 0.85
                        RadarItem.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                        RadarItem.Size = UDim2.new(1, -5, 0, 24)
                        RadarItem.Font = Enum.Font.SourceSansBold
                        RadarItem.Text = "  " .. displayText
                        RadarItem.TextColor3 = Color3.fromRGB(255, 255, 255)
                        RadarItem.TextSize = 13
                        RadarItem.TextXAlignment = Enum.TextXAlignment.Left
                        
                        -- Tıklandığında adanın dikey katına otomatik uçurma kodu
                        RadarItem.MouseButton1Click:Connect(function()
                            local currentHrp, currentHum = getRoot(), getHumanoid()
                            if currentHrp and currentHum and primary and primary.Parent then
                                local targetIslandHeight = primary.Position.Y
                                
                                local BV = currentHrp:FindFirstChild("AutoFlyBV") or Instance.new("BodyVelocity", currentHrp)
                                BV.Name = "AutoFlyBV"
                                BV.maxForce = Vector3.new(0, 9e9, 0)
                                currentHum.PlatformStand = true
                                
                                task.spawn(function()
                                    while BV and currentHrp and currentHum and primary and primary.Parent and EspEnabled do
                                        task.wait()
                                        local diffY = targetIslandHeight - currentHrp.Position.Y
                                        if math.abs(diffY) < 3 then break end
                                        BV.velocity = Vector3.new(0, diffY * 3, 0)
                                    end
                                    if BV then BV:Destroy() end
                                    currentHum.PlatformStand = false
                                end)
                            end
                        end)
                    end
                end
            end
        end)
    else
        -- ESP kapatıldığında temizleme
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "ESPTextGui" then obj:Destroy() end
        end
    end
end)
-- ====================================================================

-- ====================================================================

-- ====================================================================

        -- ESP kapatılınca her şeyi temizle

-- ====================================================================



CreateLabel("=== OTO FLY (ADA YÖNETİCİSİ) ===")

CreateTextBox("Ada Yüksekliği Girin (Örn: 250) + Enter", function(text)
    local num = tonumber(text)
    if num then AutoFlyTargetY = num end
end)

local AutoFlyActive = false
CreateButton("Oto Fly (Belirlenen Yüksekliğe Çık)", function()
    AutoFlyActive = not AutoFlyActive
    local hrp = getRoot()
    local hum = getHumanoid()
    if not hrp or not hum then return end
    
    if AutoFlyActive then
        local BV = Instance.new("BodyVelocity", hrp)
        BV.Name = "AutoFlyBV"
        BV.maxForce = Vector3.new(0, 9e9, 0)
        
        task.spawn(function()
            while AutoFlyActive and hrp and hum do
                task.wait()
                hum.PlatformStand = true
                local currentPos = hrp.Position
                local diffY = AutoFlyTargetY - currentPos.Y
                BV.velocity = Vector3.new(0, diffY * 3, 0) 
            end
            if BV then BV:Destroy() end
            hum.PlatformStand = false
        end)
    else
        AutoFlyActive = false
        local oldBV = hrp:FindFirstChild("AutoFlyBV")
        if oldBV then oldBV:Destroy() end
        hum.PlatformStand = false
    end
end)

CreateLabel("=== UÇMA & HAREKET ===")

local FlyBtn = CreateButton("Uçma Modu: KAPALI", function()
    FlyEnabled = not FlyEnabled
    local char = LocalPlayer.Character
    if not char then return end
    local Torso = char:FindFirstChild("HumanoidRootPart")
    local hum = getHumanoid()
    
    if FlyEnabled then
        _G.FlyBtnV2.Text = "Uçma Modu: AÇIK"
        _G.FlyBtnV2.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        if not Torso then return end
        
        local BG = Instance.new("BodyGyro", Torso)
        local BV = Instance.new("BodyVelocity", Torso)
        BG.P = 9e4
        BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        BG.cframe = Torso.CFrame
        BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
        
        task.spawn(function()
            while FlyEnabled and Torso and hum do
                task.wait()
                hum.PlatformStand = true
                local Camera = workspace.CurrentCamera
                BV.velocity = Camera.CFrame.LookVector * FlySpeed
            end
            if BG then BG:Destroy() end
            if BV then BV:Destroy() end
            if hum then hum.PlatformStand = false end
        end)
    else
        _G.FlyBtnV2.Text = "Uçma Modu: KAPALI"
        _G.FlyBtnV2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
end)
_G.FlyBtnV2 = FlyBtn

CreateTextBox("Uçma Hızı Yazın (Örn: 100) + Enter", function(text)
    local num = tonumber(text)
    if num then FlySpeed = num end
end)

local InfJumpBtn = CreateButton("Sonsuz Zıplama: KAPALI", function()
    InfJumpEnabled = not InfJumpEnabled
    if InfJumpEnabled then
        _G.InfJumpBtnV2.Text = "Sonsuz Zıplama: AÇIK"
        _G.InfJumpBtnV2.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        _G.InfJumpBtnV2.Text = "Sonsuz Zıplama: KAPALI"
        _G.InfJumpBtnV2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
end)
_G.InfJumpBtnV2 = InfJumpBtn

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJumpEnabled then
        local hum = getHumanoid()
        if hum then hum:ChangeState("Jumping") end
    end
end)

CreateLabel("=== HIZ & ZIPLAMA DEĞERLERİ ===")

CreateTextBox("Yürüme Hızı Yazın (Standart: 16) + Enter", function(text)
    local num = tonumber(text)
    local hum = getHumanoid()
    if num and hum then hum.WalkSpeed = num end
end)

CreateTextBox("Zıplama Gücü Yazın (Standart: 50) + Enter", function(text)
    local num = tonumber(text)
    local hum = getHumanoid()
    if num and hum then
        hum.UseJumpPower = true
        hum.JumpPower = num
    end
end)

CreateLabel("=== TNCRMLU ÖZEL EKSTRALAR ===")

CreateButton("FPS Booster / Grafikleri Optimize Et", function()
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then terrain.WaterWaveSize = 0 terrain.WaterWaveSpeed = 0 end
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("CornerWedgePart") or v:IsA("WedgePart") or v:IsA("MeshPart") then
            v.Material = Enum.Material.SmoothPlastic
        end
    end
end)
CreateButton("Tıklanan Yere Kayarak Git (Ekrana Tıkla)", function()
    local Mouse = LocalPlayer:GetMouse()
    Mouse.Button1Down:Connect(function()
        local hrp = getRoot()
        if hrp and Mouse.Target then
            local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.QuadOut)
            local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(Mouse.Hit.p + Vector3.new(0, 3, 0))})
            tween:Play()
        end
    end)
end)
