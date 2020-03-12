local FILES_DIR = "https://raw.githubusercontent.com/MaximPixel/CCLauncher/master/files.xml"

function readVersion(dir)
	versionData = http.get(dir)
	versionData.close()
	if versionData then
		data = versionData.readAll()
		version = tonumber(data)
		if version then
			return version
		end
	end
	return nil
end

function getFilesData()
	filesData = http.get(FILES_DIR)
	
	if filesData then
		filesText = filesData.readAll()
		filesData.close()
		if filesText then
				filesList = textutils.unserialise(filesText)
				if filesList then
					out = {}
					print(filesList.version)
					for _,i in ipairs(filesList.files) do
						table.insert(out, i)
					end;
					return out
				end
		end
	end
	return nil
end

filesL = getFilesData()

for _,i in ipairs(filesL) do
	print(i)
end