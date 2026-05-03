local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer

-- ==========================================
-- ⚙️ CONFIGURAÇÕES E VARIÁVEIS BASE
-- ==========================================
local ALTURA_DO_VOO = 300
local autoCollectAtivo = false

local posBase = CFrame.new(-698.01, 38.78, -2121.97)
local posVoltar = CFrame.new(739.34, 38.72, -2121.97)

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- ==========================================
-- 🚀 LÓGICA DE MOVIMENTAÇÃO (TWEEN/TP)
-- ==========================================
local function voarPara(destino, velocidade)
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
		local hrp = char.HumanoidRootPart
		local hum = char.Humanoid

		local startPos = hrp.Position
		local endPos = destino.Position

		hrp.Anchored = true

		local posAlta1 = CFrame.new(startPos.X, startPos.Y + ALTURA_DO_VOO, startPos.Z)
		local tempoSubir = ALTURA_DO_VOO / velocidade
		local tweenSubir = TweenService:Create(hrp, TweenInfo.new(tempoSubir, Enum.EasingStyle.Linear), {CFrame = posAlta1})

		local posAlta2 = CFrame.new(endPos.X, startPos.Y + ALTURA_DO_VOO, endPos.Z)
		local distHorizontal = (Vector3.new(endPos.X, 0, endPos.Z) - Vector3.new(startPos.X, 0, startPos.Z)).Magnitude
		local tempoVoar = distHorizontal / velocidade
		local tweenVoar = TweenService:Create(hrp, TweenInfo.new(tempoVoar, Enum.EasingStyle.Linear), {CFrame = posAlta2})

		local tempoDescer = (startPos.Y + ALTURA_DO_VOO - endPos.Y) / velocidade
		local tweenDescer = TweenService:Create(hrp, TweenInfo.new(tempoDescer, Enum.EasingStyle.Linear), {CFrame = destino})

		tweenSubir:Play()
		tweenSubir.Completed:Wait()

		tweenVoar:Play()
		tweenVoar.Completed:Wait()

		tweenDescer:Play()
		tweenDescer.Completed:Wait()

		hrp.Anchored = false
		hum:ChangeState(Enum.HumanoidStateType.GettingUp)
	end
end

-- Lógica do Auto Collect
task.spawn(function()
	while task.wait(20) do
		if autoCollectAtivo then
			pcall(function()
				local args = { buffer.fromstring("4") }
				game:GetService("ReplicatedStorage"):WaitForChild("Libraries"):WaitForChild("Packet"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
			end)
		end
	end
end)

-- Lógica Server Hop
local function serverHop()
	local servers = {}
	local req = request or http_request or (syn and syn.request)
	if req then
		local response = req({
			Url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100",
			Method = "GET"
		})
		if response and response.Body then
			local body = HttpService:JSONDecode(response.Body)
			for _, v in pairs(body.data) do
				if v.playing < v.maxPlayers and v.id ~= game.JobId then
					table.insert(servers, v.id)
				end
			end
			if #servers > 0 then
				TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], player)
			end
		end
	end
end

-- ==========================================
-- 🎨 INTERFACE PRINCIPAL (PREMIUM NEON COM TABS)
-- ==========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "YazyUtilities"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 550, 0, 350) -- Aumentado para caber as abas
mainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(138, 43, 226)
mainStroke.Thickness = 2.5
mainStroke.Parent = mainFrame

Instance.new("UIDragDetector", mainFrame)

-- TOPBAR (Título e Botão Minimizar)
local topbar = Instance.new("Frame")
topbar.Size = UDim2.new(1, 0, 0, 40)
topbar.BackgroundTransparency = 1
topbar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.8, 0, 1, 0)
titleLabel.Position = UDim2.new(0.05, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Yazy Utilities - Premium"
titleLabel.TextColor3 = Color3.fromRGB(138, 43, 226)
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextSize = 20
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topbar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 40, 0, 40)
minimizeBtn.Position = UDim2.new(1, -45, 0, 0)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.GothamBlack
minimizeBtn.TextSize = 24
minimizeBtn.Parent = topbar

minimizeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

-- LINHA DIVISÓRIA
local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, 0, 0, 1)
divider.Position = UDim2.new(0, 0, 0, 40)
divider.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
divider.BorderSizePixel = 0
divider.Parent = mainFrame

-- SIDEBAR (Menu de Abas)
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 130, 1, -41)
sidebar.Position = UDim2.new(0, 0, 0, 41)
sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 12)

local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.Padding = UDim.new(0, 5)
sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sidebarLayout.Parent = sidebar

local sidebarPadding = Instance.new("UIPadding")
sidebarPadding.PaddingTop = UDim.new(0, 10)
sidebarPadding.Parent = sidebar

-- CONTENT AREA (Onde as páginas aparecem)
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -140, 1, -50)
contentArea.Position = UDim2.new(0, 140, 0, 50)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainFrame

-- SISTEMA DE PÁGINAS
local pages = {}
local tabButtons = {}

local function createPage(name)
	local page = Instance.new("Frame")
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.Visible = false
	page.Parent = contentArea
	pages[name] = page
	return page
end

local function switchTab(tabName)
	for name, page in pairs(pages) do
		page.Visible = (name == tabName)
	end
	for name, btn in pairs(tabButtons) do
		if name == tabName then
			btn.BackgroundColor3 = Color3.fromRGB(138, 43, 226) -- Cor ativa
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		else
			btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30) -- Cor inativa
			btn.TextColor3 = Color3.fromRGB(180, 180, 180)
		end
	end
end

local function createTabButton(name)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.9, 0, 0, 35)
	btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(180, 180, 180)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.Parent = sidebar
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	
	btn.MouseButton1Click:Connect(function()
		switchTab(name)
	end)
	
	tabButtons[name] = btn
	createPage(name)
end

-- Criando as Abas
createTabButton("Hubs")
createTabButton("LocalPlayer")
createTabButton("Misc")
createTabButton("Gráficos")
createTabButton("Sobre Nós")

-- ==========================================
-- 📝 CONTEÚDO DAS PÁGINAS
-- ==========================================

-- PÁGINA: HUBS
local grid = Instance.new("UIGridLayout")
grid.CellSize = UDim2.new(0, 190, 0, 45)
grid.CellPadding = UDim2.new(0, 10, 0, 10)
grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
grid.Parent = pages["Hubs"]

-- Função Auxiliar para criar botões de menu (Melhoria de Leitura)
local function createMenuButton(texto, corBorda)
	local btn = Instance.new("TextButton")
	btn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	btn.Text = texto
	btn.TextColor3 = Color3.fromRGB(240, 240, 240) -- Texto branco para leitura perfeita
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	
	-- O Neon fica só na borda agora
	local stroke = Instance.new("UIStroke", btn)
	stroke.Color = corBorda
	stroke.Thickness = 1.5
	
	btn.Parent = pages["Hubs"]
	return btn
end

local btnOpenTween = createMenuButton("Yazy Tweening Hub", Color3.fromRGB(0, 255, 255))
local btnOpenTP = createMenuButton("Yazy TP Hub", Color3.fromRGB(255, 0, 255))
local btnOpenCollect = createMenuButton("Yazy Collect Hub", Color3.fromRGB(0, 255, 100))
local btnOpenServer = createMenuButton("Yazy Server Hub", Color3.fromRGB(255, 150, 0))
local btnSoon = createMenuButton("Soon...", Color3.fromRGB(100, 100, 100))
btnSoon.Active = false
btnSoon.AutoButtonColor = false

-- PÁGINAS: PLACEHOLDERS (LocalPlayer, Misc, Gráficos)
local function createPlaceholderText(page, texto)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 1, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = texto
	lbl.TextColor3 = Color3.fromRGB(100, 100, 100)
	lbl.Font = Enum.Font.GothamSemibold
	lbl.TextSize = 18
	lbl.Parent = page
end
createPlaceholderText(pages["LocalPlayer"], "Opções de LocalPlayer em breve...")
createPlaceholderText(pages["Misc"], "Funções Misc em breve...")
createPlaceholderText(pages["Gráficos"], "Ajustes Gráficos em breve...")

-- PÁGINA: SOBRE NÓS
local lblCreditos = Instance.new("TextLabel")
lblCreditos.Size = UDim2.new(1, 0, 1, 0)
lblCreditos.BackgroundTransparency = 1
lblCreditos.Text = "Made by thiagopla_14"
lblCreditos.TextColor3 = Color3.fromRGB(138, 43, 226)
lblCreditos.Font = Enum.Font.GothamBlack
lblCreditos.TextSize = 24
lblCreditos.Parent = pages["Sobre Nós"]

-- Ativar a primeira aba por padrão
switchTab("Hubs")

-- ==========================================
-- 🪟 SISTEMA DE SUB-HUBS (JANELAS ARRASTÁVEIS)
-- ==========================================
local windows = {}

local function createSubHub(nome, corBorda)
	local win = Instance.new("Frame")
	win.Size = UDim2.new(0, 240, 0, 180)
	win.Position = UDim2.new(0.5, -120, 0.5, -90)
	win.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	win.Visible = false
	win.Parent = screenGui
	Instance.new("UICorner", win).CornerRadius = UDim.new(0, 8)
	
	local stroke = Instance.new("UIStroke", win)
	stroke.Color = corBorda
	stroke.Thickness = 2
	
	Instance.new("UIDragDetector", win)
	
	local topbarSub = Instance.new("Frame")
	topbarSub.Size = UDim2.new(1, 0, 0, 30)
	topbarSub.BackgroundTransparency = 1
	topbarSub.Parent = win
	
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(0.8, 0, 1, 0)
	title.Position = UDim2.new(0.05, 0, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = nome
	title.TextColor3 = corBorda
	title.Font = Enum.Font.GothamBold
	title.TextSize = 14
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = topbarSub
	
	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 30, 0, 30)
	closeBtn.Position = UDim2.new(1, -30, 0, 0)
	closeBtn.BackgroundTransparency = 1
	closeBtn.Text = "-"
	closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeBtn.Font = Enum.Font.GothamBlack
	closeBtn.TextSize = 20
	closeBtn.Parent = topbarSub
	
	closeBtn.MouseButton1Click:Connect(function()
		win.Visible = false
	end)
	
	local content = Instance.new("Frame")
	content.Size = UDim2.new(1, -20, 1, -40)
	content.Position = UDim2.new(0, 10, 0, 35)
	content.BackgroundTransparency = 1
	content.Parent = win
	
	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 10)
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	listLayout.Parent = content

	table.insert(windows, win)
	return win, content
end

local function createBigButton(texto, corBorda, parent)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 45)
	btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	btn.Text = texto
	btn.TextColor3 = Color3.fromRGB(240, 240, 240) -- Texto branco
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	local stroke = Instance.new("UIStroke", btn)
	stroke.Color = corBorda
	stroke.Thickness = 1.5
	btn.Parent = parent
	return btn
end

-- 1. TWEENING HUB
local tweenWin, tweenContent = createSubHub("Yazy Tweening Hub", Color3.fromRGB(0, 255, 255))
local btnTweenUltima = createBigButton("Tweening Última Base", Color3.fromRGB(0, 255, 255), tweenContent)
local btnTweenVoltar = createBigButton("Tweening Voltar", Color3.fromRGB(0, 255, 255), tweenContent)

btnTweenUltima.MouseButton1Click:Connect(function() voarPara(posBase, 3000) end)
btnTweenVoltar.MouseButton1Click:Connect(function() voarPara(posVoltar, 3000) end)
btnOpenTween.MouseButton1Click:Connect(function() tweenWin.Visible = true end)

-- 2. TP HUB
local tpWin, tpContent = createSubHub("Yazy TP Hub", Color3.fromRGB(255, 0, 255))
local btnTpUltima = createBigButton("TP Última Base", Color3.fromRGB(255, 0, 255), tpContent)
local btnTpVoltar = createBigButton("TP Voltar", Color3.fromRGB(255, 0, 255), tpContent)

btnTpUltima.MouseButton1Click:Connect(function() voarPara(posBase, 50000) end)
btnTpVoltar.MouseButton1Click:Connect(function() voarPara(posVoltar, 50000) end)
btnOpenTP.MouseButton1Click:Connect(function() tpWin.Visible = true end)

-- 3. COLLECT HUB
local collectWin, collectContent = createSubHub("Yazy Collect Hub", Color3.fromRGB(0, 255, 100))
local btnToggleCollect = createBigButton("Auto Collect: OFF", Color3.fromRGB(255, 50, 50), collectContent)

btnToggleCollect.MouseButton1Click:Connect(function()
	autoCollectAtivo = not autoCollectAtivo
	if autoCollectAtivo then
		btnToggleCollect.Text = "Auto Collect: ON"
		btnToggleCollect:FindFirstChild("UIStroke").Color = Color3.fromRGB(0, 255, 100)
	else
		btnToggleCollect.Text = "Auto Collect: OFF"
		btnToggleCollect:FindFirstChild("UIStroke").Color = Color3.fromRGB(255, 50, 50)
	end
end)
btnOpenCollect.MouseButton1Click:Connect(function() collectWin.Visible = true end)

-- 4. SERVER HUB
local serverWin, serverContent = createSubHub("Yazy Server Hub", Color3.fromRGB(255, 150, 0))
local btnServerHop = createBigButton("Server Hop", Color3.fromRGB(255, 150, 0), serverContent)

btnServerHop.MouseButton1Click:Connect(function()
	btnServerHop.Text = "Procurando Servidor..."
	serverHop()
end)
btnOpenServer.MouseButton1Click:Connect(function() serverWin.Visible = true end)


-- ==========================================
-- 📱 SISTEMA DE ABRIR/FECHAR (MOBILE E PC)
-- ==========================================
local function toggleUI()
	mainFrame.Visible = not mainFrame.Visible
	-- Removida a lógica que fechava os sub-hubs. Agora eles ficam intactos!
end

if isMobile then
	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Size = UDim2.new(0, 50, 0, 50)
	toggleBtn.Position = UDim2.new(0, 10, 0.5, -25)
	toggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	toggleBtn.Text = "Y"
	toggleBtn.TextColor3 = Color3.fromRGB(138, 43, 226)
	toggleBtn.Font = Enum.Font.GothamBlack
	toggleBtn.TextSize = 24
	toggleBtn.Parent = screenGui
	
	Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
	local stroke = Instance.new("UIStroke", toggleBtn)
	stroke.Color = Color3.fromRGB(138, 43, 226)
	stroke.Thickness = 2
	Instance.new("UIDragDetector", toggleBtn)
	
	toggleBtn.MouseButton1Click:Connect(toggleUI)
else
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftControl then
			toggleUI()
		end
	end)
end
