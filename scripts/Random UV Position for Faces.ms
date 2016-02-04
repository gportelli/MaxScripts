fileIn (getFilenamePath(getThisScriptFilename()) + "../includes/TFBT_Lib.ms")
fileIn (getFilenamePath(getThisScriptFilename()) + "../includes/TFBT_UVWCollapser.ms")

global RNDUVWFloater

Rollout RNDUVW_roll "Parameters"
(	
	local Okbm = bitmap 15 15 color:green
	
	-- random seed
	label lbSd "Seed..................." align:#left offset:[-3,3]
	spinner spSd range:[0,1000000,0] type:#integer fieldwidth:60 align:#left offset:[96,-19]

	-- quantization
	label lbQuantization "Quantization..................." align:#left offset:[-3,3]
	spinner spQuantization range:[0,2048,256] type:#integer fieldwidth:60 align:#left offset:[96,-19]

	-- uv mapping channel
	label lbCh "UV Channel..........." align:#left offset:[-3,5]
	spinner spCh range:[1, 99, 3] type:#integer fieldwidth:60 align:#left offset:[96,-19]
	
	checkbox cbIncludeLods "Include LODs" checked:false

	button btRandomUVW "Random UVW" width:100 height:20 align:#center --offset:[-8,0]	

	groupBox grpSep1 width:188 height:7 offset:[-14,-4] 
	progressBar progBar value:0 color:green height:5
	imgTag imtWrn bitmap:Okbm align:#left offset:[-8,0]
	label lbWrn "Ready" align:#left offset:[14,-19] height:30

	fn uvGeneratorFunction mesh faceid =
	(
		q = spQuantization.value
		h = 0.5 / q
		
		return [(floor (random 0.0 q)) / q + h, (floor (random 0.0 q)) / q + h, (floor (random 0.0 1.0)) / q + h]
	)

	on btRandomUVW pressed do
	(
		clearListener()		

		local utils = TFBT_Utils()
		utils.DisableProcessWindowsGhosting()

		local collapser = TFBT_UVWCollapser()
		local result = collapser.CollapseUVW selection uvGeneratorFunction spCh.value includeLODs:cbIncludeLods.checked msgLabelInstance:lbWrn progressBarInstance:progBar semaphoreBitmapInstance:imtWrn
	)
)

if (RNDUVWFloater != undefined) then CloseRolloutFloater RNDUVWFloater
RNDUVWFloater = NewRolloutFloater "RND UVW" 200 200
addRollout RNDUVW_roll RNDUVWFloater