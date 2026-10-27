local LocalPlayer = game.Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ToonsPanelV1_0"
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 200,0, 200)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundTransparency = 0.4
MainFrame.BackgroundColor3 = Color3.new(0.0980392, 0.0980392, 0.0980392)
MainFrame.Parent = ScreenGui

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 5)
UIPadding.PaddingLeft = UDim.new(0, 5)
UIPadding.Parent = MainFrame

local IsClickedMusic = false
local isClickedLight = false
local isClickedEnemy = false
local db = false
local isClickedWalls = false
local isCreatedSound1 = false
local isCreatedSound2 = false

local MobsFolderTable = {
	["Mobs"] = true,
	["Entities"] = true,
	["Enemies"] = true,
	["MonsterFolder"] = true,
	["Monsters"] = true,
}
local bla = nil

local function SetupUIThing(UIType: string, where, side: Enum.HorizontalAlignment)
	if where == nil or UIType == nil then return end
	if UIType == "Layout" then
		if side == nil then side = Enum.HorizontalAlignment.Left end
		local NewLayout = Instance.new("UIListLayout")
		NewLayout.Padding = UDim.new(0, 5)
		NewLayout.HorizontalAlignment = side
		NewLayout.Parent = where
	elseif UIType == "Corner" then
		local NewCorner = Instance.new("UICorner")
		NewCorner.CornerRadius = UDim.new(0, 5)
		NewCorner.Parent = where
	elseif UIType == "Drag" then
		local DragDec = Instance.new("UIDragDetector")
		DragDec.Parent = where
	end
end

local function SetupUIThings2(UIType: string, strokeType: string, towhere, num: number, color: Color3)
	if towhere == nil or UIType == nil or strokeType == nil then return end
	if UIType == "Stroke" and strokeType == "border" then
		local Stroke = Instance.new("UIStroke")
		Stroke.Thickness = num 
		Stroke.Color = color
		Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		Stroke.Parent = towhere
	elseif UIType == "Stroke" and strokeType == "text" then
		local Stroke = Instance.new("UIStroke")
		Stroke.Thickness = num 
		Stroke.Color = color
		Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		Stroke.Parent = towhere
	end
end

local function CreateNewImbaSound(Stype, obj)
	if obj == nil and Stype == "67" then return end

	if Stype == "background" and not isCreatedSound1 then
		if isCreatedSound1 then return end
		isCreatedSound1 = true
		local newSound = Instance.new("Sound")
		newSound.SoundId = "rbxassetid://140313951294856"
		newSound.Name = "NewMusic"
		newSound.Volume = 0.2
		newSound.Parent = game.SoundService
		newSound:Play()
		newSound.Looped = true
	elseif Stype == "67" and not isCreatedSound2 then
		local NewImbaSound = Instance.new("Sound")
		NewImbaSound.Name = "Imba"
		NewImbaSound.SoundId = "rbxassetid://103561309094892"
		NewImbaSound.Volume = 0.5
		NewImbaSound.Parent = obj
		NewImbaSound:Play()
	end
end

local function createHighlightButton(button, getTargets, color)
	local isClicked = false
	local cooldown = false
	button.MouseButton1Up:Connect(function()
		if cooldown then return end
		cooldown = true
		if isClicked then
			isClicked = false
			for _, mob in pairs(getTargets()) do
				for _, obj in pairs(mob:GetDescendants()) do
					if obj:IsA("Highlight") then obj:Destroy() end
				end
			end
		else
			isClicked = true
			for _, mob in pairs(getTargets()) do
				if not mob:FindFirstChildWhichIsA("Highlight") then
					local high = Instance.new("Highlight")
					high.FillColor = color
					high.OutlineColor = color
					high.Parent = mob
				end
			end
		end
		task.delay(1, function() cooldown = false end)
	end)
end

local function SetupNewUIObj(ClassObj, Text: string, Objtype: string)
	if Text == nil or not ClassObj then return end

	if ClassObj == "Button" then
		if Objtype == nil then return end
		local NewButton = Instance.new("TextButton")
		NewButton.BackgroundTransparency = 0
		NewButton.Size = UDim2.new(0, 180, 0, 25)
		NewButton.BackgroundColor3 = Color3.new(0.0509804, 0.0509804, 0.0509804)
		NewButton.TextColor3 = Color3.new(1, 1, 1)
		NewButton.Text = Text
		NewButton.TextScaled = true
		NewButton.FontFace = Font.fromName("SourceSans", Enum.FontWeight.Bold)
		NewButton.Parent = MainFrame

		local NewUICorner = Instance.new("UICorner")
		NewUICorner.CornerRadius = UDim.new(0, 5)
		NewUICorner.Parent = NewButton

		SetupUIThings2("Stroke", "border", NewButton, 2, Color3.new(0, 0, 0))

		if Objtype == "music" then
			local cooldown = false
			NewButton.MouseButton1Up:Connect(function()
				if cooldown then return end
				cooldown = true
				local existingMusic = game.SoundService:FindFirstChild("NewMusic")
				if existingMusic then
					existingMusic:Destroy()
					isCreatedSound1 = false
					for _, folder in pairs(workspace:GetDescendants()) do
						if MobsFolderTable[folder.Name] then
							for _, mob in pairs(folder:GetChildren()) do
								if not mob:IsA("Model") then continue end
								local targetPart = mob:FindFirstChild("HumanoidRootPart")
									or mob:FindFirstChild("Head")
									or mob:FindFirstChildWhichIsA("BasePart")
								if targetPart then
									local sound = targetPart:FindFirstChild("Imba")
									if sound then sound:Destroy() end
								end
							end
						end
					end
				else
					isCreatedSound1 = false
					isCreatedSound2 = false
					for _, v in pairs(game:GetDescendants()) do
						if v:IsA("Sound") then
							v:Stop()
							v.Looped = false
						end
					end
					CreateNewImbaSound("background", "")
					for _, folder in pairs(workspace:GetDescendants()) do
						if MobsFolderTable[folder.Name] then
							for _, mob in pairs(folder:GetChildren()) do
								if not mob:IsA("Model") then continue end
								local targetPart = mob:FindFirstChild("HumanoidRootPart")
									or mob:FindFirstChild("Head")
									or mob:FindFirstChildWhichIsA("BasePart")
									or mob:FindFirstChildWhichIsA("UnionOperation")
									or mob:FindFirstChildWhichIsA("MeshPart")
								if targetPart then
									CreateNewImbaSound("67", targetPart)
									local sound = targetPart:FindFirstChildWhichIsA("Sound")
									if sound then
										sound.SoundId = "rbxassetid://103561309094892"
										sound:Play()
										task.spawn(function()
											while task.wait(3) do
												sound:Play()
											end
										end)
									end
								end
							end
						end
					end
				end
				task.delay(2, function() cooldown = false end)
			end)
		elseif Objtype == "light" then
			NewButton.MouseButton1Up:Connect(function()
				if isClickedLight then return end
				isClickedLight = true
				for i, v in pairs(game.Lighting:GetChildren()) do
					if i > 0 then
						v:Destroy()
					end
				end
			end)
		elseif Objtype == "walls" then
			local cooldown = false
			NewButton.MouseButton1Up:Connect(function()
				if cooldown then return end
				cooldown = true
				for _, v in pairs(workspace:GetDescendants()) do
					if string.find(v.Name, "Wall") then
						v:Destroy()
					end
				end
				task.delay(3, function() cooldown = false end)
			end)
		elseif Objtype == "Enemy" then
			createHighlightButton(NewButton, function()
				local result = {}
				for _, folder in pairs(workspace:GetDescendants()) do
					if MobsFolderTable[folder.Name] then
						for _, mob in pairs(folder:GetChildren()) do
							table.insert(result, mob)
						end
					end
				end
				return result
			end, Color3.fromRGB(255, 0, 0))
		elseif Objtype == "Players" then
			createHighlightButton(NewButton, function()
				local result = {}
				for _, player in pairs(game.Players:GetPlayers()) do
					if player.Character then
						table.insert(result, player.Character)
					end
				end
				return result
			end, Color3.fromRGB(0, 0, 255))


		end
	elseif ClassObj == "Label" then
		local NewLabel = Instance.new("TextLabel")
		NewLabel.BackgroundTransparency = 0
		NewLabel.Size = UDim2.new(0, 180, 0, 30)
		NewLabel.BackgroundColor3 = Color3.new(0.0509804, 0.0509804, 0.0509804)
		NewLabel.TextColor3 = Color3.new(1, 1, 1)
		NewLabel.Text = Text
		NewLabel.TextScaled = true
		NewLabel.FontFace = Font.fromName("SourceSans", Enum.FontWeight.Bold)
		NewLabel.Parent = MainFrame

		local NewUICorner = Instance.new("UICorner")
		NewUICorner.CornerRadius = UDim.new(0, 5)
		NewUICorner.Parent = NewLabel
	end
end

SetupUIThing("Layout", MainFrame, Enum.HorizontalAlignment.Center)
SetupUIThing("Corner", MainFrame)
SetupUIThing("Drag", MainFrame)
SetupUIThings2("Stroke", "border", MainFrame, 2, Color3.new(0.0862745, 0.0862745, 0.0862745))
SetupNewUIObj("Button","Change music to funny", "music")
SetupNewUIObj("Button", "Turn off all light", "light")
SetupNewUIObj("Button","Delete all exist walls(WIP)", "walls")
SetupNewUIObj("Button", "Enemies ESP", "Enemy")
SetupNewUIObj("Button", "Players ESP", "Players")
SetupNewUIObj("Label", "Horrors The Hollow Panel V1.2 By Xvg", "")
print("Successful loaded|V1.0 By Xvg")
