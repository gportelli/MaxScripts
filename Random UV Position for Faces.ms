global RNDUVFloater

Rollout RNDUV_roll "Parameters"
(
	local Wrbm = bitmap 15 15 color:red
	local Okbm = bitmap 15 15 color:green
	local Waitbm = bitmap 15 15 color:orange
	
	-- seme randomizzatore
	label lbSd "Seed..................." align:#left offset:[-3,3]
	spinner spSd range:[0,1000000,0] type:#integer fieldwidth:60 align:#left offset:[96,-19]
	-- canale di mappatura
	label lbCh "UV Channel..........." align:#left offset:[-3,5]
	spinner spCh range:[1, 99, 3] type:#integer fieldwidth:60 align:#left offset:[96,-19]
	
	checkbox include_lods "Include LODs" checked:false

	button btRandomUV "Random UV" width:100 height:20 align:#center --offset:[-8,0]	

	groupBox grpSep1 width:188 height:7 offset:[-14,-4] 
	imgTag imtWrn bitmap:Okbm align:#left offset:[-8,0]
	label lbWrn "Ready" align:#left offset:[14,-19] height:30

	/*
	// Start progress functions
	*/
	global lastProgress = 0
	global iteration = 0
	global totalIterations = 0

	fn initProgress label total =
	(
		lastProgress = 0
		iterations = 0
		totalIterations = total

		progressStart label
	)

	fn updateProgress =
	(
		iteration = iteration + 1
		progress = iteration * 100 / totalIterations

		if progress - lastProgress >= 1 do 
		(
			if progressUpdate(progress) == false do
			(
				progressEnd()
				return false
			)
			--format "%/% (%)\n" iteration totalIterations progress
		)
		lastProgress = progress	

		if getProgressCancel() do 
		(
			progressEnd()
			return false
		)		
	)

	fn endProgress =
	(
		progressEnd()
	)
	/*
	// End progress functions
	*/

	fn compareLODNames l1 l2 =
	(
		case of
		(
			(l1.name < l2.name): -1
			(l1.name > l2.name): 1
			default: 0
		) 
	)

	fn DisplayMsg msg success =
	(
		if success == true then imtWrn.bitmap = Okbm else imtWrn.bitmap = Wrbm
		lbWrn.text = msg
	)

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

		return true
	)

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

		return -1
	)

	on btRandomUV pressed do
	(	
		clearListener()	
		
		-- controllo selezione
		if (selection.count == 0) then (
			DisplayMsg "Select at least One Object !" false 
			return()
		)

		-- seme valido per sessione
		seed spSd.value
		
		/*
		// LODs Version
		*/
		if include_lods.checked then 
		(
			rgx = dotnetObject "System.Text.RegularExpressions.Regex" ""
			local lods = #()
			index = 1

			for obj in selection do
			(
				--format "name %\n" obj.name
	
				found = rgx.Match obj.name "(.+)_LOD([0-9])+$"

				if found.Value != "" and found.Groups.Count == 3 then
				(
					--format "found: value:% count:% value1:% value2:%\n" found.Value found.Groups.Count found.Groups.Item[1].Value found.Groups.Item[2].Value
					lods[index] = obj
					index = index + 1
				)
				else (
					msg = obj.name + " is not a LOD!"splineOps.startInsert
					DisplayMsg msg false 
					return ()
				)
			)

			qsort lods compareLODNames
			--for lod in lods do format "%\n" lod.name

			if lods.count == 0 then 
			(
				DisplayMsg "No lods found" false
				return ()
			)

			
			-- create bitarrays to flag processed faces
			local processedFaces = #()
			for i=1 to lods.count do
				processedFaces[i] = #{}

			--format "%\n" processedFaces

			local unwraps = #()
			for i=1 to lods.count do (
				unwraps[i] = unwrap_UVW()				

				unwraps[i].name = "Unwrap RND Ch : " + (spCh.value as string)
				unwraps[i].unwrap.setMapChannel spCh.value
				addmodifier lods[i] unwraps[i]

				unwraps[i].setTVSubObjectMode 3
			)

			local total = 0
			for i=1 to lods.count do total = total + lods[i].numfaces
			initProgress "Creating UVs" total	

			undo on
			(
				for i=1 to lods.count do (
					for face = 1 to lods[i].numFaces do
					(
						if processedFaces[i][face] == false do
						(
							format "processing face % of LOD%\n" face (i-1)
							processedFaces[i][face] = true

							local u = random 0.0 1.0
							local v = random 0.0 1.0

							unwraps[i].unwrap2.selectFaces #{face}
							unwraps[i].unwrap.breakSelected()

							local vertArr = #(
								(unwraps[i].getVertexIndexFromFace face 1),
								(unwraps[i].getVertexIndexFromFace face 2),
								(unwraps[i].getVertexIndexFromFace face 3)
							)
							for ver in vertArr do (unwraps[i].unwrap.SetVertexPosition 0 ver [u, v, 0])

							if updateProgress() == false do return()

							for j=i+1 to lods.count do
							(
								matchFace = findFaceMatch lods[i] face lods[j]

								if matchFace != -1 do
								(
									format "found match with face % of LOD%\n" matchFace (j-1)
									processedFaces[j][matchFace] = true;

									unwraps[j].unwrap2.selectFaces #{matchFace}
									unwraps[j].unwrap.breakSelected()

									local vertArr = #(
										(unwraps[j].getVertexIndexFromFace matchFace 1),
										(unwraps[j].getVertexIndexFromFace matchFace 2),
										(unwraps[j].getVertexIndexFromFace matchFace 3)
									)
									for ver in vertArr do (unwraps[j].unwrap.SetVertexPosition 0 ver [u, v, 0])

									if updateProgress() == false do return()
								)
							)
						)
					)

					unwraps[i].unwrap.selectVertices #{}
					unwraps[i].unwrap2.selectFaces #{}
				)

				--format "%\n" processedFaces
			)

			DisplayMsg "Complete!" true	
			endProgress()
		)
		else
		(
			/*
			// No LOD Version
			*/
			undo on
			(
				local total = 0
				for obj in selection do total = total + obj.numfaces
				initProgress "Creating UVs" total			

				for obj in selection do
				(
					local unwMod = unwrap_UVW()				

					unwMod.name = "Unwrap RND Ch : " + (spCh.value as string)
					unwMod.unwrap.setMapChannel spCh.value
					addmodifier obj unwMod

					unwMod.setTVSubObjectMode 3

					unwMod.unwrap.selectVertices #{}
					unwMod.unwrap2.selectFaces #{}

					for face=1 to obj.numfaces do
					(
						local u = random 0.0 1.0
						local v = random 0.0 1.0

						unwMod.unwrap2.selectFaces #{face}
						unwMod.unwrap.breakSelected()

						local vertArr = #(
							(unwMod.getVertexIndexFromFace face 1),
							(unwMod.getVertexIndexFromFace face 2),
							(unwMod.getVertexIndexFromFace face 3)
						)
						for ver in vertArr do (unwMod.unwrap.SetVertexPosition 0 ver [u, v, 0])

						if updateProgress() == false do return()
					)

					unwMod.unwrap.selectVertices #{}
					unwMod.unwrap2.selectFaces #{}
				)

				DisplayMsg "Complete!" true
				endProgress()
			)
		)
	)
)

if (RNDUVFloater != undefined) then CloseRolloutFloater RNDUVFloater
RNDUVFloater = NewRolloutFloater "RND UV" 200 200
addRollout RNDUV_roll RNDUVFloater