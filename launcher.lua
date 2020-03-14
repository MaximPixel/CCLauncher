local VERSION_DIR = "https://raw.githubusercontent.com/MaximPixel/CCLauncher/master/version.txt"
local LAUNCHER_DIR = "https://raw.githubusercontent.com/MaximPixel/CCLauncher/master/launcher.lua"
local INSTALLER_DIR = "https://raw.githubusercontent.com/MaximPixel/CCLauncher/master/installer.lua"
local CURRENT_VERSION = 13

tArgs = { ... }

mode = 0

function downloadInstaller()
	data = http.get(INSTALLER_DIR)
	
	if data then
		text = data.readAll()
		data.close()
		if text then
			file = fs.open("installer.lua", "w")
			file.write(text)
			file.close()
			return true
		end
	end
	return false
end

if tArgs[1] then
	if tArgs[1] == "gui" then
		mode = 1
	elseif tArgs[1] == "installer" then
		mode = 2
	end
end

if mode == 2 then
	print("Install installer? [y/n]")
	answer = read()
	if answer == "y" or answer == "Y" then
		downloadInstaller()
		print("Installed!");
	end
end

if mode ~= 1 then
	return
end

Button = {}

function Button:new(x, y, text)
	local obj = {}
	obj.x = x
	obj.y = y
	obj.w = #text
	obj.h = 1
	obj.text = text
	
	function obj:draw()
		term.setCursorPos(self.x, self.y)
		if self.text then
			term.write(self.text)
		else
			--TODO
		end
	end
	
	function obj:isinside(x, y)
		return x >= self.x and y >= self.y and x < self.x + self.w and y < self.y + self.h
	end
	
	setmetatable(obj, self)
	self.__index = self;
	return obj
end

function getLatestVersion()
	data = http.get(VERSION_DIR)

	if data then
		text = data.readAll()
		data.close()
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
	end
	return -1
end

function downloadLatest()
	data = http.get(LAUNCHER_DIR)
	
	if data then
		text = data.readAll()
		data.close()
		if text then
			file = fs.open("launcher.lua", "w")
			file.write(text)
			file.close()
			print("Updated!")
			return true
		end
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

newVersionExist = false
latestVersion = CURRENT_VERSION

function updateLatestVersion()
	latestVersion = getLatestVersion()
end

function gui()
	updateLatestVersion()
	
	clearAll()
	
	but = Button:new(2, 2, "Update")
	
	cc(colors.black, colors.white)
	but:draw()
	
	cc(colors.white, colors.black)
	term.setCursorPos(2, 4)
	term.write("Or press E to update")
	term.setCursorPos(2, 5)
	term.write("Press Q to exit")
	
	term.setCursorPos(1, 6)
	term.write("Latest version: " .. latestVersion)
	term.setCursorPos(1, 7)
	term.write("Current version: " .. CURRENT_VERSION)
	
	if CURRENT_VERSION < latestVersion then
		term.setCursorPos(1, 1)
		term.write("New version available!")
	end
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
	
	if e == "key" then
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