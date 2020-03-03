local FILES_DIR = "https://raw.githubusercontent.com/MaximPixel/CCLauncher/master/files.xml"

filesData = http.get(FILES_DIR)

if filesData then
	filesText = filesData.readAll()
	if filesText then
		filesList = textutils.unserialise(filesText)
		if filesList then
			print(filesList.version)
			
			for _, i in ipairs(filesList.files) do
				print(i)
			end
		end
	end
end