rollout Base64 "" width:346 height:706
(
local imgfilename = undefined
local ConvertClass = dotnetclass "system.convert"
local ImageClass = dotnetclass "system.drawing.image"
local ColorClass =dotnetclass "system.drawing.color"
local Align = dotnetclass "System.Drawing.ContentAlignment"
local singleborderstyle = (dotNetClass "System.Windows.Forms.BorderStyle").fixedsingle
local LRLogo64 = "Qk0YEQAAAAAAADYAAAAoAAAAIwAAACgAAAABABgAAAAAAOIQAAAgLgAAIC4AAAAAAAAAAAAAM2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0NGc1Nmg2NWk2NWk2Nmo3Nms3NWs2NWo2Nms3Nms3NWo3NWk2NWg2NWg2NGc1M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0AAAAM2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0NWo3N203MGkxKGQqJmAnJF0lI1skJlwnLmEvMWIyKl8rJV0mJV4mJl8nKGIoLGYtNGs1Nms3NGg1M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0AAAAM2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2c0NGg2MmYzG04bGUEZJUEmLkMuMUMwJz0nFjEWEDMPGDwYEzETHzYeKj0qLkAuKEAoID8gFkQXI1okNWg1NGc1M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0AAAAM2Y0M2Y0M2Y0M2Y0M2Y0M2Y0NWo2LV4tHUEcRE1EeHN4lYyVpp6mraSspp6ml5GXU1dSHjMec3Nzj4WOlo6WnJSck4uTgXmBWlpaKDkoHUUeM2Y0NWk2M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0AAAAM2Y0M2Y0M2Y0M2Y0M2Y0M2Y0Nmo3JlklHD8curG64tvizMzLycrJycnJyMjI5eXlqaGpRk5Gvr6+w8LDvLy8tra2uLi4vLu8z8rPf25/HjseKmUrNWk2M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0AAAAM2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0MmYzG1Ycoaqi6t/q7O3rzczNxcXF0dLRz8vPenR5GjoamZqZ5eDl0NHQrKyssbGxu767tq62bm5vLmMvL2YwM2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0AAAAM2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0NWg3IFwhSnVL49fjvbi9jI2Mk5SToJ+glYSVSGFIC04LZoBmsqWyjY6NkJCQlZaVrKWsgHB/N1w4K2gtNWc3M2Y1M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0AAAAM2Y0M2Y0M2Y0M2Y0M2Y0NWg3MmUyLmEuNWc3JGAlQmZCcW1xjo2Ol5WXXVhdKEUoL2wxNWw3GlgbXW9euK+4pqemgX6BNzc3Nlw3LWouNWc2LWErK18oMmQy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TbKAU7iBSa9tQqhnRKppRKppSLl0OH5GMForM2c0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0AAAAM2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2UzL1sqSKFtU72KTruET7yFUcuOU8uNTa17TrN/TrN/TrKBU7iAR61qQqhnRKppRa1sRrJvNGo3MV8uM2c1M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0AAAAM2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0LlgmRZpmVMqTTZ1wTrN/TrN/SqB0T7uETrJ+TrN/TrOCUrd9RatnQ6loRKloR7RxQZ9gMV8vM2QyM2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0AAAAM2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0LVclRZdkV9idTXFLTrN/TXFLTXFLUMCGTrJ+TrN/TrOCUbd7RKtnQ6loRKhoR7l1PI1SMFgpM2g1M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0AAAAM2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0LlYlQ5JgVsiVUsWOTrN/VMqTVciRUryKUbyIULmEUrmHT7Z5PahhQqtoRq5sSLl1N3pDMFoqM2c1M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0AAAAM2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0MmUyM2g1OHRCPIFNQIpXQ5ZiRpxpSKNvS6x5TrWBVsGOU8KAOa5hR7ZySLp2RrRwMmUzMWAvM2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0AAAAM2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2g1MWIwL1opLlknLlcmLlgmL1spMV8tMmQyNGo5LWw1SYVUm6ukU35bKnA0NnA8M2MxM2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0AAAAM2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2c1M2c1M2c1M2c1M2Y0MmQyMWEvMF4sJlYgM18vkoqNNlsxKlolMV0uM2c1M2c1M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0AAAAM2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2c1M2c1K2ItO208g46EM2Q1MGYxM2c0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0AAAAM2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0KmErPG09ho6GNGM1L2UxM2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0AAAAM2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0KmErO2w8iZKKM2Q1MGUxM2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0AAAAM2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0LmQwK2UvhYh6OmItLGUvNGY2M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0AAAAM2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0NGY1I10lVY6IfMn/VY6IJWAmMWUyM2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0AAAAM2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0NGY1J10gfMn/fMn/RZjKLlkVMmUxM2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0AAAAM2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0N2g2VY6IfMn/VY6INGUuM2Y1M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0AAAAM2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0M2Y0AAAAAAA="
local player = dotnetobject "Media.SoundPlayer" 
	
fn ConvertImageToBase64String filename =
(
	if (doesfileexist filename) do
		(	
		memstream = dotnetobject "System.IO.MemoryStream" 		
		ImgLoaded = ImageClass.fromfile filename
		ImgLoaded.save memstream ImgLoaded.rawformat
		Base64string = ConvertClass.ToBase64String (memstream.ToArray())
		memstream.close()		
		return Base64String
		)		
)	

fn ConvertBase64StringToImage string =
(
	bytearr = convertclass.FromBase64String string
	memstream = dotnetobject "System.IO.MemoryStream" bytearr
	DecodedImg = ImageClass.fromstream memstream
	memstream.close()
	return DecodedImg
)

fn ConvertWavtoBase64 strInFile =
(
info = dotnetobject "system.IO.FileInfo" strInFile
fs = dotnetobject "system.IO.filestream" strInFile ((dotnetclass "system.io.filemode").open) ((dotnetclass "system.io.fileaccess").read)
br = dotnetobject "system.IO.BinaryReader" fs
WavFile = br.ReadBytes info.Length
Base64string =ConvertClass.ToBase64String wavfile
fs.close()
br.close()
return Base64string
)

fn ConvertBase64StringToWavMemStream string =
(
	bytearr = convertclass.FromBase64String string
	memstream = dotnetobject "System.IO.MemoryStream" bytearr
	return memstream
	memstream.close()
)

fn PlayWavFromStream Stream =
(
player.stream = stream
player.play()	
)

fn StopSoundPlayer = player.stop()		

	dotNetControl pb1 "system.windows.forms.picturebox" pos:[3,72] width:339 height:245
	dotNetControl tb1 "system.windows.forms.textbox" pos:[3,320] width:339 height:332
	button btnloadimg "Load Image" pos:[3,50] width:170 height:20 border:false
	button btnconvert "Convert Base64 string to Image" pos:[3,654] width:190 height:23 border:false
	button btn2clip "To ClipBoard" pos:[193,654] width:75 height:23 border:false
	dotNetControl lab1 "label" pos:[3,3] width:339 height:46	
	button btnct "Clear Textbox" pos:[193,677] width:149 height:23 border:false
	button btn2script "To Script" pos:[268,654] width:74 height:23 border:false
	button btnloadwav "Load Wav File" pos:[173,50] width:170 height:20 border:false
	button btnplaywav "Play Audio From Base64 String" pos:[3,677] width:190 height:23 border:false

	on Base64 open do
	(
		lab1.backcolor = ColorClass.FromArgb 52 101 51	
		lab1.forecolor = ColorClass.white
		lab1.font = dotNetObject "System.Drawing.Font" "Verdana" 7 
		lab1.text = "Base64 Encoded String Utility"
		lab1.textalign = Align.MiddleRight	
		lab1.imagealign = Align.MiddleLeft		
		lab1.image = ConvertBase64StringToImage LRlogo64	
		
		tb1.scrollbars = (dotnetclass "System.Windows.Forms.ScrollBars").Vertical
	
		pb1.backcolor = ColorClass.lemonchiffon
		tb1.backcolor = ColorClass.darkgray
		tb1.forecolor = ColorClass.yellow
		lab1.borderstyle = pb1.borderstyle = tb1.borderstyle = singleborderstyle
		tb1.multiline = true
		tb1.font = dotNetObject "System.Drawing.Font" "Verdana" 8 ((dotNetClass "System.Drawing.FontStyle").bold)
	
		pb1.SizeMode = (dotnetclass "System.Windows.Forms.PictureBoxSizeMode").zoom
		
		show tb1
	)
	on btnloadimg pressed do
	(
		imgfilename = getOpenFileName caption: "Choose an Image to convert to Base64"
		if imgfilename != undefined do 
			(
			setwaitcursor()
			tb1.text = ConvertImageToBase64String imgfilename
			pb1.imagelocation = imgfilename
			setarrowcursor()
			)
	)
	on btnconvert pressed do
	(
		try
		(
		pb1.image = ConvertBase64StringToImage tb1.text
		)
		catch()
	)
	on btn2clip pressed do
		if imgfilename != undefined do (dotnetclass "clipboard").settext tb1.text
	on btnct pressed do
		tb1.text = ""
	on btn2script pressed do
	(
	if imgfilename != undefined do 
		(
		StrVarFile = newScript()
		StrVar = ("str" + (getfilenamefile imgfilename) + "Base64 = \"%\"\n")
		format StrVar tb1.text to:StrVarFile 
		)
	)
	on btnloadwav pressed do
	(
		imgfilename = getOpenFileName caption: "Choose an Wav file to convert to Base64" types:"Wave Files (*.wav)|*.wav"

		if imgfilename != undefined do 
			(
			setwaitcursor()
			tb1.text = ConvertWavtoBase64 imgfilename
			setarrowcursor()
			)
	)
	on btnplaywav pressed do
	(
		try
		(
		b64wavtoStream = ConvertBase64StringToWavMemStream tb1.text
		PlayWavFromStream b64wavtoStream 
		)
		catch()
	)
	
	on base64 close do try(StopSoundPlayer())catch()
		
)

createdialog base64 style:#(#style_toolwindow, #style_sysmenu) 