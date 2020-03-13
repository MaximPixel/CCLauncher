local FILES_DIR = "https://raw.githubusercontent.com/MaximPixel/CCLauncher/master/files.xml"

function reinstallAll()
	filesData = http.get(FILES_DIR)
	
	if filesData then
		filesText = filesData.readAll()
		filesData.close()
		
		if filesText then
			filesTable = textutils.unserialise(filesText)
			
			if filesTable and type(filesTable.files) == "table" and type(filesTable.version) == "string" then
				if filesTable.files.main then
					print("intall " .. #filesTable.files.main)
				end
				if turtle and filesTable.files.turtle then
					print("intall " .. #filesTable.files.turtle .. " too")
				end
			end
			
			return false, "Unknown format"
		end
	end
	return false, "No connection"
end

print("Reinstall? [y/n]")
answer = read()

if answer == "y" or answer == "Y" then
	print("Reinstalling...")
	suc, err = reinstallAll()
	if suc then
		print("Done!")
	else
		print(err)
	end
end