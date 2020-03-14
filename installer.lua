local FILES_DIR = "https://raw.githubusercontent.com/MaximPixel/CCLauncher/master/files.xml"

function downloadFile(link, path)
	data = http.get(link)
	
	if data then
		text = data.readAll()
		data.close()
		if text then
			file = fs.open(path, "w")
			file.write(text)
			file.close()
			return true
		end
	end
	return false
end

function reinstallAll()
	filesData = http.get(FILES_DIR)
	
	if filesData then
		filesText = filesData.readAll()
		filesData.close()
		
		if filesText then
			filesTable = textutils.unserialise(filesText)
			
			if filesTable and type(filesTable.files) == "table" and type(filesTable.version) == "string" then
				if filesTable.files.main then
					for _,i in ipairs(filesTable.files.main) do
						flag = downloadFile(i.link, i.path)
						if flag then
							print("intalled " .. i.path)
						else
							print("failed " .. i.path)
						end
					end
				end
				if turtle and filesTable.files.turtle then
					for _,i in ipairs(filesTable.files.turtle) do
						flag = downloadFile(i.link, i.path)
						if flag then
							print("intalled " .. i.path)
						else
							print("failed " .. i.path)
						end
					end
				end
				return true
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