if TFBT_Utils == undefined then 
	fileIn (getFilenamePath(getThisScriptFilename()) + "TFBT_Utils.ms")

struct TFBT_BarycentricCoords
(		
	private

	msgLabelInst,
	semaphoreBitmapInst,
	errorBm = bitmap 15 15 color:red,
	okBm    = bitmap 15 15 color:green,
	waitBm  = bitmap 15 15 color:orange,

	fn compareLODNames l1 l2 =
	(
		case of
		(
			(l1.name < l2.name): -1
			(l1.name > l2.name): 1
			default: 0
		) 
	),

	fn displayMsg msg error:false =
	(
		if msgLabelInst != undefined then msgLabelInst.text = msg

		if semaphoreBitmapInst != undefined and error == true then semaphoreBitmapInst.bitmap = errorBm

		return msg
	),

	fn breakAllFaces uvw_Unwrap nfaces =
	(
		uvw_Unwrap.setTVSubObjectMode 2
		uvw_Unwrap.selectEdges  #{1..(nfaces * 3)}
		uvw_Unwrap.breakSelected()
	),

	public

	fn Constructor =
    (
        iteration = 0
        lastIteration = 0
        totalIterations = 0
        lastProgress = 0	 
        progressBarInst = undefined

        labelInst = undefined 

        return true
    ),

	fn AddCoords objects channel1 channel2 progressBarInstance:undefined msgLabelInstance:undefined semaphoreBitmapInstance:undefined =
	(			
		msgLabelInst = msgLabelInstance
		semaphoreBitmapInst = semaphoreBitmapInstance

		local progManager = TFBT_ProgressManager()
		progManager.Init progressBarInstance msgLabelInstance semaphoreBitmapInstance

		local utils = TFBT_Utils()

		-- objects check
		if (objects.count == 0) then			
			return displayMsg "Select at least One Object!" error:true
		
		for obj in selection do
			if not utils.IsEditableMesh obj then 
				return displayMsg (obj.name + "\nis not an editable mesh") error:true

		undo on
		(
			local total = 0
			for obj in selection do total = total + obj.numfaces
			progManager.Start (total * 2)

			for obj in selection do
			(
				local map1 = uvwmap()
				map1.maptype = 5
				map1.mapChannel = channel1
				addModifier obj map1
				
				local unwMod1 = unwrap_UVW()				

				unwMod1.name = "Barycentric UVW Ch : " + (channel1 as string)
				unwMod1.unwrap.setMapChannel channel1
				addmodifier obj unwMod1

				breakAllFaces unwMod1 obj.numfaces

				for face=1 to obj.numfaces do
				(
					local vertArr = #(
						(unwMod1.getVertexIndexFromFace face 1),
						(unwMod1.getVertexIndexFromFace face 2),
						(unwMod1.getVertexIndexFromFace face 3)
					)
					
					unwMod1.unwrap.SetVertexPosition 0 vertArr[1] [1, 0, 0]
					unwMod1.unwrap.SetVertexPosition 0 vertArr[2] [0, 1, 0]
					unwMod1.unwrap.SetVertexPosition 0 vertArr[3] [0, 0, 0]					

					if progManager.UpdateProgress() == false then return()
				)

				unwMod1.unwrap.selectVertices #{}
				unwMod1.unwrap2.selectFaces #{}
				unwMod1.setTVSubObjectMode 3

				/* --------- */

				local map2 = uvwmap()
				map2.maptype = 5
				map2.mapChannel = channel2
				addModifier obj map2

				local unwMod2 = unwrap_UVW()				

				unwMod2.name = "Barycentric UVW Ch : " + (channel2 as string)
				unwMod2.unwrap.setMapChannel channel2
				addmodifier obj unwMod2

				breakAllFaces unwMod2 obj.numfaces

				for face=1 to obj.numfaces do
				(
					local vertArr = #(
						(unwMod2.getVertexIndexFromFace face 1),
						(unwMod2.getVertexIndexFromFace face 2),
						(unwMod2.getVertexIndexFromFace face 3)
					)
					
					unwMod2.unwrap.SetVertexPosition 0 vertArr[1] [0, 0, 0]
					unwMod2.unwrap.SetVertexPosition 0 vertArr[2] [0, 0, 0]
					unwMod2.unwrap.SetVertexPosition 0 vertArr[3] [1, 0, 0]

					if progManager.UpdateProgress() == false then return()
				)

				unwMod2.unwrap.selectVertices #{}
				unwMod2.unwrap2.selectFaces #{}
				unwMod2.setTVSubObjectMode 3
			)

			displayMsg "Complete!"
			progManager.EndProgress()
		)
		

		"" -- return ""
	),

	initalized = Constructor()		
)