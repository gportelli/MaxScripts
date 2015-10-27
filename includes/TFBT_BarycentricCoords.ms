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

	fn compareFaces obj1 faceid1 obj2 faceid2 epsilon =
	(
		local face1 = getFace obj1 faceid1
		local face2 = getFace obj2 faceid2

		for i=1 to 3 do
		(
			local vert1 = in coordsys local getVert obj1 face1[i]
			local vert2 = in coordsys local getVert obj2 face2[i]

			if (distance vert1 vert2) > epsilon then return false
		)

		true
	),

	fn findFaceMatch obj faceid searchObj =
	(
		local epsilon = 0.001

		local face = getFace obj faceid
		local vert = in coordsys local getVert obj face[1]

		local nVerts = getNumVerts searchObj 
		for vid in #{1..nVerts} do
		(
			local v = in coordsys local getVert searchObj vid
			if (distance vert v) <= epsilon then 
			(
				local facesUsingVert = meshop.getFacesUsingVert searchObj #{vid}
				for fid in facesUsingVert do
				(
					local result = compareFaces obj faceid searchObj fid epsilon
					if result == true then return fid
					--format "compare with face:% result:%\n" fid result
				)
			)
			--format "vert:% id:% v:% distance:%\n" vert vid v (distance vert v)
		)

		-1
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

	/*
	* Collapses UVW per face in the objects array of editable meshes
	*
	* objects: array of editable meshes
	* uvGeneratorFunction: function used to generate (u, v, w) for each face - function paradigm: uvGeneratorFunction(mesh, faceid) -> [u, v, w]
	* channel: uvw destination channel
	* includeLODs: if set to true objects are sorted according to their _LOD* suffix; each face in LOD[i] is searched in LOD[j>i] in order to maintain the same UVW coordinates for matching LOD faces
	* progressBarInstance: [optional] a progressBar instance to show the operation progress
	* msgLabelInstance: [optional] a label instance to show information about the operation progress (elapsed time, estimated time, progress percentage)
	*
	* return value: empty string if the operation was successful, error string if an error occurred
	*/
	fn AddCoords objects channel progressBarInstance:undefined msgLabelInstance:undefined semaphoreBitmapInstance:undefined =
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
				map1.mapChannel = channel
				addModifier obj map1
				
				local unwMod1 = unwrap_UVW()				

				unwMod1.name = "Barycentric UVW Ch : " + (channel as string)
				unwMod1.unwrap.setMapChannel channel
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
				map2.mapChannel = (channel + 1)
				addModifier obj map2

				local unwMod2 = unwrap_UVW()				

				unwMod2.name = "Barycentric UVW Ch : " + ((channel+1) as string)
				unwMod2.unwrap.setMapChannel (channel+1)
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