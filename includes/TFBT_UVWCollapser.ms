if TFBT_Utils == undefined then 
	fileIn (getFilenamePath(getThisScriptFilename()) + "TFBT_Utils.ms")

struct TFBT_UVWCollapser
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
	fn CollapseUVW objects uvGeneratorFunction channel includeLODs:false progressBarInstance:undefined msgLabelInstance:undefined semaphoreBitmapInstance:undefined =
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

		/*
		// Include LODs version
		*/
		if includeLODs then 
		(
			rgx = dotnetObject "System.Text.RegularExpressions.Regex" ""
			local lods = #()
			index = 1

			for obj in selection do
			(
				found = rgx.Match obj.name "(.+)_LOD([0-9])+$"

				if found.Value != "" and found.Groups.Count == 3 then
				(
					lods[index] = obj
					index = index + 1
				)
				else (
					msg = obj.name + "\nis not a LOD!"
					return displayMsg msg error:true
				)
			)

			-- sorting LODs from LOD0 to LODn
			qsort lods compareLODNames

			if lods.count == 0 then 
				return displayMsg "No lods found" error:true

			
			-- create bitarrays to flag processed faces
			local processedFaces = #()
			for i=1 to lods.count do
				processedFaces[i] = #{}

			--format "%\n" processedFaces

			local unwraps = #()
			for i=1 to lods.count do (
				local map = uvwmap()
				map.maptype = 5
				map.mapChannel = channel
				addModifier lods[i] map

				unwraps[i] = unwrap_UVW()				

				unwraps[i].name = "Collapsed UVW Ch : " + (channel as string)
				unwraps[i].unwrap.setMapChannel channel
				addmodifier lods[i] unwraps[i]
				breakAllFaces unwraps[i] lods[i].numfaces
				unwraps[i].setTVSubObjectMode 1
			)

			local total = 0
			for i=1 to lods.count do total = total + lods[i].numfaces
			progManager.Start total	

			undo on
			(
				for i=1 to lods.count do (
					for face = 1 to lods[i].numFaces do
					(
						if processedFaces[i][face] == false do
						(
							--format "processing face % of LOD%\n" face (i-1)
							processedFaces[i][face] = true

							uvs = uvGeneratorFunction lods[i] face

							local vertArr = #(
								(unwraps[i].getVertexIndexFromFace face 1),
								(unwraps[i].getVertexIndexFromFace face 2),
								(unwraps[i].getVertexIndexFromFace face 3)
							)
							for ver in vertArr do (unwraps[i].unwrap.SetVertexPosition 0 ver [uvs[1], uvs[2], uvs[3]])

							if progManager.UpdateProgress() == false do return()

							for j=i+1 to lods.count do
							(
								matchFace = findFaceMatch lods[i] face lods[j]

								if matchFace != -1 do
								(
									--format "- found match with face % of LOD%\n" matchFace (j-1)
									processedFaces[j][matchFace] = true;

									local vertArr = #(
										(unwraps[j].getVertexIndexFromFace matchFace 1),
										(unwraps[j].getVertexIndexFromFace matchFace 2),
										(unwraps[j].getVertexIndexFromFace matchFace 3)
									)
									for ver in vertArr do (unwraps[j].unwrap.SetVertexPosition 0 ver [uvs[1], uvs[2], uvs[3]])

									if progManager.UpdateProgress() == false do return()
								)
							)
						)
					)

					unwraps[i].unwrap.selectVertices #{}
					unwraps[i].unwrap2.selectFaces #{}
				)

				--format "%\n" processedFaces
			)

			progManager.EndProgress()
			displayMsg "Complete!"
		)
		else
		(
			/*
			// No LODs Version
			*/
			undo on
			(
				local total = 0
				for obj in selection do total = total + obj.numfaces
				progManager.Start total				

				for obj in selection do
				(
					/* Use a uvwmap of type faces to make sure that all faces are detached */
					local map = uvwmap()
					map.mapChannel = channel
					map.maptype = 5					
					addModifier obj map

					local unwMod = unwrap_UVW()				

					unwMod.name = "Collapsed UVW Ch : " + (channel as string)
					unwMod.unwrap.setMapChannel channel
					addmodifier obj unwMod

					breakAllFaces unwMod obj.numfaces

					for face=1 to obj.numfaces do
					(
						local uvs = uvGeneratorFunction obj face

						local vertArr = #(
							(unwMod.getVertexIndexFromFace face 1),
							(unwMod.getVertexIndexFromFace face 2),
							(unwMod.getVertexIndexFromFace face 3)
						)
						for ver in vertArr do (unwMod.unwrap.SetVertexPosition 0 ver [uvs[1], uvs[2], uvs[3]])

						if progManager.UpdateProgress() == false then return()
					)

					unwMod.unwrap.selectVertices #{}
					unwMod.unwrap2.selectFaces #{}
					unwMod.setTVSubObjectMode 3
				)

				displayMsg "Complete!"
				progManager.EndProgress()
			)
		)

		"" -- return ""
	),

	initalized = Constructor()		
)