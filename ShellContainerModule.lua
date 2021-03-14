local StarterPack = game:GetService("StarterPack")
local module = {}
local bufferLength = 13
module.Shell= {}

function module.Shell:new(o)
	 o = o or {}
	 self.pageBuffer = {}
	 self.pageCont = false
	 setmetatable(o, self)
     self.__index = self	
	 self.shownOnScreen = {}
     self.FolderContainer = require(StarterPack.NoteBookTool.FolderContainerModule).Folder:new()
     return o
end



function module.Shell:clearScreen()
		self.shownOnScreen = {}
		return ""
end


function module.Shell:toggleScreen(command)
	     if (self.screen.Visible == false)
		then
			    self.screen.Visible = true
		else
				self.screen.Visible = false
		end  
		return ""
end

function module.Shell:lsDir()
	return self.FolderContainer.lsContents(self.FolderContainer) ..'\n'
end


function module.Shell:notFound(commandToCall) 
	return "Could not find file or folder " .. commandToCall[1]
end

function module.Shell:callShellCommand(commandToCall) 
	
	local shellCommand = {
	chdir = self.changeDir,
	cd = self.changeDir,
	ls = self.lsDir,
	cls = self.clearScreen,
	stdout = self.toggleScreen
	}
	for k, v in pairs(shellCommand) do
			 if k:gsub('%s*', '') == commandToCall[1]:gsub('%s*', '')
			then
				return v
			end
		end
		return self.notFound
end

function module.Shell:changeDir(command)

	if (command[2] == nil)
	then
		return "no parameter specifed "
	end
	if (self.FolderContainer.isFolderNode(self.FolderContainer,command[2])) then
		local locationFolder = self.FolderContainer.getFolderNode(self.FolderContainer,command[2])
		self.setFolder(self,locationFolder)
		self.prompt.Text = command[2] .. '->'
		return ""
	else
		return " Folder not found\n"
	end
end

function module.Shell:setFolder(folder)
	self.FolderContainer.setFolder(self.FolderContainer,folder)
	self.prompt.Text = self.FolderContainer.folder.Name .. "->"
end

function module.Shell:setScreen(screen)
	self.screen = screen
end

function module.Shell:setPrompt(prompt)
	self.prompt  = prompt 
end


local function trimShowOnScreen(screenShowing)
	
	local newShowing = {}
	local count = 1;
		if #screenShowing > bufferLength then
			
			for i = #screenShowing - bufferLength,#screenShowing,1
			do
				newShowing[count] = screenShowing[i]
				count = count + 1
			end
		end
	return newShowing
end

local function addArray(array1,array2)
	local count = #array1 + 1
	for i =1,#array2,1
	do
		array1[count] = array2[i]
		count = count + 1
	end
	return array1
end
local function splitTheBufferToScreen(self)
    local array1 = {}
	local count = 1
	for i =1,bufferLength-2 or #self.pageBuffer,1
	do
		array1[count] = self.pageBuffer[i]
		count = count + 1
	end
	local tmpDeletion = {}
	count = 1
	for i = bufferLength-2, #self.pageBuffer-2,1
	do
		tmpDeletion[count] = self.pageBuffer[i]
		count = count + 1
	end
	self.pageBuffer = tmpDeletion
	return array1
end
function module.Shell:executeCommand(command)
	self.screen.Text = ""
	local output = ""
	local function split(parameter,newLine)
		local commandSplit = {}
		local splitOn = "%w+ *"
		if newLine then
			splitOn = '[^\r\n]+'
		end
		for i in string.gmatch(parameter,splitOn) do
   		  table.insert(commandSplit,i)
		end
		return commandSplit
	end
	
	local commandToCall = split(command:lower())
	if self.pageCont ~= true
	then
		output = self.callShellCommand(self,commandToCall)(self,commandToCall)
	    if output == "Could not find file or folder " .. commandToCall[1] then
		output = self.FolderContainer.sendContentToExecute(self.FolderContainer,commandToCall)(self.FolderContainer.folder,commandToCall)
		end
		output =  self.prompt.Text  .. command .. '\n' .. output
	end
    if (output ~= nil or self.pageCont) then
	    local tempVar = split(output,true)
	    if #tempVar > bufferLength then
		   self.pageBuffer = tempVar
		   self.pageCont = true
		end
		if self.pageCont == true then
			tempVar = splitTheBufferToScreen(self)
			tempVar[#tempVar + 1] = "-- continue type continue and enter or done to stop --\n"
		end
		if #self.pageBuffer == 0 and self.pageCont == true or commandToCall[1] == "done" then
			if commandToCall[1] == "done" then
				tempVar = {}
				tempVar[1] = "-- done --\n"
			end
			tempVar[#tempVar + 1] = "-- done --\n"
			self.pageCont = false
			self.pageBuffer ={}
		end
		self.showOnScreen = addArray(self.shownOnScreen,tempVar)
		if (#self.shownOnScreen > bufferLength )
		then
			self.shownOnScreen = trimShowOnScreen(self.shownOnScreen)
		end
		for i = 1,#self.shownOnScreen,1
			do
				self.screen.Text = self.screen.Text .. self.shownOnScreen[i] .. "\n"
			end
		end
		end
return module
