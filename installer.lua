local FILES_DIR = "https://raw.githubusercontent.com/MaximPixel/CCLauncher/master/files.xml"

function getFilesData()
	filesData = http.get(FILES_DIR)
	
	if filesData then
		filesText = filesData.readAll()
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