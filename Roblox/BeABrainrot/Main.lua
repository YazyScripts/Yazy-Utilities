-- ============================================================
--  YAZY UTILITIES  |  Premium Script  |  PC
--  By Yazy  |  All Rights Reserved
-- ============================================================

local TweenService      = game:GetService("TweenService")
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService   = game:GetService("TeleportService")

local player = Players.LocalPlayer

-- ============================================================
--  UTILIDADES
-- ============================================================

local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local function tween(obj, info, props)
    TweenService:Create(obj, info, props):Play()
end

-- ============================================================
--  CORES & ESTILO  (tema branco com detalhes pretos)
-- ============================================================

local C = {
    bg        = Color3.fromRGB(255, 255, 255),
    bg2       = Color3.fromRGB(240, 240, 245),
    bg3       = Color3.fromRGB(228, 228, 235),
    panel     = Color3.fromRGB(248, 248, 252),
    border    = Color3.fromRGB(30,  30,  30),
    text      = Color3.fromRGB(15,  15,  15),
    subtext   = Color3.fromRGB(90,  90, 100),
    cyan      = Color3.fromRGB(0,  180, 200),
    pink      = Color3.fromRGB(200,   0, 160),
    purple    = Color3.fromRGB(120,   0, 220),
    green     = Color3.fromRGB(0,  170,  90),
    yellow    = Color3.fromRGB(200, 160,   0),
    orange    = Color3.fromRGB(210, 100,   0),
    red       = Color3.fromRGB(210,  30,  30),
    white     = Color3.fromRGB(255, 255, 255),
    dim       = Color3.fromRGB(160, 160, 180),
    disabled  = Color3.fromRGB(210, 210, 220),
}

-- ============================================================
--  GLOW GIRANDO
-- ============================================================

local function addRotatingGlow(frame, color1, color2)
    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Thickness = 2
    stroke.Color     = color1
    stroke.Parent    = frame

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    color1),
        ColorSequenceKeypoint.new(0.33, color2),
        ColorSequenceKeypoint.new(0.66, color1),
        ColorSequenceKeypoint.new(1,    color2),
    })
    grad.Parent = stroke

    local angle = 0
    RunService.Heartbeat:Connect(function(dt)
        angle = (angle + dt * 90) % 360
        grad.Rotation = angle
    end)
    return stroke
end

-- ============================================================
--  ROOT GUI
-- ============================================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name           = "YazyUtilities"
screenGui.ResetOnSpawn   = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.Parent         = player:WaitForChild("PlayerGui")

-- ============================================================
--  JANELA PRINCIPAL
-- ============================================================

local mainFrame = Instance.new("Frame")
mainFrame.Name            = "MainFrame"
mainFrame.Size            = UDim2.new(0, 520, 0, 390)
mainFrame.Position        = UDim2.new(0.5, -260, 0.5, -195)
mainFrame.BackgroundColor3 = C.bg
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex          = 2
mainFrame.Parent          = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)
addRotatingGlow(mainFrame, C.border, C.subtext)

-- Sombra
local shadow = Instance.new("Frame")
shadow.Size                 = UDim2.new(1, 20, 1, 20)
shadow.Position             = UDim2.new(0, -10, 0, 8)
shadow.BackgroundColor3     = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.75
shadow.BorderSizePixel      = 0
shadow.ZIndex               = 1
shadow.Parent               = mainFrame
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 22)

-- ============================================================
--  BARRA DE TITULO
-- ============================================================

local titleBar = Instance.new("Frame")
titleBar.Size            = UDim2.new(1, 0, 0, 46)
titleBar.BackgroundColor3 = C.bg2
titleBar.BorderSizePixel = 0
titleBar.ZIndex          = 3
titleBar.Parent          = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 16)
makeDraggable(mainFrame)

local titleFix = Instance.new("Frame")
titleFix.Size            = UDim2.new(1, 0, 0, 16)
titleFix.Position        = UDim2.new(0, 0, 1, -16)
titleFix.BackgroundColor3 = C.bg2
titleFix.BorderSizePixel = 0
titleFix.ZIndex          = 3
titleFix.Parent          = titleBar

local titleBorder = Instance.new("Frame")
titleBorder.Size            = UDim2.new(1, 0, 0, 1)
titleBorder.Position        = UDim2.new(0, 0, 1, 0)
titleBorder.BackgroundColor3 = C.dim
titleBorder.BackgroundTransparency = 0.5
titleBorder.BorderSizePixel = 0
titleBorder.ZIndex          = 4
titleBorder.Parent          = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size             = UDim2.new(1, -160, 1, 0)
titleLabel.Position         = UDim2.new(0, 16, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text             = "Yazy Utilities"
titleLabel.TextColor3       = C.text
titleLabel.Font             = Enum.Font.GothamBlack
titleLabel.TextSize         = 17
titleLabel.TextXAlignment   = Enum.TextXAlignment.Left
titleLabel.ZIndex           = 4
titleLabel.Parent           = titleBar

local versionLabel = Instance.new("TextLabel")
versionLabel.Size           = UDim2.new(0, 90, 1, 0)
versionLabel.Position       = UDim2.new(0, 170, 0, 0)
versionLabel.BackgroundTransparency = 1
versionLabel.Text           = "v2.0 PREMIUM"
versionLabel.TextColor3     = C.pink
versionLabel.Font           = Enum.Font.GothamBold
versionLabel.TextSize       = 11
versionLabel.TextXAlignment = Enum.TextXAlignment.Left
versionLabel.ZIndex         = 4
versionLabel.Parent         = titleBar

-- Hint Ctrl no titulo
local hintLbl = Instance.new("TextLabel")
hintLbl.Size              = UDim2.new(0, 70, 1, 0)
hintLbl.Position          = UDim2.new(1, -116, 0, 0)
hintLbl.BackgroundTransparency = 1
hintLbl.Text              = "Ctrl  ·  toggle"
hintLbl.TextColor3        = C.dim
hintLbl.Font              = Enum.Font.Gotham
hintLbl.TextSize          = 10
hintLbl.TextXAlignment    = Enum.TextXAlignment.Right
hintLbl.ZIndex            = 4
hintLbl.Parent            = titleBar

-- Botao minimizar (UI principal) — PC
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size            = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position        = UDim2.new(1, -40, 0.5, -15)
minimizeBtn.BackgroundColor3 = C.bg3
minimizeBtn.Text            = "—"
minimizeBtn.TextColor3      = C.subtext
minimizeBtn.Font            = Enum.Font.GothamBlack
minimizeBtn.TextSize        = 16
minimizeBtn.ZIndex          = 5
minimizeBtn.Parent          = titleBar
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 7)
local minStroke = Instance.new("UIStroke", minimizeBtn)
minStroke.Color = C.dim minStroke.Thickness = 1

-- ============================================================
--  BARRA LATERAL DE ABAS
-- ============================================================

local sidebar = Instance.new("Frame")
sidebar.Size            = UDim2.new(0, 118, 1, -46)
sidebar.Position        = UDim2.new(0, 0, 0, 46)
sidebar.BackgroundColor3 = C.bg2
sidebar.BorderSizePixel = 0
sidebar.ZIndex          = 3
sidebar.Parent          = mainFrame

local sideStroke = Instance.new("UIStroke", sidebar)
sideStroke.Color     = C.dim
sideStroke.Thickness = 1

local sideList = Instance.new("UIListLayout", sidebar)
sideList.SortOrder = Enum.SortOrder.LayoutOrder
sideList.Padding   = UDim.new(0, 3)

local sidePad = Instance.new("UIPadding", sidebar)
sidePad.PaddingTop   = UDim.new(0, 10)
sidePad.PaddingLeft  = UDim.new(0, 6)
sidePad.PaddingRight = UDim.new(0, 6)

-- ============================================================
--  AREA DE CONTEUDO
-- ============================================================

local contentFrame = Instance.new("Frame")
contentFrame.Size            = UDim2.new(1, -118, 1, -46)
contentFrame.Position        = UDim2.new(0, 118, 0, 46)
contentFrame.BackgroundColor3 = C.panel
contentFrame.BorderSizePixel = 0
contentFrame.ZIndex          = 3
contentFrame.Parent          = mainFrame
Instance.new("UICorner", contentFrame).CornerRadius = UDim.new(0, 10)

local contentFix = Instance.new("Frame")
contentFix.Size            = UDim2.new(0, 12, 1, 0)
contentFix.BackgroundColor3 = C.panel
contentFix.BorderSizePixel = 0
contentFix.ZIndex          = 3
contentFix.Parent          = contentFrame

-- ============================================================
--  MINIMIZAR JANELA PRINCIPAL (Ctrl)
-- ============================================================

local uiMinimized = false

local function setUIMinimized(state)
    uiMinimized = state
    if uiMinimized then
        sidebar.Visible      = false
        contentFrame.Visible = false
        mainFrame.Size       = UDim2.new(0, 520, 0, 46)
        minimizeBtn.Text     = "+"
    else
        sidebar.Visible      = true
        contentFrame.Visible = true
        mainFrame.Size       = UDim2.new(0, 520, 0, 390)
        minimizeBtn.Text     = "—"
    end
end

minimizeBtn.MouseButton1Click:Connect(function()
    setUIMinimized(not uiMinimized)
end)

-- Toggle visibilidade completa via Ctrl
local mainVisible = true
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.LeftControl
    or input.KeyCode == Enum.KeyCode.RightControl then
        mainVisible = not mainVisible
        mainFrame.Visible = mainVisible
    end
end)

-- ============================================================
--  HELPERS DE PAGINAS / ABAS
-- ============================================================

local pages      = {}
local tabButtons = {}

local function newPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name                = name
    page.Size                = UDim2.new(1, -12, 1, 0)
    page.Position            = UDim2.new(0, 12, 0, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel     = 0
    page.ScrollBarThickness  = 3
    page.ScrollBarImageColor3 = C.border
    page.CanvasSize          = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible             = false
    page.ZIndex              = 4
    page.Parent              = contentFrame

    local pad = Instance.new("UIPadding", page)
    pad.PaddingTop   = UDim.new(0, 14)
    pad.PaddingLeft  = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)

    local list = Instance.new("UIListLayout", page)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding   = UDim.new(0, 10)

    pages[name] = page
    return page
end

local function showPage(name)
    for n, p in pairs(pages) do
        p.Visible = (n == name)
    end
    for n, btn in pairs(tabButtons) do
        if n == name then
            tween(btn, TweenInfo.new(0.18), {BackgroundColor3 = C.border, TextColor3 = C.white})
            btn.BackgroundTransparency = 0
        else
            tween(btn, TweenInfo.new(0.18), {BackgroundColor3 = C.bg2, TextColor3 = C.subtext})
            btn.BackgroundTransparency = 1
        end
    end
end

local function addTab(label, color)
    local btn = Instance.new("TextButton")
    btn.Size              = UDim2.new(1, 0, 0, 36)
    btn.BackgroundTransparency = 1
    btn.Text              = label
    btn.TextColor3        = C.subtext
    btn.Font              = Enum.Font.GothamSemibold
    btn.TextSize          = 13
    btn.TextXAlignment    = Enum.TextXAlignment.Left
    btn.LayoutOrder       = #tabButtons + 1
    btn.ZIndex            = 4
    btn.Parent            = sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
    local pad = Instance.new("UIPadding", btn)
    pad.PaddingLeft = UDim.new(0, 10)

    btn.MouseEnter:Connect(function()
        if tabButtons[label] ~= btn then return end
        tween(btn, TweenInfo.new(0.12), {TextColor3 = C.text})
    end)
    btn.MouseLeave:Connect(function()
        -- so reverte se nao estiver ativo
        local isActive = false
        for n, b in pairs(tabButtons) do
            if b == btn and n == (function()
                for pg, _ in pairs(pages) do
                    if pages[pg].Visible then return pg end
                end
            end)() then isActive = true end
        end
        if not isActive then
            tween(btn, TweenInfo.new(0.12), {TextColor3 = C.subtext})
        end
    end)

    tabButtons[label] = btn
    btn.MouseButton1Click:Connect(function() showPage(label) end)
    return btn
end

-- ============================================================
--  HELPERS DE WIDGETS
-- ============================================================

local function addSectionTitle(page, text, color)
    local lbl = Instance.new("TextLabel")
    lbl.Size              = UDim2.new(1, 0, 0, 22)
    lbl.BackgroundTransparency = 1
    lbl.Text              = text
    lbl.TextColor3        = color or C.text
    lbl.Font              = Enum.Font.GothamBlack
    lbl.TextSize          = 13
    lbl.TextXAlignment    = Enum.TextXAlignment.Left
    lbl.ZIndex            = 5
    lbl.Parent            = page
    return lbl
end

local function addDivider(page)
    local div = Instance.new("Frame")
    div.Size                 = UDim2.new(1, 0, 0, 1)
    div.BackgroundColor3     = C.dim
    div.BackgroundTransparency = 0.5
    div.BorderSizePixel      = 0
    div.ZIndex               = 5
    div.Parent               = page
    return div
end

local function addButton(page, text, color, callback)
    color = color or C.text
    local btn = Instance.new("TextButton")
    btn.Size             = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = C.bg3
    btn.Text             = text
    btn.TextColor3       = color
    btn.Font             = Enum.Font.GothamBold
    btn.TextSize         = 14
    btn.ZIndex           = 5
    btn.Parent           = page
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color     = color
    stroke.Thickness = 1.5

    btn.MouseEnter:Connect(function()
        tween(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(
            math.clamp(math.floor(color.R*255*0.15), 0, 255),
            math.clamp(math.floor(color.G*255*0.15), 0, 255),
            math.clamp(math.floor(color.B*255*0.15), 0, 255)
        )})
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, TweenInfo.new(0.12), {BackgroundColor3 = C.bg3})
    end)

    if callback then btn.MouseButton1Click:Connect(callback) end
    return btn
end

local function addToggle(page, text, color, onToggle)
    color = color or C.cyan
    local container = Instance.new("Frame")
    container.Size            = UDim2.new(1, 0, 0, 42)
    container.BackgroundColor3 = C.bg3
    container.BorderSizePixel = 0
    container.ZIndex          = 5
    container.Parent          = page
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", container)
    stroke.Color     = C.dim
    stroke.Thickness = 1

    local lbl = Instance.new("TextLabel")
    lbl.Size              = UDim2.new(1, -60, 1, 0)
    lbl.Position          = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text              = text
    lbl.TextColor3        = C.text
    lbl.Font              = Enum.Font.GothamSemibold
    lbl.TextSize          = 13
    lbl.TextXAlignment    = Enum.TextXAlignment.Left
    lbl.ZIndex            = 6
    lbl.Parent            = container

    local track = Instance.new("Frame")
    track.Size            = UDim2.new(0, 40, 0, 22)
    track.Position        = UDim2.new(1, -52, 0.5, -11)
    track.BackgroundColor3 = C.dim
    track.BorderSizePixel = 0
    track.ZIndex          = 6
    track.Parent          = container
    Instance.new("UICorner", track).CornerRadius = UDim.new(0, 11)

    local knob = Instance.new("Frame")
    knob.Size            = UDim2.new(0, 16, 0, 16)
    knob.Position        = UDim2.new(0, 3, 0.5, -8)
    knob.BackgroundColor3 = C.white
    knob.BorderSizePixel = 0
    knob.ZIndex          = 7
    knob.Parent          = track
    Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 8)
    local kS = Instance.new("UIStroke", knob)
    kS.Color = C.dim kS.Thickness = 0.5

    local state = false
    local btn = Instance.new("TextButton")
    btn.Size              = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text              = ""
    btn.ZIndex            = 8
    btn.Parent            = container

    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            tween(track, TweenInfo.new(0.2), {BackgroundColor3 = color})
            tween(knob,  TweenInfo.new(0.2), {Position = UDim2.new(0, 21, 0.5, -8)})
            stroke.Color = color
        else
            tween(track, TweenInfo.new(0.2), {BackgroundColor3 = C.dim})
            tween(knob,  TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -8)})
            stroke.Color = C.dim
        end
        if onToggle then onToggle(state) end
    end)

    return container, function() return state end
end

local function addInfoLabel(page, text, color)
    local lbl = Instance.new("TextLabel")
    lbl.Size              = UDim2.new(1, 0, 0, 30)
    lbl.BackgroundTransparency = 1
    lbl.Text              = text
    lbl.TextColor3        = color or C.subtext
    lbl.Font              = Enum.Font.Gotham
    lbl.TextSize          = 12
    lbl.TextXAlignment    = Enum.TextXAlignment.Left
    lbl.TextWrapped       = true
    lbl.ZIndex            = 5
    lbl.Parent            = page
    return lbl
end

local function addDisabledButton(page, text)
    local btn = Instance.new("TextButton")
    btn.Size             = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = C.disabled
    btn.Text             = text .. "  [ Em Breve ]"
    btn.TextColor3       = C.dim
    btn.Font             = Enum.Font.GothamBold
    btn.TextSize         = 13
    btn.Active           = false
    btn.AutoButtonColor  = false
    btn.ZIndex           = 5
    btn.Parent           = page
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color     = C.dim
    stroke.Thickness = 1
    return btn
end

-- ============================================================
--  HUBS FLUTUANTES
-- ============================================================

local openHubs = {}

local function createHubWindow(title, color1, color2, width, height, buildFn)
    if openHubs[title] then
        openHubs[title].Visible = true
        return
    end

    local win = Instance.new("Frame")
    win.Size            = UDim2.new(0, width, 0, height)
    win.Position        = UDim2.new(0.5, -width/2, 0.5, -height/2 - 60)
    win.BackgroundColor3 = C.bg
    win.BorderSizePixel = 0
    win.ZIndex          = 20
    win.Parent          = screenGui
    Instance.new("UICorner", win).CornerRadius = UDim.new(0, 14)
    addRotatingGlow(win, color1, color2)
    makeDraggable(win)
    openHubs[title] = win

    local wShadow = Instance.new("Frame")
    wShadow.Size                 = UDim2.new(1, 16, 1, 16)
    wShadow.Position             = UDim2.new(0, -8, 0, 6)
    wShadow.BackgroundColor3     = Color3.fromRGB(0, 0, 0)
    wShadow.BackgroundTransparency = 0.8
    wShadow.BorderSizePixel      = 0
    wShadow.ZIndex               = 19
    wShadow.Parent               = win
    Instance.new("UICorner", wShadow).CornerRadius = UDim.new(0, 18)

    local tbar = Instance.new("Frame")
    tbar.Size            = UDim2.new(1, 0, 0, 38)
    tbar.BackgroundColor3 = C.bg2
    tbar.BorderSizePixel = 0
    tbar.ZIndex          = 21
    tbar.Parent          = win
    Instance.new("UICorner", tbar).CornerRadius = UDim.new(0, 14)

    local tfix = Instance.new("Frame")
    tfix.Size            = UDim2.new(1, 0, 0, 14)
    tfix.Position        = UDim2.new(0, 0, 1, -14)
    tfix.BackgroundColor3 = C.bg2
    tfix.BorderSizePixel = 0
    tfix.ZIndex          = 21
    tfix.Parent          = tbar

    local tbarLine = Instance.new("Frame")
    tbarLine.Size            = UDim2.new(1, 0, 0, 1)
    tbarLine.Position        = UDim2.new(0, 0, 1, 0)
    tbarLine.BackgroundColor3 = C.dim
    tbarLine.BackgroundTransparency = 0.5
    tbarLine.BorderSizePixel = 0
    tbarLine.ZIndex          = 22
    tbarLine.Parent          = tbar

    local tlbl = Instance.new("TextLabel")
    tlbl.Size             = UDim2.new(1, -84, 1, 0)
    tlbl.Position         = UDim2.new(0, 12, 0, 0)
    tlbl.BackgroundTransparency = 1
    tlbl.Text             = title
    tlbl.TextColor3       = C.text
    tlbl.Font             = Enum.Font.GothamBlack
    tlbl.TextSize         = 13
    tlbl.TextXAlignment   = Enum.TextXAlignment.Left
    tlbl.ZIndex           = 22
    tlbl.Parent           = tbar

    -- Botao minimizar hub
    local hubVisible = true
    local hubBody

    local minBtn = Instance.new("TextButton")
    minBtn.Size            = UDim2.new(0, 26, 0, 26)
    minBtn.Position        = UDim2.new(1, -60, 0.5, -13)
    minBtn.BackgroundColor3 = C.bg3
    minBtn.Text            = "—"
    minBtn.TextColor3      = C.subtext
    minBtn.Font            = Enum.Font.GothamBlack
    minBtn.TextSize        = 14
    minBtn.ZIndex          = 23
    minBtn.Parent          = tbar
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)
    local mS = Instance.new("UIStroke", minBtn)
    mS.Color = C.dim mS.Thickness = 1

    minBtn.MouseEnter:Connect(function()
        tween(minBtn, TweenInfo.new(0.1), {BackgroundColor3 = C.bg2})
    end)
    minBtn.MouseLeave:Connect(function()
        tween(minBtn, TweenInfo.new(0.1), {BackgroundColor3 = C.bg3})
    end)

    -- Botao fechar hub
    local closeHubBtn = Instance.new("TextButton")
    closeHubBtn.Size            = UDim2.new(0, 26, 0, 26)
    closeHubBtn.Position        = UDim2.new(1, -30, 0.5, -13)
    closeHubBtn.BackgroundColor3 = C.red
    closeHubBtn.Text            = "✕"
    closeHubBtn.TextColor3      = C.white
    closeHubBtn.Font            = Enum.Font.GothamBlack
    closeHubBtn.TextSize        = 12
    closeHubBtn.ZIndex          = 23
    closeHubBtn.Parent          = tbar
    Instance.new("UICorner", closeHubBtn).CornerRadius = UDim.new(0, 6)

    closeHubBtn.MouseButton1Click:Connect(function()
        win.Visible = false
        openHubs[title] = nil
    end)

    local body = Instance.new("Frame")
    body.Size            = UDim2.new(1, 0, 1, -38)
    body.Position        = UDim2.new(0, 0, 0, 38)
    body.BackgroundTransparency = 1
    body.ZIndex          = 21
    body.Parent          = win
    hubBody              = body

    minBtn.MouseButton1Click:Connect(function()
        hubVisible = not hubVisible
        hubBody.Visible = hubVisible
        win.Size = hubVisible
            and UDim2.new(0, width, 0, height)
            or  UDim2.new(0, width, 0, 38)
        minBtn.Text = hubVisible and "—" or "+"
    end)

    buildFn(body, color1, color2)
    return win
end

-- ============================================================
--  STATUS LABEL HELPER
-- ============================================================

local function makeStatusLabel(parent, color)
    local lbl = Instance.new("TextLabel")
    lbl.Size              = UDim2.new(1, -20, 0, 22)
    lbl.Position          = UDim2.new(0, 10, 1, -28)
    lbl.BackgroundTransparency = 1
    lbl.Text              = "Pronto."
    lbl.TextColor3        = color
    lbl.Font              = Enum.Font.Gotham
    lbl.TextSize          = 11
    lbl.TextXAlignment    = Enum.TextXAlignment.Center
    lbl.ZIndex            = 25
    lbl.Parent            = parent
    return lbl
end

local function setStatus(lbl, text, color)
    lbl.Text = text
    if color then lbl.TextColor3 = color end
end

-- ============================================================
--  HUB 1: YAZY TWEENING HUB
-- ============================================================

local TWEEN_SPEED  = 3000
local TWEEN_HEIGHT = 300
local TWEEN_BASE   = CFrame.new(-810.40, 38.78, -2122.00)   -- base final
local TWEEN_RETURN = CFrame.new(739.34, 38.72, -2121.97)

local function voarParaCFrame(destCFrame, speed, statusLbl)
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end

    local startPos = hrp.Position
    local endPos   = destCFrame.Position

    hrp.Anchored = true

    local posAlta1   = CFrame.new(startPos.X, startPos.Y + TWEEN_HEIGHT, startPos.Z)
    local tempoSubir = TWEEN_HEIGHT / speed
    local tweenSubir = TweenService:Create(hrp, TweenInfo.new(tempoSubir, Enum.EasingStyle.Sine), {CFrame = posAlta1})

    local posAlta2  = CFrame.new(endPos.X, startPos.Y + TWEEN_HEIGHT, endPos.Z)
    local distH     = (Vector3.new(endPos.X, 0, endPos.Z) - Vector3.new(startPos.X, 0, startPos.Z)).Magnitude
    local tempoVoar = distH / speed
    local tweenVoar = TweenService:Create(hrp, TweenInfo.new(tempoVoar, Enum.EasingStyle.Linear), {CFrame = posAlta2})

    local altoDest   = startPos.Y + TWEEN_HEIGHT
    local tempoDescer = math.abs(altoDest - endPos.Y) / speed
    local tweenDescer = TweenService:Create(hrp, TweenInfo.new(tempoDescer, Enum.EasingStyle.Sine), {CFrame = destCFrame})

    if statusLbl then setStatus(statusLbl, "Subindo...", C.yellow) end
    tweenSubir:Play() tweenSubir.Completed:Wait()
    if statusLbl then setStatus(statusLbl, "Voando...", C.cyan) end
    tweenVoar:Play() tweenVoar.Completed:Wait()
    if statusLbl then setStatus(statusLbl, "Descendo...", C.green) end
    tweenDescer:Play() tweenDescer.Completed:Wait()

    hrp.Anchored = false
    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    if statusLbl then setStatus(statusLbl, "Chegou!", C.green) end
end

local function buildTweeningHub(body, c1, c2)
    local statusLbl = makeStatusLabel(body, C.subtext)

    local pad = Instance.new("UIPadding", body)
    pad.PaddingTop    = UDim.new(0, 14)
    pad.PaddingLeft   = UDim.new(0, 14)
    pad.PaddingRight  = UDim.new(0, 14)
    pad.PaddingBottom = UDim.new(0, 36)

    local list = Instance.new("UIListLayout", body)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding   = UDim.new(0, 12)

    local btnBase = Instance.new("TextButton")
    btnBase.Size            = UDim2.new(1, 0, 0, 70)
    btnBase.BackgroundColor3 = C.bg3
    btnBase.Text            = "Tweening → Base"
    btnBase.TextColor3      = C.green
    btnBase.Font            = Enum.Font.GothamBlack
    btnBase.TextSize        = 16
    btnBase.ZIndex          = 25
    btnBase.Parent          = body
    Instance.new("UICorner", btnBase).CornerRadius = UDim.new(0, 10)
    local s1 = Instance.new("UIStroke", btnBase)
    s1.Color = C.green s1.Thickness = 2

    local btnVoltar = Instance.new("TextButton")
    btnVoltar.Size            = UDim2.new(1, 0, 0, 70)
    btnVoltar.BackgroundColor3 = C.bg3
    btnVoltar.Text            = "Tweening → Voltar"
    btnVoltar.TextColor3      = C.pink
    btnVoltar.Font            = Enum.Font.GothamBlack
    btnVoltar.TextSize        = 16
    btnVoltar.ZIndex          = 25
    btnVoltar.Parent          = body
    Instance.new("UICorner", btnVoltar).CornerRadius = UDim.new(0, 10)
    local s2 = Instance.new("UIStroke", btnVoltar)
    s2.Color = C.pink s2.Thickness = 2

    btnBase.MouseEnter:Connect(function() tween(btnBase, TweenInfo.new(0.1), {BackgroundColor3 = C.bg2}) end)
    btnBase.MouseLeave:Connect(function() tween(btnBase, TweenInfo.new(0.1), {BackgroundColor3 = C.bg3}) end)
    btnVoltar.MouseEnter:Connect(function() tween(btnVoltar, TweenInfo.new(0.1), {BackgroundColor3 = C.bg2}) end)
    btnVoltar.MouseLeave:Connect(function() tween(btnVoltar, TweenInfo.new(0.1), {BackgroundColor3 = C.bg3}) end)

    local flying = false
    local function fly(dest)
        if flying then return end
        flying = true
        voarParaCFrame(dest, TWEEN_SPEED, statusLbl)
        flying = false
    end

    btnBase.MouseButton1Click:Connect(function() coroutine.wrap(fly)(TWEEN_BASE) end)
    btnVoltar.MouseButton1Click:Connect(function() coroutine.wrap(fly)(TWEEN_RETURN) end)
end

-- ============================================================
--  HUB 2: YAZY TP HUB
-- ============================================================

local TP_SPEED  = 50000
local TP_BASE   = CFrame.new(-810.40, 38.78, -2122.00)   -- base final
local TP_RETURN = CFrame.new(739.34, 38.72, -2121.97)

local function buildTPHub(body, c1, c2)
    local statusLbl = makeStatusLabel(body, C.subtext)

    local pad = Instance.new("UIPadding", body)
    pad.PaddingTop    = UDim.new(0, 14)
    pad.PaddingLeft   = UDim.new(0, 14)
    pad.PaddingRight  = UDim.new(0, 14)
    pad.PaddingBottom = UDim.new(0, 36)

    local list = Instance.new("UIListLayout", body)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding   = UDim.new(0, 12)

    local btnBase = Instance.new("TextButton")
    btnBase.Size            = UDim2.new(1, 0, 0, 70)
    btnBase.BackgroundColor3 = C.bg3
    btnBase.Text            = "TP → Base"
    btnBase.TextColor3      = C.cyan
    btnBase.Font            = Enum.Font.GothamBlack
    btnBase.TextSize        = 16
    btnBase.ZIndex          = 25
    btnBase.Parent          = body
    Instance.new("UICorner", btnBase).CornerRadius = UDim.new(0, 10)
    local s1 = Instance.new("UIStroke", btnBase)
    s1.Color = C.cyan s1.Thickness = 2

    local btnVoltar = Instance.new("TextButton")
    btnVoltar.Size            = UDim2.new(1, 0, 0, 70)
    btnVoltar.BackgroundColor3 = C.bg3
    btnVoltar.Text            = "TP → Voltar"
    btnVoltar.TextColor3      = C.yellow
    btnVoltar.Font            = Enum.Font.GothamBlack
    btnVoltar.TextSize        = 16
    btnVoltar.ZIndex          = 25
    btnVoltar.Parent          = body
    Instance.new("UICorner", btnVoltar).CornerRadius = UDim.new(0, 10)
    local s2 = Instance.new("UIStroke", btnVoltar)
    s2.Color = C.yellow s2.Thickness = 2

    btnBase.MouseEnter:Connect(function() tween(btnBase, TweenInfo.new(0.1), {BackgroundColor3 = C.bg2}) end)
    btnBase.MouseLeave:Connect(function() tween(btnBase, TweenInfo.new(0.1), {BackgroundColor3 = C.bg3}) end)
    btnVoltar.MouseEnter:Connect(function() tween(btnVoltar, TweenInfo.new(0.1), {BackgroundColor3 = C.bg2}) end)
    btnVoltar.MouseLeave:Connect(function() tween(btnVoltar, TweenInfo.new(0.1), {BackgroundColor3 = C.bg3}) end)

    local flying = false
    local function fly(dest)
        if flying then return end
        flying = true
        voarParaCFrame(dest, TP_SPEED, statusLbl)
        flying = false
    end

    btnBase.MouseButton1Click:Connect(function() coroutine.wrap(fly)(TP_BASE) end)
    btnVoltar.MouseButton1Click:Connect(function() coroutine.wrap(fly)(TP_RETURN) end)
end

-- ============================================================
--  HUB 3: YAZY COLLECT HUB
-- ============================================================

local collectActive = false
local collectThread = nil

local function fireCollect()
    local ok = pcall(function()
        local args = { buffer.fromstring("4") }
        ReplicatedStorage:WaitForChild("Libraries")
            :WaitForChild("Packet")
            :WaitForChild("RemoteEvent")
            :FireServer(table.unpack(args))
    end)
    return ok
end

local function buildCollectHub(body, c1, c2)
    local statusLbl = makeStatusLabel(body, C.subtext)

    local pad = Instance.new("UIPadding", body)
    pad.PaddingTop    = UDim.new(0, 14)
    pad.PaddingLeft   = UDim.new(0, 14)
    pad.PaddingRight  = UDim.new(0, 14)
    pad.PaddingBottom = UDim.new(0, 36)

    local list = Instance.new("UIListLayout", body)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding   = UDim.new(0, 12)

    local toggleRow = Instance.new("Frame")
    toggleRow.Size            = UDim2.new(1, 0, 0, 48)
    toggleRow.BackgroundColor3 = C.bg3
    toggleRow.BorderSizePixel = 0
    toggleRow.ZIndex          = 25
    toggleRow.Parent          = body
    Instance.new("UICorner", toggleRow).CornerRadius = UDim.new(0, 10)
    local toggleStroke = Instance.new("UIStroke", toggleRow)
    toggleStroke.Color     = C.dim
    toggleStroke.Thickness = 1

    local tLbl = Instance.new("TextLabel")
    tLbl.Size              = UDim2.new(0.6, 0, 1, 0)
    tLbl.Position          = UDim2.new(0, 12, 0, 0)
    tLbl.BackgroundTransparency = 1
    tLbl.Text              = "Auto Collect"
    tLbl.TextColor3        = C.text
    tLbl.Font              = Enum.Font.GothamBold
    tLbl.TextSize          = 14
    tLbl.TextXAlignment    = Enum.TextXAlignment.Left
    tLbl.ZIndex            = 26
    tLbl.Parent            = toggleRow

    local track = Instance.new("Frame")
    track.Size            = UDim2.new(0, 44, 0, 24)
    track.Position        = UDim2.new(1, -56, 0.5, -12)
    track.BackgroundColor3 = C.dim
    track.BorderSizePixel = 0
    track.ZIndex          = 26
    track.Parent          = toggleRow
    Instance.new("UICorner", track).CornerRadius = UDim.new(0, 12)

    local knob = Instance.new("Frame")
    knob.Size            = UDim2.new(0, 18, 0, 18)
    knob.Position        = UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = C.white
    knob.BorderSizePixel = 0
    knob.ZIndex          = 27
    knob.Parent          = track
    Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 9)
    local knobS = Instance.new("UIStroke", knob)
    knobS.Color = C.dim knobS.Thickness = 0.5

    local togBtn = Instance.new("TextButton")
    togBtn.Size              = UDim2.new(1, 0, 1, 0)
    togBtn.BackgroundTransparency = 1
    togBtn.Text              = ""
    togBtn.ZIndex            = 28
    togBtn.Parent            = toggleRow

    local collectCount = 0
    local countLbl = Instance.new("TextLabel")
    countLbl.Size              = UDim2.new(1, 0, 0, 22)
    countLbl.BackgroundTransparency = 1
    countLbl.Text              = "Coletas realizadas: 0"
    countLbl.TextColor3        = C.subtext
    countLbl.Font              = Enum.Font.Gotham
    countLbl.TextSize          = 12
    countLbl.ZIndex            = 25
    countLbl.Parent            = body

    togBtn.MouseButton1Click:Connect(function()
        collectActive = not collectActive
        if collectActive then
            tween(track, TweenInfo.new(0.2), {BackgroundColor3 = c1})
            tween(knob,  TweenInfo.new(0.2), {Position = UDim2.new(0, 23, 0.5, -9)})
            toggleStroke.Color = c1
            setStatus(statusLbl, "Auto Collect ativo.", c1)
            collectThread = task.spawn(function()
                while collectActive do
                    local ok = fireCollect()
                    if ok then
                        collectCount += 1
                        countLbl.Text = "Coletas realizadas: " .. collectCount
                        setStatus(statusLbl, "Coletado! Prox em 20s.", C.green)
                    else
                        setStatus(statusLbl, "Erro ao coletar.", C.red)
                    end
                    task.wait(20)
                end
            end)
        else
            if collectThread then task.cancel(collectThread) end
            tween(track, TweenInfo.new(0.2), {BackgroundColor3 = C.dim})
            tween(knob,  TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -9)})
            toggleStroke.Color = C.dim
            setStatus(statusLbl, "Auto Collect desativado.", C.subtext)
        end
    end)

    addDisabledButton(body, "Mais funções")
end

-- ============================================================
--  HUB 4: YAZY SERVER HUB
-- ============================================================

local function buildServerHub(body, c1, c2)
    local statusLbl = makeStatusLabel(body, C.subtext)

    local pad = Instance.new("UIPadding", body)
    pad.PaddingTop    = UDim.new(0, 14)
    pad.PaddingLeft   = UDim.new(0, 14)
    pad.PaddingRight  = UDim.new(0, 14)
    pad.PaddingBottom = UDim.new(0, 36)

    local list = Instance.new("UIListLayout", body)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding   = UDim.new(0, 12)

    local infoLbl = Instance.new("TextLabel")
    infoLbl.Size              = UDim2.new(1, 0, 0, 32)
    infoLbl.BackgroundTransparency = 1
    infoLbl.Text              = "Salta para um servidor aleatório do mesmo jogo."
    infoLbl.TextColor3        = C.subtext
    infoLbl.Font              = Enum.Font.Gotham
    infoLbl.TextSize          = 12
    infoLbl.TextWrapped       = true
    infoLbl.ZIndex            = 25
    infoLbl.Parent            = body

    local btnHop = Instance.new("TextButton")
    btnHop.Size            = UDim2.new(1, 0, 0, 70)
    btnHop.BackgroundColor3 = C.bg3
    btnHop.Text            = "Server Hop"
    btnHop.TextColor3      = c1
    btnHop.Font            = Enum.Font.GothamBlack
    btnHop.TextSize        = 18
    btnHop.ZIndex          = 25
    btnHop.Parent          = body
    Instance.new("UICorner", btnHop).CornerRadius = UDim.new(0, 10)
    local shS = Instance.new("UIStroke", btnHop)
    shS.Color = c1 shS.Thickness = 2

    btnHop.MouseEnter:Connect(function() tween(btnHop, TweenInfo.new(0.1), {BackgroundColor3 = C.bg2}) end)
    btnHop.MouseLeave:Connect(function() tween(btnHop, TweenInfo.new(0.1), {BackgroundColor3 = C.bg3}) end)

    btnHop.MouseButton1Click:Connect(function()
        setStatus(statusLbl, "Procurando servidor...", C.yellow)
        task.spawn(function()
            local ok = pcall(function()
                local code = TeleportService:ReserveServer(game.PlaceId)
                TeleportService:TeleportToPrivateServer(game.PlaceId, code, {player})
            end)
            if not ok then
                pcall(function() TeleportService:Teleport(game.PlaceId, player) end)
                setStatus(statusLbl, "Saltando (fallback)...", C.orange)
            else
                setStatus(statusLbl, "Saltando...", C.green)
            end
        end)
    end)
end

-- ============================================================
--  CONSTRUÇÃO DAS ABAS
-- ============================================================

addTab("LocalPlayer", C.cyan)
local pageLP = newPage("LocalPlayer")

addSectionTitle(pageLP, "Velocidade", C.cyan)

local speedEnabled = false
local speedValue   = 16
local speedThread  = nil

addToggle(pageLP, "Speed Hack", C.cyan, function(on)
    speedEnabled = on
    if on then
        speedThread = task.spawn(function()
            while speedEnabled do
                local char = player.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then hum.WalkSpeed = speedValue end
                end
                task.wait(0.1)
            end
        end)
    else
        if speedThread then task.cancel(speedThread) end
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
    end
end)

local speedContainer = Instance.new("Frame")
speedContainer.Size            = UDim2.new(1, 0, 0, 40)
speedContainer.BackgroundColor3 = C.bg3
speedContainer.BorderSizePixel = 0
speedContainer.ZIndex          = 5
speedContainer.Parent          = pageLP
Instance.new("UICorner", speedContainer).CornerRadius = UDim.new(0, 8)
local speedStroke = Instance.new("UIStroke", speedContainer)
speedStroke.Color = C.dim speedStroke.Thickness = 1

local speedLblLeft = Instance.new("TextLabel")
speedLblLeft.Size              = UDim2.new(0.5, 0, 1, 0)
speedLblLeft.Position          = UDim2.new(0, 10, 0, 0)
speedLblLeft.BackgroundTransparency = 1
speedLblLeft.Text              = "WalkSpeed"
speedLblLeft.TextColor3        = C.text
speedLblLeft.Font              = Enum.Font.GothamSemibold
speedLblLeft.TextSize          = 13
speedLblLeft.TextXAlignment    = Enum.TextXAlignment.Left
speedLblLeft.ZIndex            = 6
speedLblLeft.Parent            = speedContainer

local speedInput = Instance.new("TextBox")
speedInput.Size             = UDim2.new(0, 64, 0, 28)
speedInput.Position         = UDim2.new(1, -74, 0.5, -14)
speedInput.BackgroundColor3 = C.bg2
speedInput.TextColor3       = C.cyan
speedInput.Font             = Enum.Font.GothamBold
speedInput.TextSize         = 14
speedInput.Text             = "16"
speedInput.ClearTextOnFocus = false
speedInput.ZIndex           = 6
speedInput.Parent           = speedContainer
Instance.new("UICorner", speedInput).CornerRadius = UDim.new(0, 6)
local siS = Instance.new("UIStroke", speedInput)
siS.Color = C.dim siS.Thickness = 1

speedInput.FocusLost:Connect(function()
    local v = tonumber(speedInput.Text)
    if v then speedValue = v end
end)

addDivider(pageLP)
addSectionTitle(pageLP, "Pulo", C.purple)

local jumpEnabled = false
local jumpValue   = 50

addToggle(pageLP, "Jump Hack", C.purple, function(on)
    jumpEnabled = on
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower = on and jumpValue or 50 end
    end
end)

local jumpContainer = Instance.new("Frame")
jumpContainer.Size            = UDim2.new(1, 0, 0, 40)
jumpContainer.BackgroundColor3 = C.bg3
jumpContainer.BorderSizePixel = 0
jumpContainer.ZIndex          = 5
jumpContainer.Parent          = pageLP
Instance.new("UICorner", jumpContainer).CornerRadius = UDim.new(0, 8)
local jumpStroke = Instance.new("UIStroke", jumpContainer)
jumpStroke.Color = C.dim jumpStroke.Thickness = 1

local jumpLblLeft = Instance.new("TextLabel")
jumpLblLeft.Size              = UDim2.new(0.5, 0, 1, 0)
jumpLblLeft.Position          = UDim2.new(0, 10, 0, 0)
jumpLblLeft.BackgroundTransparency = 1
jumpLblLeft.Text              = "JumpPower"
jumpLblLeft.TextColor3        = C.text
jumpLblLeft.Font              = Enum.Font.GothamSemibold
jumpLblLeft.TextSize          = 13
jumpLblLeft.TextXAlignment    = Enum.TextXAlignment.Left
jumpLblLeft.ZIndex            = 6
jumpLblLeft.Parent            = jumpContainer

local jumpInput = Instance.new("TextBox")
jumpInput.Size             = UDim2.new(0, 64, 0, 28)
jumpInput.Position         = UDim2.new(1, -74, 0.5, -14)
jumpInput.BackgroundColor3 = C.bg2
jumpInput.TextColor3       = C.purple
jumpInput.Font             = Enum.Font.GothamBold
jumpInput.TextSize         = 14
jumpInput.Text             = "50"
jumpInput.ClearTextOnFocus = false
jumpInput.ZIndex           = 6
jumpInput.Parent           = jumpContainer
Instance.new("UICorner", jumpInput).CornerRadius = UDim.new(0, 6)
local jiS = Instance.new("UIStroke", jumpInput)
jiS.Color = C.dim jiS.Thickness = 1

jumpInput.FocusLost:Connect(function()
    local v = tonumber(jumpInput.Text)
    if v then
        jumpValue = v
        if jumpEnabled then
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum.JumpPower = jumpValue end
            end
        end
    end
end)

addDivider(pageLP)
addSectionTitle(pageLP, "Outros", C.pink)
addButton(pageLP, "Resetar Personagem", C.red, function()
    player.Character:BreakJoints()
end)

addTab("Misc", C.pink)
local pageMisc = newPage("Misc")

addSectionTitle(pageMisc, "Utilidades Gerais", C.pink)
addButton(pageMisc, "Copiar UserId", C.pink, function()
    if setclipboard then setclipboard(tostring(player.UserId)) end
end)

addButton(pageMisc, "Noclip Toggle", C.orange, function()
    local noclipActive = false
    noclipActive = not noclipActive
    RunService.Stepped:Connect(function()
        if noclipActive then
            local char = player.Character
            if char then
                for _, v in ipairs(char:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide then
                        v.CanCollide = false
                    end
                end
            end
        end
    end)
end)

addButton(pageMisc, "FPS Unlocker (MaxFPS = 0)", C.yellow, function()
    if setfpscap then setfpscap(0) end
end)

addDivider(pageMisc)
addSectionTitle(pageMisc, "Em breve", C.subtext)
addDisabledButton(pageMisc, "Anti AFK")
addDisabledButton(pageMisc, "Auto Respawn")

addTab("Hubs", C.green)
local pageHubs = newPage("Hubs")

addSectionTitle(pageHubs, "Meus Scripts", C.green)
addInfoLabel(pageHubs, "Abre as janelas dos hubs. Cada hub pode ser minimizado com o botão  —  no canto.", C.subtext)

addButton(pageHubs, "Yazy Tweening Hub", C.green, function()
    createHubWindow("Yazy Tweening Hub", C.green, C.cyan, 300, 240, buildTweeningHub)
end)
addButton(pageHubs, "Yazy TP Hub", C.cyan, function()
    createHubWindow("Yazy TP Hub", C.cyan, C.purple, 300, 240, buildTPHub)
end)
addButton(pageHubs, "Yazy Collect Hub", C.orange, function()
    createHubWindow("Yazy Collect Hub", C.orange, C.yellow, 300, 260, buildCollectHub)
end)
addButton(pageHubs, "Yazy Server Hub", C.purple, function()
    createHubWindow("Yazy Server Hub", C.purple, C.pink, 300, 230, buildServerHub)
end)

addDivider(pageHubs)
addDisabledButton(pageHubs, "Novo Hub")

-- ============================================================
--  PAGINA INICIAL
-- ============================================================

showPage("LocalPlayer")

-- ============================================================
--  NOTIFICAÇÃO INICIAL
-- ============================================================

task.spawn(function()
    task.wait(1)
    local notif = Instance.new("Frame")
    notif.Size            = UDim2.new(0, 260, 0, 48)
    notif.Position        = UDim2.new(1, 20, 1, -66)
    notif.BackgroundColor3 = C.bg
    notif.BorderSizePixel = 0
    notif.ZIndex          = 50
    notif.Parent          = screenGui
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 10)
    local nStroke = Instance.new("UIStroke", notif)
    nStroke.Color     = C.border
    nStroke.Thickness = 1.5

    local nLbl = Instance.new("TextLabel")
    nLbl.Size              = UDim2.new(1, -16, 1, 0)
    nLbl.Position          = UDim2.new(0, 8, 0, 0)
    nLbl.BackgroundTransparency = 1
    nLbl.Text              = "✓  Yazy Utilities carregado  |  PREMIUM"
    nLbl.TextColor3        = C.text
    nLbl.Font              = Enum.Font.GothamBold
    nLbl.TextSize          = 12
    nLbl.ZIndex            = 51
    nLbl.Parent            = notif

    tween(notif, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Position = UDim2.new(1, -280, 1, -66)})
    task.wait(3.5)
    tween(notif, TweenInfo.new(0.4), {Position = UDim2.new(1, 20, 1, -66)})
    task.wait(0.5)
    notif:Destroy()
end)
