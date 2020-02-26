local VERSION_DIR = "https://raw.githubusercontent.com/MaximPixel/CCLauncher/master/version.txt"
local CURRENT_VERSION = 0

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

if data then
	version = data.readAll()

	if version then
		print(version)
		print(checkVersion(version, CURRENT_VERSION))
	else
		print("Failed to load")
	end

	data.close()
else
	print("Failed to load")
end