local StarterPack = game:GetService("StarterPack")
local httpDomClientAndReader = require(StarterPack.NoteBookTool.HTTPDomReader.HtmlDomToVar)
local RobloxSongParser = require(StarterPack.NoteBookTool.HTTPDomReader.RobloxSongParser)


local module = {}

module.SingleFolder = {}

setmetatable(module.SingleFolder, {__index = require(StarterPack.NoteBookTool.BaseFolderModule).BaseFolder})

function module.SingleFolder:new(o)
	 o = o or {}
	 setmetatable(o, self)
     self.__index = self
	 self.Name = "music"
     self.folders = {
	   root = require(StarterPack.NoteBookTool.RootFolderContainerModule).SingleFolder
    }
	 self.commands = {
		audio = self.requestSongMusicForGame,
		topsongs = self.printTopSongs,
		newsongs = self.printNewSongs
	}
	return o
end

function module.SingleFolder:requestSongMusicForGame(command)
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local addMusicRequest = ReplicatedStorage:WaitForChild('AddMusicRequest')
	if (command[2] == nil)
	then
          return 'no songs specified \n'
	else
		  print(command[2])
		  return addMusicRequest:InvokeServer(command) ..  '\n'
	end
end

function module.SingleFolder:printNewSongs(command)
	local baseUrl = "https://robloxsong.com/"
	local relativeUrl = "new-songs"
	local returnValue = ""
	local allSongs = callRobloxResponse(command,baseUrl,relativeUrl)
	for tag,value in ipairs(allSongs)
	do
		returnValue = returnValue ..  value.songName .. " " .. value.songId .. "\n"
	end
	return returnValue 
end

 function module.SingleFolder:printTopSongs(command)
	local baseUrl = "https://robloxsong.com/"
	local relativeUrl = "top-year"
	local returnValue = ""
	local allSongs = callRobloxResponse(command,baseUrl,relativeUrl)
	for tag,value in ipairs(allSongs)
	do
		returnValue = returnValue ..  value.songName .. " " .. value.songId .. "\n"
	end
	return returnValue 
end

function callRobloxResponse(command,baseUrl,relativeUrl)
	local HtmlDocumentToVar = httpDomClientAndReader.makeCallToServer(nil,baseUrl,relativeUrl)
	local allTableElements = httpDomClientAndReader.parseSongs(HtmlDocumentToVar,'table')
	local allSongs = RobloxSongParser.getSongsObject(allTableElements)
	return allSongs
end
			
return module	
