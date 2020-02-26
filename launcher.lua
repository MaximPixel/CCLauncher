local VERSION_DIR = "https://raw.githubusercontent.com/MaximPixel/CCLauncher/master/version.txt"

function checkVersion(new, current)
	a1, b1, c1 = string.match(new, "(%d+).(%d+).(%d+)")
	a2, b2, c2 = string.match(current, "(%d+).(%d+).(%d+)")

	a1 = tonumber(a1)
	b1 = tonumber(b1)
	c1 = tonumber(c1)
	a2 = tonumber(a2)
	b2 = tonumber(b2)
	c2 = tonumber(c2)

	if a1 and b1 and c1 and a2 and b2 and c2 then
		if a1 > a2 then
			return 1
		end
		if b1 > b2 then
			return 1
		end
		if c1 > c2 then
			return 1
		end
		return 0
	else
		return -1
	end
end

local CURRENT_VERSION = "0.0"

data = http.get(VERSION_DIR)

if data then
	version = data.readAll()

	if version then
		print(version)
		print(checkVersion(version, CURRENT_VERSION))
	end
end

data.close()