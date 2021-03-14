local module = {}

	module.computerScreen ={}
	module.prompt = {}
	module.inputCommand = {}	
	module.playerStatus = {}
	module.remoteEvent = {}
	
	  function module.initSettings(commonFeatures)
		module.computerScreen = commonFeatures.computerScreen
		module.prompt = commonFeatures.label
		module.inputCommand = commonFeatures.textBox
		module.playerStatus = commonFeatures.playerStatus
		module.remoteEvent = commonFeatures.remoteEvent
		
	end
	
	function module.writeAcknowledged(command)
		module.computerScreen.Text = module.computerScreen.Text ..  "Remote - Acknowledged from server" .. '\n'
	end
	

    function module.lsFolder(commandToCall,command)
		local computerScreen = module.computerScreen
		local directories = ""
		local commandsAvailable = ""
		
		for k, v in pairs(commandToCall) do
			if (v == false) then
				directories = directories ..  "/" .. k .. "\n"
			else 
				commandsAvailable = commandsAvailable .. k .. "\n"
			end
		end
		module.computerScreen.Text = module.computerScreen.Text .. string.format("%s",directories) .. string.format("%s",commandsAvailable) 
	end

      function module.callAdmin(commandToCall,command)
	    module.prompt.Text = "admin->"
end

      function module.toggleFly(commandToCall,command)
		if (module.playerStatus.isFlying == false) then
			module.playerStatus.hum:ChangeState(6)
				module.playerStatus.isFlying = true
		else
			module.playerStatus.hum:ChangeState(16)
			module.playerStatus.isFlying = false
		end			
	end
	

      function module.exitAdmin(commndToCall,command)
	    module.prompt.Text = "root->"
      end
	
	
	function module.clearScreen(commandToCall,commands)
		module.computerScreen.Text = "";
	end
	
	function module.chFolder(commandToCall,commands)
		if (commands[2] == "music") then
			module.prompt.Text = "music->"
	    else
			module.prompt.Text = "root->"
		end
		
	end
	
	
  module.adminAvailable ={
		toggleFly = module.toggleFly,
		ls = module.lsFolder,
		cls = module.clearScreen,
		exit = module.exitAdmin
   }

  module.musicAvailable = {
		audio = module.requestSongMusicForGame,
		ls = module.lsFolder,
		stdout = module.toggleScreen,
		cls = module.clearScreen,
		chdir = module.chFolder
}


	
	function module.notFound(commandToCall,command)
		module.computerScreen.Text = module.computerScreen.Text .. "File Not Found" .. "\n"
	end
	
	function module.findCommandToRun(subMenu,commands,commandToFind)
		for k, v in pairs(commands) do
			if v == nil
			then
				continue
			end
			print(k)
			print(commandToFind)
		  if (k:gsub('%s*', '') == commandToFind:gsub('%s*', ''))
		then
			return v
		end
		end
		return module.notFound
	end
	
	function split(commands)
		local commandSpit = {}
		for i in string.gmatch(commands, "%w+ *") do
   		  table.insert(commandSpit,i)
		end
		return commandSpit
	end
	
	function module.executeCommand(commandToRun)
    local commandToCall

    local command=split(commandToRun," +")
	if (module.prompt.Text =="root->")
	then
		commandToCall = module.rootAvailable
		
	elseif (module.prompt.Text =="admin->")
	then
		commandToCall = module.adminAvailable
	elseif (module.prompt.Text == "music->")
	then
	    commandToCall = module.musicAvailable
	end
	module.findCommandToRun(nil,commandToCall,command[1])(commandToCall,command)
end


return module
