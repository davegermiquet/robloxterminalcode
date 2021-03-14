local module = {}
 

 function getSong(songTr) 
	local object = {}
			object.songId =  songTr['td#2'].child['div'].child['span'].body
			object.songName = songTr['td#1'].child['a'].child['span'].body
			return object
	end
 function module.getSongsObject(htmlElementObject) 
	local songsObject = {}
	local objectToAdd = {}
	for index,elementNum in ipairs(htmlElementObject)
	do
		for tag,value in pairs(elementNum.child)
		do
			if string.match(tag:sub(1,#tag),'tr#[2-9]+[1-9]*[1-9]*') then
			    local status,result = pcall(getSong,value.child)
			    table.insert(songsObject,result)
		    end
		end
	end
	return songsObject
end 
return module
