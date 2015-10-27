fileIn (getFilenamePath(getThisScriptFilename()) + "../includes/TFBT_Lib.ms")
fileIn (getFilenamePath(getThisScriptFilename()) + "../includes/TFBT_BarycentricCoords.ms")

global AddCoordsFloater

Rollout AddCoords_roll "Parameters"
(	
	local Okbm = bitmap 15 15 color:green
	
	-- uv mapping channel
	label lbCh "UV Channel..........." align:#left offset:[-3,5]
	spinner spCh range:[1, 99, 3] type:#integer fieldwidth:60 align:#left offset:[96,-19]
	
	button btAddCoords "Add Coords" width:100 height:20 align:#center --offset:[-8,0]	

	groupBox grpSep1 width:188 height:7 offset:[-14,-4] 
	progressBar progBar value:0 color:green height:5
	imgTag imtWrn bitmap:Okbm align:#left offset:[-8,0]
	label lbWrn "Ready" align:#left offset:[14,-19] height:30

	on btAddCoords pressed do
	(
		clearListener()

		local utils = TFBT_Utils()
		utils.DisableProcessWindowsGhosting()

		local bcoords = TFBT_BarycentricCoords()
		local result = bcoords.AddCoords selection spCh.value msgLabelInstance:lbWrn progressBarInstance:progBar semaphoreBitmapInstance:imtWrn
	)
)

if (AddCoordsFloater != undefined) then CloseRolloutFloater AddCoordsFloater
AddCoordsFloater = NewRolloutFloater "Add Barycentric Coords" 200 200
addRollout AddCoords_roll AddCoordsFloater