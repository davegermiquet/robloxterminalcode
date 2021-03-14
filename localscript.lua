local tool = script.Parent
local StarterPack = game:GetService("StarterPack")
local commandModules = require(StarterPack.NoteBookTool.ShellModule).Shell
local rootFolder = require(StarterPack.NoteBookTool.RootFolderContainerModule).SingleFolder
local UserInputService = game:GetService("UserInputService")	
local targetGui = Instance.new("ScreenGui")
local label = Instance.new("TextLabel", targetGui)
local computerScreen = Instance.new("TextLabel", targetGui)
local textBox = Instance.new("TextBox", targetGui)
local colorNormal = Color3.new(0, 0, 0) -- black
local colorCursor = Color3.new(.5, 1, .5) -- greenl

		
label.Text = "root->"
label.BorderSizePixel=0
label.Position = UDim2.new(0, 0, 0, 0)
label.Size = UDim2.new(0, 200, 0, 30)

textBox.BackgroundColor3 = colorNormal;
textBox.TextColor3 = colorCursor;
textBox.Position =  UDim2.new(0, 200, 0, 0)
textBox.Size = UDim2.new(0, 200, 0, 30)
textBox.Text = ""
textBox.ClearTextOnFocus = true
textBox.BorderSizePixel=0

computerScreen.Position = UDim2.new(0, 0, 0, 30)
computerScreen.Size = UDim2.new(0, 400, 0, 300)
computerScreen.BackgroundColor3 = colorNormal;
computerScreen.TextColor3 = colorCursor
computerScreen.TextXAlignment = 1
computerScreen.TextYAlignment = 1


computerScreen.Text =""
computerScreen.Visible = false

local targetParent = game.Players.LocalPlayer.PlayerGui 

local playerStatus = {}

playerStatus.myPlayer = game.Players.LocalPlayer
playerStatus.myChar = playerStatus.myPlayer.Character
playerStatus.hum = tool:FindFirstChild("Humanoid")
playerStatus.isFlying = false
buffer = {}

commandModules:new()
rootFolder:new()
commandModules:setPrompt(label)
commandModules:setScreen(computerScreen)
commandModules:setFolder(rootFolder)


	local function onFocusLost(enterPressed)
		if enterPressed then
			if (not (textBox.text:gsub('%s*', '') == "")) then
			commandModules:executeCommand(textBox.Text)
			textBox.Text = ""
			end
		end
	end
    textBox.FocusLost:Connect(onFocusLost)

local function onActivated()
		textBox:CaptureFocus ()
end

local function onDeActivated()
		textBox:ReleaseFocus (false ) 
        if targetGui.Parent then
            targetGui.Parent = nil
        else
            targetGui.Parent = targetParent
        end
end
tool.Activated:Connect(onActivated)	

tool.Deactivated:Connect(onDeActivated)	