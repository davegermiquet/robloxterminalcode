local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local remoteEventSongPlaying = Instance.new("RemoteEvent", ReplicatedStorage)
remoteEventSongPlaying.Parent = ReplicatedStorage 
remoteEventSongPlaying.Name = "GetSongPlaying"

local sendSongPlaying = Instance.new("RemoteEvent", ReplicatedStorage)
sendSongPlaying.Parent = ReplicatedStorage
sendSongPlaying.Name = "SendSongPlaying" 

local remoteClientSongPlay =  Instance.new("RemoteEvent",ReplicatedStorage )
remoteClientSongPlay.Name = "ClientSongPlay"
remoteClientSongPlay.Parent = ReplicatedStorage 

local addMusicRequest = Instance.new("RemoteFunction",ReplicatedStorage)
addMusicRequest.Parent = ReplicatedStorage
addMusicRequest.Name = "AddMusicRequest"

local addMusicRequest = Instance.new("RemoteFunction",ReplicatedStorage)
addMusicRequest.Parent = ReplicatedStorage
addMusicRequest.Name = "MakeHttpRequest"
