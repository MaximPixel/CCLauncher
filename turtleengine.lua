local PROG_FILE_NAME = "prog.txt"

function tokenise(str)
	local sLine = table.concat( { str }, " " )
	local tWords = {}
	local bQuoted = false
	for match in string.gmatch( sLine .. "\"", "(.-)\"" ) do
		if bQuoted then
			table.insert( tWords, match )
		else
			for m in string.gmatch( match, "[^ \t]+" ) do
				table.insert( tWords, m )
			end
		end
		bQuoted = not bQuoted
	end
	return tWords
end

lines = {}

autoRefuel = false

loop = 0

function readScript(fileName)
	file = fs.open(fileName, "r")

	line = file.readLine()

	while line do
		table.insert(lines, line)
		line = file.readLine()
	end

	file.close()
end

function saveProgress(action, loop)
	file = fs.open(PROG_FILE_NAME, "w")
	
	if loop then
		tbl = {action = action; loop = loop}
	else
		tbl = {action = action}
	end

	data = textutils.serialise(tbl)
	file.write(data)
	file.close()

	print("Saved " .. action)
end

function readProgress()
	file = fs.open(PROG_FILE_NAME, "r")

	if file then
		tbl = textutils.unserialise(file.readAll())

		if tbl and tbl.action then
			if tbl.loop then
				return {action = tbl.action, loop = tbl.loop}
			else
				return {action = tbl.action}
			end
		end

		file.close()
	end

	return nil
end

function deleteProgress()
	fs.delete(PROG_FILE_NAME)
	print("Progress deleted")
end

function findItem(itemName)
	det = turtle.getItemDetail()
	if det and det.name == itemName then
		return turtle.getSelectedSlot()
	end
	for i = 1, 16 do
		if not i == turtle.getSelectedSlot() then
			det = turtle.getItemDetail()
			if det and det.name == itemName then
				return i
			end
		end
	end
	return -1
end

function parseAction(action)
	if not action then
		return false, "Action is nil"
	end

	print("Do \"" .. action .. "\"")
	local args = tokenise(action)

	if not args or #args == 0 or #args[1] == 0 then
		return true
	end

	if args[1] == "repeat" and #args >= 3 then
		if args[2] == "repeat" then
			return false, "No recursion :)"
		end

		count = tonumber(args[3])

		if count then
			if loop < 1 then
				loop = 1
			end

			for i = loop, count do
				print("Do in loop \"" .. args[2] .. "\" (" .. i .. ")")
				flag, err = parseAction(args[2])

				if not flag then
					loop = i
					if err then
						return false, "Error in loop: " .. (err or "nilerror")
					end
				end
			end
			loop = 0

			return true
		end

		return false, "Not correct number"
	end

	if args[1] == "hello" then
		print("Hello")
		return true
	end

	if args[1] == "forward" then
		if not turtle then
			return false, "Not turtle"
		end
		return turtle.forward()
	elseif args[1] == "back" then
		if not turtle then
			return false, "Not turtle"
		end
		return turtle.back()
	elseif args[1] == "turnLeft" then
		if not turtle then
			return false, "Not turtle"
		end
		return turtle.turnLeft()
	elseif args[1] == "turnRight" then
		if not turtle then
			return false, "Not turtle"
		end
		return turtle.turnRight()
	elseif args[1] == "up" then
		if not turtle then
			return false, "Not turtle"
		end
		return turtle.up()
	elseif args[1] == "down" then
		if not turtle then
			return false, "Not turtle"
		end
		return turtle.down()
	elseif args[1] == "autorefuel" then
		if not turtle then
			return false, "Not turtle"
		end
		autoRefuel = true
		return true
	elseif args[1] == "noautorefuel" then
		if not turtle then
			return false, "Not turtle"
		end
		autoRefuel = false
		return true
	elseif args[1] == "place" and args[2] then
		if not turtle then
			return false, "Not turtle"
		end
		
		itemIndex = findItem()
		
		if itemIndex >= 1 and itemIndex <= 16 then
			turtle.select(itemIndex)
			return turtle.place()
		end
		
		return false, "Item \"" .. args[2] .. "\" not found"
	elseif args[1] == "placeu" and args[2] then
		if not turtle then
			return false, "Not turtle"
		end
		
		itemIndex = findItem()
		
		if itemIndex >= 1 and itemIndex <= 16 then
			turtle.select(itemIndex)
			return turtle.placeUp()
		end
		
		return false, "Item \"" .. args[2] .. "\" not found"
	elseif args[1] == "placed" and args[2] then
		if not turtle then
			return false, "Not turtle"
		end
		
		itemIndex = findItem()
		
		if itemIndex >= 1 and itemIndex <= 16 then
			turtle.select(itemIndex)
			return turtle.placeDown()
		end
		
		return false, "Item \"" .. args[2] .. "\" not found"
	end

	return false, "Not exist action \"" .. args[1] .. "\""
end

readScript("turtlescript.ts")

prog = readProgress()

run = true
action = 1
if prog then
	action = prog.action
	if prog.loop then
		loop = prog.loop
	else
		loop = 1
	end
end

print("Last progress: " .. action .. " " .. loop)

while run and action <= #lines do
	line = lines[action]

	flag, err = parseAction(line)

	if not flag then
		run = false
		print("Finishing because \"" .. (err or "nilerror") .. "\"")
	end

	if loop >= 1 then
		saveProgress(action, loop)
	else
		saveProgress(action)
	end

	if flag then
		action = action + 1
	end
end

if action > #lines then
	print("Script comleted!")
	deleteProgress()
end

if not run then
	if loop >= 1 then
		print("Script finished at " .. action .. " position and loop " .. loop)
	else
		print("Script finished at " .. action .. " position")
	end
end