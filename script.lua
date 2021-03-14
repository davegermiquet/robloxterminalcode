local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")


local getSongPlaying = ReplicatedStorage:WaitForChild('GetSongPlaying')
local clientSongPlaying =  ReplicatedStorage:WaitForChild('ClientSongPlay')
local sendSongPlaying =  ReplicatedStorage:WaitForChild('SendSongPlaying')
local addMusicRequest =  ReplicatedStorage:WaitForChild('AddMusicRequest')
local makeHttpRequest =  ReplicatedStorage:WaitForChild('MakeHttpRequest')

local musicPlayer = {}
local musicQueue = {}
local maxQueue = 0
local serviceMusicOn = true
local lastSong = 2431958282
local INTERVAL = 5
local elapsed = 0

RunService.Heartbeat:Connect(function(dt)
    elapsed = elapsed + dt
    if elapsed >= INTERVAL then
        elapsed = elapsed - INTERVAL
        if List.size(musicQueue) >= 1 then
    	local musicToAdd = List.popleft(musicQueue)
		print(musicToAdd)
		if (not(musicToAdd == nil)) then
		getSongPlaying:FireAllClients(musicToAdd)
		end
		else
			getSongPlaying:FireAllClients(nil)
		end	
    end
end)


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

	
local function playSongOnClient(player,isPlaying,totalQueue)
	if (not(isPlaying)) then
		clientSongPlaying:FireClient(player)
	end
	if (maxQueue < totalQueue) then
		maxQueue = totalQueue
	end
end
 

local function onAddMusicRequested(player,command)
		List.pushright(musicQueue,command[2])
		lastSong = command[2]
		return "Acknowledged music request ".. command[2]  .. " your song will be played in " .. maxQueue .. " songs"
end


local function makeHttpRequested(player,urlToGet)
	local response
	local data
	-- Use pcall in case something goes wrong
	pcall(function ()
		response = HttpService:GetAsync(urlToGet)
	end)
	-- Did our request fail or our JSON fail to parse?
	return response
end
	
game.Players.PlayerAdded:Connect(function(player)
		List.pushright(musicQueue,lastSong)
end)



sendSongPlaying.OnServerEvent:Connect(playSongOnClient) 
addMusicRequest.OnServerInvoke = onAddMusicRequested
makeHttpRequest.OnServerInvoke = makeHttpRequested
