ConvertClass = dotnetclass "system.convert"
ImageClass = dotnetclass "system.drawing.image"

fn ConvertBase64StringToImage string =
(
	bytearr = convertclass.FromBase64String string
	memstream = dotnetobject "System.IO.MemoryStream" bytearr
	DecodedImg = ImageClass.fromstream memstream
	memstream.close()
	return DecodedImg
)

btn_align_vert_matrix_v_img = "/9j/4AAQSkZJRgABAQEAAAAAAAD/7gAOQWRvYmUAZAAAAAAB/+EAFkV4aWYAAE1NACoAAAAIAAAAAAAA/+wAEUR1Y2t5AAEABAAAAFAAAP/hA5BodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+DQo8eDp4bXBtZXRhIHhtbG5zOng9ImFkb2JlOm5zOm1ldGEvIiB4OnhtcHRrPSJBZG9iZSBYTVAgQ29yZSA1LjYtYzAxNCA3OS4xNTY3OTcsIDIwMTQvMDgvMjAtMDk6NTM6MDIgICAgICAgICI+DQoJPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4NCgkJPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDpmMTQ3YjMwMy02NWFhLTJhNDEtOWYxMC05NTk3OTYxZmU3OWQiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6MzdGMTMwMDc3N0RBMTFFNEJDMDk4Q0Y2RDA0RThGMDMiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6MzdGMTMwMDY3N0RBMTFFNEJDMDk4Q0Y2RDA0RThGMDMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIDIwMTQgKFdpbmRvd3MpIj4NCgkJCTx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOmZiNTlkNGRhLTNlYzctZmQ0Zi05ZGEyLTI2NmU4YjMwYmY4NCIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDpmMTQ3YjMwMy02NWFhLTJhNDEtOWYxMC05NTk3OTYxZmU3OWQiLz4NCgkJPC9yZGY6RGVzY3JpcHRpb24+DQoJPC9yZGY6UkRGPg0KPC94OnhtcG1ldGE+DQo8P3hwYWNrZXQgZW5kPSd3Jz8+/9sAQwACAgICAgICAgICAwICAgMEAwICAwQFBAQEBAQFBgUFBQUFBQYGBwcIBwcGCQkKCgkJDAwMDAwMDAwMDAwMDAwM/9sAQwEDAwMFBAUJBgYJDQsJCw0PDg4ODg8PDAwMDAwPDwwMDAwMDA8MDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwM/8AAEQgAGAAYAwERAAIRAQMRAf/EABYAAQEBAAAAAAAAAAAAAAAAAAUGCf/EADIQAAADBgIHBgcAAAAAAAAAAAECBBEDExQFFTESAGEiQlIGFiEyIzMkF5NkpGUmRgf/xAAXAQEBAQEAAAAAAAAAAAAAAAAEBgUH/8QANREAAAQDBQUGBAcAAAAAAAAAARECEgMEFCFBMhMFADFhImKBkSMzFRZRoUJSgkODk2QlBv/aAAwDAQACEQMRAD8AzxWPiW/mFaatL3NSR1MU6NGR6cHOR4cRK0ALwkebwYBqaKLMR0zSYYADBAREb7O3im6/uq5PStMiaDHnIkRYTSIqEJQGAQWQgfKNopRGHGGADC0HIwqTfZHqarW22TsxGPEiZY7PLwgbXd1Nb2aAr52ne1L3tK4jb9299m/5W7Vvtf8AzXrFLURaemznfW9ucXlYafxCYZ8pu5Njkb4lv5eWlrS99UllTBOsRnenFzkdnATMAS8J3e8OI62PhTEdU0qGIAwAAQG+3t4Kuu75Kc0rTIegwJyHEWM0uKtCkDgAEGIlyhaCVwRxjjEgsFtAa9e3n9AgWqx9UJJ2NL3OMx/kl83qIWESH4bcsbbl9CzDPUEGbmj8OouoieZWGw9t3S6r2jNtblZoH5hkcHM3eE59Plv52VDb9r7809yf1S79C/b5CUtfwJr6mL89pjeBRXlmdG5vceX+LM47dJ/tPc35eZSfyCdm/u5db+lRdG0CW9e3n8/j2qx9UK5KDL3OMxxnmMvqIWMOJ4bc0HbmNNmXZ6gsjc0Ph0n1ETCOw3ltzbVKr2jKOblZol5hkcbL3+E59RmM52U7rtp9Y5Jb+YURqKvfVJZUxUI1hHRxc5HZxArRA3Cd5ujiGpiosvHVNJiAIMABAQvt7OCb7u/Ck9V0yHoMeTiQ1jNLioWlYYABBAB8wWglcYMA4wMbAajFpN9numatbbZJS8E8SJlgN8zCBs97WxvboCgnadjkve47iN327327vlZtW+6P816xVU8Wnpslv1vbkn5uGn8M3mfMTufY5G5Jb+XkRaKvc1JHUwULFh3Rwc5HhwAzBE3CR3uhgOtr4UvHTNKiCIMEAAAvs7OKr7+6SnNV0yJoMCThw1hNIirWpY4BBZgJcw2ilEEMAYBIbRd//9k="
btn_align_vert_matrix_h_img  = "iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAIAAABvFaqvAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAZdEVYdFNvZnR3YXJlAEFkb2JlIEltYWdlUmVhZHlxyWU8AAADdmlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgNS42LWMwMTQgNzkuMTU2Nzk3LCAyMDE0LzA4LzIwLTA5OjUzOjAyICAgICAgICAiPiA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtbG5zOnhtcD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyIgeG1wTU06T3JpZ2luYWxEb2N1bWVudElEPSJ4bXAuZGlkOmYxNDdiMzAzLTY1YWEtMmE0MS05ZjEwLTk1OTc5NjFmZTc5ZCIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDozN0YxMzAwQjc3REExMUU0QkMwOThDRjZEMDRFOEYwMyIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDozN0YxMzAwQTc3REExMUU0QkMwOThDRjZEMDRFOEYwMyIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ0MgMjAxNCAoV2luZG93cykiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDpmYjU5ZDRkYS0zZWM3LWZkNGYtOWRhMi0yNjZlOGIzMGJmODQiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6ZjE0N2IzMDMtNjVhYS0yYTQxLTlmMTAtOTU5Nzk2MWZlNzlkIi8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+Tgx2WwAAAGBJREFUOE9j8PYLoQoCGaRLMaCNQY8UlSCIDC52g+Do////eLgQBNFLGxdRAmhjEJprSeJiNwiORgMbCFAMQnMtSVzsBsHRaGADAYpBaK4liYvdIDgaDWwggBpEBeQXAgDyusroaiPOogAAAABJRU5ErkJggg=="

fn printMatrix m =
(
	for i=1 to m.count do (
		print ("row " + i as string)
		
		tmp = ""
		for j=1 to m[i].count do
		(
			tmp = tmp + m[i][j] as string + " "
		)
		
		print tmp
	)
)

fn align_vert_matrix direction =
(
	if selection.count != 1 do (
		messagebox "No object selected"
		return()	
	)
	
	obj = selection[1]
		
	if  obj.unwrap_UVW == undefined do return()
	
	matrix = #()
	for ver in obj.unwrap_UVW.getSelectedVertices() do
	(
		pos = obj.unwrap_UVW.getVertexPosition 0 ver
		
		found = false
		
		if matrix.count != 0 do
		(
			for i=1 to matrix.count do
			(
				--print pos.y
				curr = obj.unwrap_UVW.getVertexPosition 0 matrix[i][1][1]
				--break()
				if (direction == "vert" and pos.y == curr.y) or 
				   (direction == "horiz" and pos.x == curr.x) do
				(
					matrix[i][matrix[i].count+1] = #(ver, pos)
					found = true
					exit
				)			
			)
		)
		
		if found == false do
		(			
			matrix[matrix.count+1] = #(#(ver, pos))
		)
	)
	
	if matrix.count == 0 do
	(
		messagebox "No vertices selected"
		return()
	)
	
	-- check matrix 
	
	for i=2 to matrix.count do (		
		if matrix[i].count != matrix[1].count do 
		(
			if direction == "vert" then (
				messagebox "You must select a vertex matrix, with rows aligned"
			)
			else (
				messagebox "You must select a vertex matrix, with columns aligned"
			)
			
			return()
		)
	)
			
	--printMatrix matrix
	
	fn sortFn1 arr1 arr2 index:1 = 
	(
		if arr1[2][index] < arr2[2][index] then return -1
		if arr1[2][index] > arr2[2][index] then return 1
		return 0
	)
	
	fn sortFn2 arr1 arr2 index:1 = 
	(
		if arr1[1][2][index] < arr2[1][2][index] then return -1
		if arr1[1][2][index] > arr2[1][2][index] then return 1
		return 0
	)	
	
	index = 0
	if direction == "horiz" then index = 1
	--break()
	-- sort rows
	for i=1 to matrix.count do (		
		qsort matrix[i] sortFn1 index:(index+1)
	)
	
	--print "\n\nSorted rows:"
	--printMatrix matrix
	
	-- sort cols
	for i=1 to matrix.count do (		
		qsort matrix sortFn2 index:(1 + (1-index))
	)
	
	--print "\n\nSorted cols:"
	--printMatrix matrix
	
	-- Align vertices
	for i=1 to matrix.count do
	(
		for j=1 to matrix[i].count do
		(
			matrix[i][j][2][index+1] = matrix[1][j][2][index+1]
			obj.unwrap_UVW.setVertexPosition 0 matrix[i][j][1] matrix[i][j][2]
		)
	)
	
	--print "\n\nAligned:"
	--printMatrix matrix
)

rollout uvroll "Unwrap UVW Tools"
(	
	dotnetcontrol btn_align_vert_matrix_v "Button" width:24 height:24
	dotnetcontrol btn_align_vert_matrix_h "Button" pos:[50, 7] width:24 height:24	
	
	--button std "standard button"
	
	on uvroll open do (
		tooltip_h = dotnetobject "ToolTip"
		tooltip_h.SetToolTip btn_align_vert_matrix_h "Align UV vertices matrix horizontally"
		
		btn_align_vert_matrix_h.image = (ConvertBase64StringToImage btn_align_vert_matrix_h_img)		
		btn_align_vert_matrix_h.flatstyle = (dotnetclass "flatstyle").flat		
		btn_align_vert_matrix_h.FlatAppearance.BorderSize = 0;
		
		tooltip_v = dotnetobject "ToolTip"
		tooltip_v.SetToolTip btn_align_vert_matrix_v "Align UV vertices matrix vertically"
		
		btn_align_vert_matrix_v.image = (ConvertBase64StringToImage btn_align_vert_matrix_v_img)
		btn_align_vert_matrix_v.flatstyle = (dotnetclass "flatstyle").flat
		btn_align_vert_matrix_v.FlatAppearance.BorderSize = 0;
	)
	
	on btn_align_vert_matrix_h click do align_vert_matrix "horiz"
	on btn_align_vert_matrix_v click do align_vert_matrix "vert"
)	


toolsFloater = newRolloutFloater "Tools" 200 100
addRollout uvroll toolsFloater