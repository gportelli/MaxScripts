global toolsFloater
try(closeRolloutFloater toolsFloater)catch()

rollout uvCollapseRoll "Collapse UV"
(	
	button btn_randomw "Set Random W"	
	button btn_collapse "Collapse UV to random point"		
	
	group "Show Triangular Edges" (
		button btn_collapse_triangle "Collapse tris over edges map"	
		spinner map_size "Map size: " range:[0,2048,1024] type:#integer
		spinner line_size "Map white size: " range:[0,800,256] type:#integer
		spinner line_thickness "Line thickness: " range:[0,800,2] type:#float
	)
	
	group "Debug" (
		spinner face_id "Face ID: " range:[1,2048,28] type:#integer
		button btn_select_face "Select mesh face"	
		button btn_select_uv_face "Select UV face"	
		spinner vertex_index "Vertex Index: " range:[1,3,1] type:#integer		
		button btn_select_vertex "Select mesh vertex"			
		button btn_select_uv_vertex "Select UV vertex"	
		button btn_open_uvw "Open UVW"	
		button btn_close_uvw "Close UVW"	
	)
	
	--button btn_createtriangles "Create Triangles"
	--button btn_breakfaces "Break Faces"
	--button btn_setchannel "Set Channel"
	
	on btn_select_face pressed do 
	(
		if selection.count != 1 do (
			messagebox "No object selected"
			return()	
		)
		
		obj = selection[1]
		
		if  isProperty  obj #unwrap_UVW == true do 
				deleteModifier obj 1
		
		subObjectLevel = 3
		setFaceSelection   obj #{face_id.value}
	)
	
	fn goToMapChannel chid =
	(
		dialogMonitorOps.unRegisterNotification id:#unwrap_reset

		fn confirmReset =
		(
			local hwnd = dialogMonitorOps.getWindowHandle()

			if UIAccessor.GetWindowText hwnd == "Unwrap UVW" then
			(
				uiAccessor.pressDefaultButton()
				true
			)
			else false
		)

		dialogMonitorOps.enabled = true
		dialogMonitorOps.interactive = false
		dialogMonitorOps.registerNotification confirmReset id:#unwrap_reset
		$.modifiers[#unwrap_uvw].reset()
		dialogMonitorOps.enabled = false
		
		$.modifiers[#unwrap_uvw].setMapChannel chid
	)
	
	on btn_select_uv_face pressed do 
	(
		if selection.count != 1 do (
			messagebox "No object selected"
			return()	
		)
		
		obj = selection[1]
		
		if  isProperty  obj #unwrap_UVW == false do 
		(
			unwrap = unwrap_UVW()
			addmodifier obj unwrap
			
			goToMapChannel 3
			
			unwrap.edit ()
		)
		
		subObjectLevel = 3
		
		obj.unwrap_UVW.selectFaces #{face_id.value}
	)

	on btn_select_vertex pressed do 
	(
		if selection.count != 1 do (
			messagebox "No object selected"
			return()	
		)
		
		obj = selection[1]
		
		if  isProperty  obj #unwrap_UVW == true do 
				deleteModifier obj 1
		
		subObjectLevel = 1
		
		face = getFace $ face_id.value
		
		setVertSelection obj #{face[vertex_index.value]}
	)
	
	on btn_select_uv_vertex pressed do 
	(
		if selection.count != 1 do (
			messagebox "No object selected"
			return()	
		)
		
		obj = selection[1]
		
		subObjectLevel = 1
		
		vid = obj.unwrap_UVW.getVertexIndexFromFace face_id.value vertex_index.value
		obj.unwrap_UVW.selectVertices #{vid}		
	)
	
	on btn_open_uvw pressed do 
	(
		if  isProperty  $ #unwrap_UVW == false do 
		(
			unwrap = unwrap_UVW()
			addmodifier $ unwrap
			
			goToMapChannel 3
			
			unwrap.edit ()
		)
	)
	
	on btn_close_uvw pressed do 
	(
		if  isProperty  $ #unwrap_UVW == true do 
			deleteModifier $ 1
	)
	
	fn showAllEdges =
	(
		print "Setting edges visible..."
			
		if selection.count != 1 do (
			messagebox "No object selected"
			return()	
		)
		
		obj = selection[1]
		
		obj.allEdges = true -- Show all edges
		select obj -- Select the mesh
		max modify mode -- Switch to Modify panel
		subObjectLevel = 2 -- Set Sub-Object level to Edge
		for face = 1 to obj.numfaces do -- Go through all faces
			for edge = 1 to 3 do -- And for every of the 3 edges
					setEdgeVis obj face edge true
	)
	
	fn breakFaces =
	(		
		obj = selection[1]
		
		if  obj.unwrap_UVW == undefined do return()
		
		print "Breaking faces..."
		
		obj.unwrap_UVW.setTVSubObjectMode 3
		
		obj.unwrap_UVW.selectFaces #{1..obj.numfaces}
			
		for face in obj.unwrap_UVW.getSelectedFaces() do
		(
			--format "breaking face %...\n" face
			obj.unwrap_UVW.selectFaces #{face}
			obj.unwrap_UVW.breakSelected() 
		)
	)
	
	on btn_createtriangles pressed do 
	(
		undo on
		(
			showAllEdges ()
		)
	)
	
	on btn_breakfaces pressed do 
	(
		breakFaces()
	)
	
	on btn_setchannel pressed do 
	(
		if selection.count != 1 do (
			messagebox "No object selected"
			return()	
		)
		
		obj = selection[1]
		
		if  isProperty  obj #unwrap_UVW == true do 
				deleteModifier obj 1
			
		unwrap = unwrap_UVW()
		addmodifier obj unwrap
		
		obj.unwrap_UVW.setMapChannel 3
	)
	
	on btn_randomw pressed do 
	(
		if selection.count != 1 do (
			messagebox "No object selected"
			return()	
		)
		
		obj = selection[1]
		
		undo on
		(
			if  isProperty  obj #unwrap_UVW == true do 
				deleteModifier obj 1
			
			--showAllEdges()
			
			unwrap = unwrap_UVW()
			addmodifier obj unwrap
			obj.unwrap_UVW.setMapChannel 3
			
			breakFaces()
			
			obj.unwrap_UVW.selectFaces #{1..obj.numfaces}
			
			for face in obj.unwrap_UVW.getSelectedFaces() do
			(
				format "face (%)\n" face
				
				obj.unwrap_UVW.selectFaces #{face}
				obj.unwrap_UVW.faceToVertSelect()
				
				local w = random 0.0 1.0
				
				format "Setting w = (%)\n" w
				
				for ver in obj.unwrap_UVW.getSelectedVertices() do
				(
					vp = obj.unwrap_UVW.getVertexPosition 0 ver
					format "vertex (%) pos: % %\n" ver vp.x vp.y
					
					obj.unwrap_UVW.SetVertexPosition 0 ver [vp.x, vp.y, w]
				)
			)
			
			obj.unwrap_UVW.selectFaces #{}
		)		
	)
	
	on btn_collapse pressed do 
	(
		if selection.count != 1 do (
			messagebox "No object selected"
			return()	
		)
		
		obj = selection[1]
		
		undo on
		(
			if  isProperty  obj #unwrap_UVW == true do 
				deleteModifier obj 1
			
			--showAllEdges()
			
			unwrap = unwrap_UVW()
			addmodifier obj unwrap
			obj.unwrap_UVW.setMapChannel 3
			
			breakFaces()
			
			obj.unwrap_UVW.selectFaces #{1..obj.numfaces}
			
			for face in obj.unwrap_UVW.getSelectedFaces() do
			(
				--format "face (%)\n" face
				
				obj.unwrap_UVW.selectFaces #{face}
				obj.unwrap_UVW.faceToVertSelect()
				
				local u = random 0.0 1.0
				local v = random 0.0 1.0
				
				--format "Setting uv = (%,%)\n" u v
				
				for ver in obj.unwrap_UVW.getSelectedVertices() do
				(
					vp = obj.unwrap_UVW.getVertexPosition 0 ver
					--format "vertex (%) pos: % %\n" ver vp.x vp.y
					
					obj.unwrap_UVW.SetVertexPosition 0 ver [u, v, 0]
				)
			)
			
			obj.unwrap_UVW.selectFaces #{}
		)
	)
	
	fn pointLineDist2 pA pB pC = (
		local vAB=pB-pA
		local vAC=pC-pA
		return (length (cross vAB vAC))/(length vAB)
	)

	fn getLineOffset p1 p2 p0 diag =
	(
		-- get distance of p0 from segment p1-p2 (height of the triangle respective to p1-p2 segment)
		h = pointLineDist2 p1 p2 p0
		k = line_thickness.value / h
		if h_perc > 1 then k = 1				
		
		line_s  = float(line_size.value)
		map_s = float(map_size.value)
		
		if diag == 0 then
			max_k = line_s / (map_s - line_s * (1 + sqrt(2)))
		else
			max_k = line_s / (map_s / sqrt(2) - line_s * sqrt(2))
				
		format "h=% h_perc=% max_perc=% \n" h h_perc max_perc
				
		if k >  max_k then (
			k = max_k
			format "clamped to %\n" h_perc
		)
		
		black_l      = map_s - line_s * (2 + sqrt(2))
		black_diag = black_l / sqrt(2)
		
		--format "black_l=% black_diag=%\n" black_l black_diag
			
		if diag == 0 then
			black_s = black_l / map_s
		else
			black_s = black_diag / map_s
		
		return line_s / map_s - h_perc * black_s / (1 - k)
	)
	
	on btn_collapse_triangle pressed do 
	(
		if selection.count != 1 do (
			messagebox "No object selected"
			return()	
		)
		
		obj = selection[1]
		
		clearListener()
		
		undo on
		(
			if  isProperty  obj #unwrap_UVW == true do 
				deleteModifier obj 1
			
			showAllEdges()
			
			unwrap = unwrap_UVW()
			addmodifier obj unwrap
			obj.unwrap_UVW.setMapChannel 3
			
			breakFaces()
			
			uvArray = #([0, 0, 0], [0, 1, 0], [1, 1, 0])
				
			for face in #{1..obj.numfaces} do
			(
				format "Face %...\n" face
				
				-- get mesh vertex indexes for current face
				meshverts = getFace $ face
				
				-- get mesh vertex positions for curent face
				mv1 = getVert obj meshverts[1]
				mv2 = getVert obj meshverts[2]
				mv3 = getVert obj meshverts[3]
				
				-- get offsets for each face edge
				eo1 = getLineOffset mv1 mv2 mv3 0
				eo2 = getLineOffset mv2 mv3 mv1 0
				eo3 = getLineOffset mv3 mv1 mv2 1
				
				/*
				eo1=0 --float(line_size.value) / map_size.value
				eo2=0 -- float(line_size.value) / map_size.value
				eo3=0 --float(line_size.value) / map_size.value
				*/

				format "Edge offsets: (%, %, %)\n" eo1 eo2 eo3 				
				
				-- get map face vertex indexes				
				uv1 = obj.unwrap_UVW.getVertexIndexFromFace face 1
				uv2 = obj.unwrap_UVW.getVertexIndexFromFace face 2
				uv3 = obj.unwrap_UVW.getVertexIndexFromFace face 3
				
				uvArray[1].x = eo1
				uvArray[2].x = eo1
				
				uvArray[2].y = 1 - eo2
				uvArray[3].y = 1 - eo2
				
				uvArray[1].y = eo3 * sqrt(2) + eo1
				uvArray[3].x = 1 - eo3 * sqrt(2) - eo2
				
				-- set texture vertex positions
				obj.unwrap_UVW.SetVertexPosition 0 uv1 uvArray[1]
				obj.unwrap_UVW.SetVertexPosition 0 uv2 uvArray[2]
				obj.unwrap_UVW.SetVertexPosition 0 uv3 uvArray[3]				
			)
			
			obj.unwrap_UVW.selectFaces #{}
		)
	)
)	

toolsFloater = newRolloutFloater "UV Tools" 200 450
addRollout uvCollapseRoll toolsFloater
