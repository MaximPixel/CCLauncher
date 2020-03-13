local VERSION_DIR = "https://raw.githubusercontent.com/MaximPixel/CCLauncher/master/version.txt"
local LAUNCHER_DIR = "https://raw.githubusercontent.com/MaximPixel/CCLauncher/master/launcher.lua"
local CURRENT_VERSION = 12

data = http.get(VERSION_DIR)

Button = {}

function Button:new(x, y, w, h, text)
	local obj = {}
	obj.x = x
	obj.y = y
	obj.w = w
	obj.h = h
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

but = Button:new(2, 2, 6, 1, "Update")

function gui()
	clearAll()
	
	cc(colors.black, colors.white)
	but:draw()
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