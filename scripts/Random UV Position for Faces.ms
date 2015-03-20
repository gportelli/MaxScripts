fileIn (getFilenamePath(getThisScriptFilename()) + "../includes/TFBT_Lib.ms")
fileIn (getFilenamePath(getThisScriptFilename()) + "../includes/TFBT_UVWCollapser.ms")

global RNDUVFloater

Rollout RNDUV_roll "Parameters"
(	
	local Wrbm = bitmap 15 15 color:red
	local Okbm = bitmap 15 15 color:green
	local Waitbm = bitmap 15 15 color:orange
	
	-- random seed
	label lbSd "Seed..................." align:#left offset:[-3,3]
	spinner spSd range:[0,1000000,0] type:#integer fieldwidth:60 align:#left offset:[96,-19]

	-- uv mapping channel
	label lbCh "UV Channel..........." align:#left offset:[-3,5]
	spinner spCh range:[1, 99, 3] type:#integer fieldwidth:60 align:#left offset:[96,-19]
	
	checkbox include_lods "Include LODs" checked:false

	button btRandomUV "Random UV" width:100 height:20 align:#center --offset:[-8,0]	

	groupBox grpSep1 width:188 height:7 offset:[-14,-4] 
	progressBar progBar value:0 color:green height:5
	imgTag imtWrn bitmap:Okbm align:#left offset:[-8,0]
	label lbWrn "Ready" align:#left offset:[14,-19] height:30

	fn uvGeneratorFunction vertices faceid =
	(
		return [(random 0.0 1.0), (random 0.0 1.0), (random 0.0 1.0)]
	)

	on btRandomUV pressed do
	(
		clearListener()

		local utils = TFBT_Utils()
		utils.DisableProcessWindowsGhosting()

		local collapser = TFBT_UVCollapser()
		collapser.CollapseUVW selection uvGeneratorFunction spCh.value progressBarInstance:progBar msgLabelInstance:lbWrn includeLODs:include_lods.checked
	)
)

if (RNDUVFloater != undefined) then CloseRolloutFloater RNDUVFloater
RNDUVFloater = NewRolloutFloater "RND UV" 200 200
addRollout RNDUV_roll RNDUVFloater