local VERSION_DIR = "https://raw.githubusercontent.com/MaximPixel/CCLauncher/master/version.txt"
local LAUNCHER_DIR = "https://raw.githubusercontent.com/MaximPixel/CCLauncher/master/launcher.lua"
local CURRENT_VERSION = 6

data = http.get(VERSION_DIR)

function getLatestVersion()
	data = http.get(VERSION_DIR)

	if data then
		text = data.readAll()
		if text then
			version = tonumber(text)
			if version then
				return version
			else
				return -1
			end
		else
			return -1
		end
		data.close()
	end
	return -1
end

function downloadLatest()
	data = http.get(LAUNCHER_DIR)
	
	if data then
		text = data.readAll()
		if text then
			file = fs.open("launcher.lua", "w")
			file.write(text)
			file.close()
			print("Updated!")
		end
		data.close()
	end
	return false
end

function cc(c1, c2)
	term.setTextColor(c1)
	term.setBackgroundColor(c2)
end

function clearAll()
	cc(colors.white, colors.black)
	term.clear()
	term.setCursorPos(1, 1)
end

function gui()
	clearAll()
	
	cc(colors.black, colors.white)
	term.setCursorPos(2, 2)
	term.write("Press E to upgrade")
end

run = true
dirty = true
relauch = false

while run do
	if dirty then
		gui()
		dirty = false
	end
	
	local e, k = os.pullEvent()
	
	if e = "key" then
		if k == keys.q then
			run = false
		end
		if k == keys.e then
			run = false
			
			latestVersion = getLatestVersion()
			
			if latestVersion >= 0 then
				if latestVersion > CURRENT_VERSION then
					downloadLatest()
				end
			end
			
			relauch = true
		end
	end
end

clearAll()

os.sleep(0)

if relauch then
	shell.run("launcher.lua")
end