local HttpService = game:GetService("HttpService")
math.randomseed(os.time())	
local module = {}
local uniqueIds = {}
local ENUM = {}
local waitPeriod =0
	local foundFirstTag = false
	local startCollecting = true
	
	ENUM.CharacterFound = {
	EXCLAMATION = 1,
	GREATERTHAN = 2,
	LESSTHAN = 3,
	FORWARDSLASH = 4,
	NORMALLETTER = 5,
	SPACETYPE = 6,
	CARRIAGE = 7,
	NEWLINE = 8,
	SPACE = 9
	}
	
	ENUM.ROOTTAG = {
	NOTFOUND = 1,
	RECEIVED = 2,
	ASSIGNED =3,
	DONE = 4
	}
	
	ENUM.STATE = {
			 RECEIVEDTAG=1,
			RECEIVEDENDTAG=2,
			INSERTTAG = 3,
			INTAG = 4,
			GOTBODY =5,
			INENDTAG =6,
			SPECIALTAG = 7,
			INLINETAG = 8,
			TEXT = 9
	}
function getMilliSecond()	
	local foundMiliSecond = true
	local num = 1000000
	local result
	while foundMiliSecond do
		local x = os.time()
		local s = 0
		for i=1,num do s = s + i end
		result = os.time()
		num = num + 100000
		if tonumber(result - x) >=1 then
			foundMiliSecond = false
		end
	end
	return num/100
end
local function sleep(n)  -- seconds
  local s = 0
  local timeWait = waitPeriod *n
  for i=1,timeWait do s = s + i end

end	
local function split(parameter)
		local commandSplit = {}
		if string.match(parameter, "([^%s]+)") then
			for i in string.gmatch(parameter, "([^%s]+)") do
				 table.insert(commandSplit,i)
			end
			return commandSplit
	else
			table.insert(commandSplit,parameter)
			return commandSplit
		end
	end
	

local function mergetable(element,skipElement) 
	local newElement = {}

	for k, v in pairs(element) do 
			if (k == skipElement)
			then
				continue
			end
		table.insert(newElement,v)
	end
	return table.concat(newElement,' ')
end
	
local function returnTagWithAttributes (paramWord)
	local rootTag
	local attrib
	local rootTagWithAttributes = paramWord 
			local rootTagElements = split(rootTagWithAttributes)
			rootTag = rootTagElements[1]
			if (#rootTagElements > 1)
		then
			attrib = mergetable(rootTagElements,1)
		else
			attrib =""
		end
		local strToReturn = {
		tag = rootTag,
		attribs = attrib
		}
		return strToReturn
end

local function findStateWord(parameter)
	if (parameter:sub(1,1) == '!') then 
		return ENUM.STATE.SPECIALTAG
	end
	if string.match(parameter, "^meta.+") or string.match(parameter,"^link.+") or 
	   string.match(parameter, "^img.+")  or string.match(parameter,"^input.+") then
		return ENUM.STATE.SPECIALTAG
	end
	return ENUM.STATE.RECEIVEDTAG
end

local function addDomToTable(response,rootEndTag)
	
	local uuidLength = 50
	local rootTag = ""	
	local nextUid  = ""
	local currentTagName = ""
	local charInDocumentAt = ""
	local HtmlTagToTable = {}
	local currentChar = ENUM.CharacterFound.NORMALLETTER
	local currentState = ENUM.STATE.TEXT
	local rootTagStatus = ENUM.ROOTTAG.NOTFOUND
	local tagTreeArray = {}
	local inlineTag = false
	
	
function deepcopy(orig, copies)
	copies = copies or {}
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		if copies[orig] then
			copy = copies[orig]
		else
			copy = {}
			copies[orig] = copy
			for orig_key, orig_value in next, orig, nil do
				copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
			end
			setmetatable(copy, deepcopy(getmetatable(orig), copies))
		end
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end


	local function fixTagEntry(paramWord)
		local lastIndex = #paramWord
		local firstIndex = 1
		
		if (paramWord:sub(#paramWord,#paramWord) == '>') then
			  lastIndex = tonumber(#paramWord - 1)
		end
		if (paramWord:sub(1,1) == '<')then
			firstIndex = firstIndex + 1
		end	
		local newword = string.sub(paramWord,firstIndex,lastIndex)
		return newword
	end
	
	local function uuid(length)
		local calledValue
		local function generateUuid()
			local value = ""
			local charset = {}
			-- qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890
			for i = 48,  57 do table.insert(charset, string.char(i)) end
			for i = 65,  90 do table.insert(charset, string.char(i)) end
			for i = 97, 122 do table.insert(charset, string.char(i)) end
			for i = 1,length do 
				value = value .. 	 charset[math.random(1, #charset)]
			end
		   return value
		end
	  calledValue = generateUuid()
	  if uniqueIds[calledValue] == nil  then
		 uniqueIds[calledValue] = true
	  else
		   while uniqueIds[calledValue] ~= nil
		do
			calledValue = generateUuid()
		end
			uniqueIds[calledValue] = true
	end
	return tostring(calledValue)
	end

	local function findNextUid(paramNextUid,mytable)
	 local returnValue
	 local skipValue
	  for tag,value in pairs(mytable)
		do
			if (tostring(value.nextUid) == tostring(paramNextUid)) then
				returnValue = value
				break
			elseif  value.nextUid ~= nil then
				returnValue = findNextUid(paramNextUid,value.child)	
				if (returnValue ~= nil) then
					break
				end
			end
		end
		return returnValue
	end
	
	local function traverseThoughTable(mytable,o)
		local tableToReturn
		local index
		local found = false
		if tostring(mytable.nextUid) == tostring(o.parentUid) then
			tableToReturn = mytable
		else
			if mytable.nextUid == nil then
			index = mytable
			else
			index = mytable.child
			end
			for tag,value in pairs(index)
			do
				if value.isArray == true then
					continue	
				end
				if value.nextUid == nil then
					continue
				end
				if rootEndTag == tag and o.parentUid == value.nextUid then
					tableToReturn = value
					break
				end
				tableToReturn = traverseThoughTable(value,o)
				if tostring(tableToReturn.nextUid) == tostring(o.parentId) then
					break
				end
			end
		end	
		return tableToReturn
	end
	
	
	local function returnNumOfChild(childFound,tag,o)
		local num = ""	
		local last = 0
		for key,value in pairs(childFound) do
			if (string.match(key,'.+#%d+')) then
				num = string.match(key,'.+#(%d+)')
				if tonumber(num) > last then
					last = tonumber(num ) 
				end
			elseif value.isArray
			then
				continue
			else
				return 1
			end
		end
		return last + 1
	end
	
	local function setAttribute(mytable,o,tagNameChild)
		local childFound = traverseThoughTable(mytable,o)   
		if childFound.child == nil then
		   childFound.child = {}
		end	
		if childFound.child[tagNameChild] == nil
		then 
			childFound.child[tagNameChild] = {}
			childFound.child[tagNameChild] = o
			childFound.child[tagNameChild].isArray = false
								
		elseif childFound.child[tagNameChild].isArray then
			local num = returnNumOfChild(childFound.child,tagNameChild,o)
			childFound.child[tagNameChild .. "#" .. num]  = {}
			childFound.child[tagNameChild .. "#" .. num] =  o
			childFound.child[tagNameChild .. "#" .. num].isArray = false	
		else
			local num = returnNumOfChild(childFound.child,tagNameChild,o)
			childFound.child[tagNameChild .. "#" .. num]  = {}
			childFound.child[tagNameChild .. "#" .. num] = deepcopy(childFound.child[tagNameChild])
			childFound.child[tagNameChild .. "#" .. num].isArray = false
			childFound.child[tagNameChild .. "#" .. num + 1]  = {}
			childFound.child[tagNameChild .. "#" .. num + 1] = o
			childFound.child[tagNameChild .. "#" .. num + 1].isArray = false
			childFound.child[tagNameChild].isArray = true
		  end
	end
	
   local word = ""
   local bodyContent = ""
   for i = 1, #response do
	local c = response:sub(i,i)
	local htmlInfo = {}
	  if (c:match('\r')) then
		 currentChar = ENUM.CharacterFound.CARRIAGE
		   continue
	  elseif (c:match('\n')) then
		 currentChar = ENUM.CharacterFound.NEWLINE
		 continue
	  elseif ( c:match('%s')) then
		  if (currentChar ==  ENUM.CharacterFound.SPACETYPE) then
			  currentChar = ENUM.CharacterFound.SPACETYPE
			  continue 
		  else
			 currentChar = ENUM.CharacterFound.SPACETYPE
		end
	  elseif (c == '<') then
		   currentChar = ENUM.CharacterFound.LESSTHAN
	  elseif (c == '>') then
		   currentChar = ENUM.CharacterFound.GREATERTHAN
	  elseif (c =='/') then
		  currentChar = ENUM.CharacterFound.FORWARDSLASH
	  else
		  currentChar = ENUM.CharacterFound.NORMALLETTER
	  end
	
	  word = word .. c 
	  charInDocumentAt = charInDocumentAt .. c 
	
	  if (currentChar == ENUM.CharacterFound.LESSTHAN)
		then
			  if response:sub(i+1,i+1) ~= '/' then
				  currentState = ENUM.STATE.INTAG
				 word =""
			 else
				currentState = ENUM.STATE.INENDTAG
				local endTag =  findNextUid(nextUid,HtmlTagToTable)
				local bodyText = ""
				for i = 1, #word do
					if word:sub(i,i) == '/' then
						break
					else
						bodyText =  bodyText .. word:sub(i,i)
					end						
				end
				endTag.body = bodyText:sub(1,#bodyText-1)
				word = ""
			 end
		end
		
	  if (currentChar == ENUM.CharacterFound.GREATERTHAN and (currentState == ENUM.STATE.INTAG))
		then
		   currentState = ENUM.STATE.RECEIVEDTAG
		end
		
	  if (currentState == ENUM.STATE.INTAG) then
		if currentChar == ENUM.CharacterFound.FORWARDSLASH
		then
			local currentCharAdvance = response:sub(i+1,1)
			if currentCharAdvance == '>' then
				currentState = ENUM.STATE.INLINETAG
			else
				currentState = currentState
			end
		 end
	 end
	 
	if (currentState == ENUM.STATE.GOTBODY)
	then
		   bodyContent = bodyContent .. c
	end

	if (currentState == ENUM.STATE.RECEIVEDTAG) then
			word = fixTagEntry(word)		
			currentState = findStateWord(word)
			if (currentState == ENUM.STATE.RECEIVEDTAG) then
				  htmlInfo = returnTagWithAttributes(word)
				 currentState = ENUM.STATE.INSERTTAG
				 currentTagName = htmlInfo.tag
			end
			word = ""
	end
		
	if (currentState == ENUM.STATE.INSERTTAG) then
		if (rootTagStatus == ENUM.ROOTTAG.NOTFOUND) then
			if currentTagName == rootEndTag then
				nextUid = uuid(uuidLength)
				rootTagStatus = ENUM.ROOTTAG.RECEIVED
				HtmlTagToTable[currentTagName] = {}
				HtmlTagToTable[currentTagName].attrib = htmlInfo.attribs
				HtmlTagToTable[currentTagName].child = nil
				HtmlTagToTable[currentTagName].parentUid = nil
				HtmlTagToTable[currentTagName].nextUid = nextUid
				HtmlTagToTable[currentTagName].isArray = false
				currentState = ENUM.STATE.TEXT
			end
		else 
			local innerTag = {}
			innerTag.attribs = htmlInfo.attribs
			innerTag.parentUid = nextUid
			nextUid = uuid(uuidLength)
			innerTag.nextUid = nextUid
			setAttribute(HtmlTagToTable,innerTag,currentTagName)
			currentState = ENUM.STATE.TEXT
		end
	end
if rootTagStatus == ENUM.ROOTTAG.ASSIGNED then
		 if (currentState == ENUM.STATE.INENDTAG)then
				 local endTag =  findNextUid(nextUid,HtmlTagToTable)
				 endTag.nextUid = nil 
				 nextUid = endTag.parentUid	
				 word = ""
				 currentState = ENUM.STATE.TEXT
				 if endTag == rootEndTag then	
					rootTagStatus = ENUM.ROOTTAG.DONE
				end
		end
elseif (rootTagStatus == ENUM.ROOTTAG.RECEIVED) then
		rootTagStatus = ENUM.ROOTTAG.ASSIGNED 
elseif rootTagStatus == ENUM.ROOTTAG.DONE	then
		break
end
end
return HtmlTagToTable
end

local function traverseAndFindElement(mytable,tagToFind)
	local tableToReturn
	local index
	local found = false
	for tag,value in pairs(index)
	do
		if value.isArray == true then
			continue	
		end
		if value.nextUid == nil then
			continue
		end
	end
	return tableToReturn
end

function module.parseSongs(htmlPair,findValue,tableToReturn)
if tableToReturn == nil then
tableToReturn = {}
end
local found = false
for tag,value in pairs(htmlPair)
do
if tag:sub(1,#findValue) == findValue
then
	 table.insert(tableToReturn,value)
elseif value.child ~= nil
then
	  tableToReturn = module.parseSongs(value.child,findValue,tableToReturn)
elseif value.child == nil then
	continue 
elseif tag == "html" then
	break
end
end
return tableToReturn
end

function module.makeCallToServer(virtualScreen,baseUrl,relativeUrl)
local response	
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local addMusicRequest = ReplicatedStorage:WaitForChild('MakeHttpRequest')
local response = addMusicRequest:InvokeServer(baseUrl .. relativeUrl)
waitPeriod = getMilliSecond()
local htmlPair = addDomToTable(response,"html")
return htmlPair
end


return module

