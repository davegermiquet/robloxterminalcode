local ReplicatedStorage = game:GetService("ReplicatedStorage")
local getSongPlaying = ReplicatedStorage:WaitForChild('GetSongPlaying')
local clientSongPlaying =  ReplicatedStorage:WaitForChild('ClientSongPlay')
local sendSongPlaying =  ReplicatedStorage:WaitForChild('SendSongPlaying')

local soundInstance = Instance.new('Sound')
local playerStatus = {}
playerStatus.myPlayer = game.Players.LocalPlayer

List = {}

function List.pushleft (list, value)
    table.insert(list,1,value)
end

function List.pushright (list, value)
   table.insert(list,value)
end

function List.popleft (list)
 	local value = list[1]
    table.remove(list,1)
    return value   
end

function List.popright (list)
     local value = list[#list]
     table.remove(list,#list)
     return value
end

function List.size(list) 
	return #list
end

local musicQueue = {}

function IsValidSound(soundId) --either returns false or valid sound
    local con1, con2, yieldFolder, valid
    local sound = Instance.new("Sound", workspace)
    local function cleanup()
        con1:disconnect()
        con2:disconnect()
        yieldFolder.Name = "Different"
    end
    yieldFolder = Instance.new("Folder")
    con1 = game:GetService("LogService").MessageOut:connect(function(msg, msgType)
        if msgType ~= Enum.MessageType.MessageError then return end 
        if not msg:find(tostring(soundId)) then return end
        valid = false
        cleanup()
    end)    
    con2 = sound.Loaded:connect(function()
        valid = sound.TimeLength > 0
        cleanup()
    end)
    sound.SoundId = soundId
    if sound.IsLoaded then --already loaded
        cleanup()
        if sound.TimeLength == 0 then
            sound:Destroy()
            return false
        end
        return sound
    end
    yieldFolder.Changed:wait() --wait for either event to occur
    yieldFolder:Destroy()
    if not valid then sound:Destroy() end
    return valid and sound
end


local function songPlaying(song)
	if (not(song == nil)) then
		List.pushright(musicQueue,song)
	end
	sendSongPlaying:FireServer(soundInstance.isPlaying,List.size(musicQueue))
end

local function playMusic()
	if List.size(musicQueue) >= 1 then
	local musicToPlay = List.popleft(musicQueue)
	if (not(musicToPlay == nil)) then
	if (IsValidSound("rbxassetid://" .. musicToPlay)) then
	soundInstance = Instance.new('Sound')
	soundInstance.SoundId = "rbxassetid://" .. musicToPlay
	soundInstance.Looped = false
	soundInstance.Parent = game.Workspace
	soundInstance : Play()
	end
	end
	end
end

	
clientSongPlaying.OnClientEvent:Connect(playMusic)
getSongPlaying.OnClientEvent:Connect(songPlaying)
