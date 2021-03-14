local StarterPack = game:GetService("StarterPack")
local module = {}

module.SingleFolder = {}
setmetatable(module.SingleFolder, {__index = require(StarterPack.NoteBookTool.BaseFolderModule).BaseFolder})

function module.SingleFolder:new(o)
	 o = o or {}
	 setmetatable(o, self)
     self.__index = self
	 self.Name = "root"
	 print(self.Name)
     self.folders = {
   	 sudo = false,
	 music = require(StarterPack.NoteBookTool.MusicFolderContainerModule).SingleFolder
	 }
	 self.commands = {
	}
	return o
end

return module
