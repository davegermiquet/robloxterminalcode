local StarterPack = game:GetService("StarterPack")
local module = {}
module.Folder = {}

function module.Folder:new(o)
	 o = o or {}
	 setmetatable(o, self)
     self.__index = self
   	 return o
end

function module.Folder:isFolderNode(folder)
		for k, v in pairs(self.folder.folders) do
			  if (k:gsub('%s*', '') == folder:gsub('%s*', ''))
			then
				return true
			end
		end
		return false
end

function module.Folder:getFolderNode(folder)
		for k, v in pairs(self.folder.folders) do
			  if (k:gsub('%s*', '') == folder:gsub('%s*', ''))
			then
				return v
			end
		end
		return self.dirNotFound
end


function module.Folder:setFolder(folder)
	self.folder = folder:new()
end	
	
function module.Folder:sendContentToExecute(commandToFind)
			for k, v in pairs(self.folder.commands) do
				if v == nil
				then
					continue
				end		
			  if (k:gsub('%s*', '') == commandToFind[1]:gsub('%s*', ''))
			then
				return v
			end
		end
		return self.folder.notFound 
	end

function module.Folder:lsContents()
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local getRoleForUser = ReplicatedStorage:WaitForChild('GetRoleForUser')
	  	local directories = ""
		local commandsAvailable = ""
		for k, v in pairs(self.folder.folders) do
				if v.permissions >= getRoleForUser:InvokeServer() then
			   directories = directories ..  "/" .. k .. "\n"
			end
		end
		for k, v in pairs(self.folder.commands) do
			commandsAvailable = commandsAvailable .. k .. "\n"
		end
		return string.format("%s",directories) .. string.format("%s",commandsAvailable) 	
end
return module
