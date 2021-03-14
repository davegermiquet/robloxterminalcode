local StarterPack = game:GetService("StarterPack")
local UserPermissions = require(StarterPack.NoteBookTool.PermissionsEnum).ServerENUM
local module = {}

module.SingleFolder = {}

setmetatable(module.SingleFolder, {__index = require(StarterPack.NoteBookTool.BaseFolderModule).BaseFolder})

module.SingleFolder.permissions = UserPermissions.UserPermissions.RegularAdmin

function module.SingleFolder:new(o)
	 o = o or {}
	 setmetatable(o, self)
     self.__index = self
	 self.Name = "admin"
 	 self.permissions = UserPermissions.UserPermissions.RegularAdmin
     self.folders = {
	   root = require(StarterPack.NoteBookTool.RootFolderContainerModule).SingleFolder
    }
	 self.commands = {
		adduser = self.addUser
	}
	return o
end

 function module.SingleFolder:addUser(command)
 local returnValue = "Invalid Command"
	if command[2] and command[3] then
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local addAdminToServer = ReplicatedStorage:WaitForChild('AddAdminToServer')
		returnValue = addAdminToServer:InvokeServer(command[2],command[3]) 
	end
	return returnValue 
end

return module
