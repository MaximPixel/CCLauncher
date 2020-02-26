local VERSION_DIR = "https://raw.githubusercontent.com/MaximPixel/CCLauncher/master/version.txt"
local LAUNCHER_DIR = "https://raw.githubusercontent.com/MaximPixel/CCLauncher/master/launcher.lua"
local CURRENT_VERSION = 1

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
	end
	return false
end

latestVersion = getLatestVersion()

if latestVersion >= 0 then
	if latestVersion > CURRENT_VERSION then
		downloadLatest()
	end
end