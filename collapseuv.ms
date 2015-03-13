global toolsFloater
try(closeRolloutFloater toolsFloater)catch()

rollout uvCollapseRoll "Collapse UV"
(	
	spinner uv_channel "UV Channel: " range:[1,10,3] type:#integer

	--button btn_randomw "Set Random W"	
	group "Face Indexing" (
		button btn_collapse "Collapse UV to random point"		
	)
	
	group "Show Triangular Edges" (
		button btn_collapse_triangle "Map triangles for edge mapping"	
		spinner map_size "Map size (px): " range:[0,2048,1024] type:#integer
		spinner line_size "Map line size (px): " range:[0,800,256] type:#integer
		spinner line_thickness "Line thickness (units): " range:[0,800,1] type:#float
		checkbox include_invisible "Include invisible edges" checked:false
	)
	/*
	group "Debug" (
		spinner face_id "Face ID: " range:[1,2048,28] type:#integer
		button btn_select_face "Select mesh face"	
		button btn_select_uv_face "Select UV face"	
		spinner vertex_index "Vertex Index: " range:[1,3,1] type:#integer		
		button btn_select_vertex "Select mesh vertex"			
		button btn_select_uv_vertex "Select UV vertex"	
		spinner edge_index "Edge Index: " range:[1,3,1] type:#integer		
		button btn_select_edge "Select mesh edge"			
		button btn_get_edge_visible "Get edge visible"			
		button btn_open_uvw "Open UVW"	
		button btn_close_uvw "Close UVW"	
	)
	*/
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
			
			goToMapChannel uv_channel.value
			
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
	
	on btn_select_edge pressed do 
	(
		if selection.count != 1 do (
			messagebox "No object selected"
			return()	
		)
		
		obj = selection[1]
		
		if  isProperty  obj #unwrap_UVW == true do 
				deleteModifier obj 1
		
		subObjectLevel = 2
		
		setEdgeSelection $ #{((face_id.value-1)*3)+ edge_index.value}
	)

	on btn_get_edge_visible pressed do 
	(
		if selection.count != 1 do (
			messagebox "No object selected"
			return()	
		)
		
		obj = selection[1]
		
		if  isProperty  obj #unwrap_UVW == true do 
				deleteModifier obj 1
		
		subObjectLevel = 2
		
		format "edge visible: %\n" (getEdgeVis $ face_id.value edge_index.value)
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
			
			goToMapChannel uv_channel.value
			
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
		
		obj.unwrap_UVW.setMapChannel uv_channel.value
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
			obj.unwrap_UVW.setMapChannel goToMapChannel uv_channel.value
			
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
			obj.unwrap_UVW.setMapChannel uv_channel.value
			
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
	
	-- returns dinstance of vertex p0 from segment pA-pB
	fn pointLineDist2 pA pB p0 = (
		local vAB=pB-pA
		local vA0=p0-pA
		return (length (cross vAB vA0))/(length vAB)
	)

	-- returns incenter of triangle with vertex pA pB pC
	fn getIncenter pA pB pC =
	(
		local a = length(pB - pC)
		local b = length(pA - pC)
		local c = length(pB - pA)
		
		local incenter = (a * pA + b * pB + c * pC) / (a+ b + c)
		
		return incenter
	)
	
	-- returns the inset vertex relative to p0 in triangle pA pB p0 where inset is the thickness of the inset
	fn getInsetVertex pA pB p0 inset =
	(
		incenter = getIncenter pA pB p0
		mA0 = pointLineDist2 pA p0 incenter
		r = inset / mA0
		if r > 1 then r = 1
			
		return p0 + (incenter - p0) * r
	)

	-- return the inset vertex relative to pA-p0 edge where inset is the thickness of the inset in pB-p0
	fn getHalfInsetVertex pA pB p0 inset =
	(
		h = pointLineDist2 pB p0 pA
		x = inset * length(p0 - pA) / h

		if x > length(p0 - pA) then 
			return pA
		else (
			res = p0 + (pA - p0) * x / length(p0 - pA)
			--format "getHalfInsetVertex: %\n" res
			return res
		)
	)
	
	-- get ratio between thickness and height from edge p1-p2 to p3 inset, edge_indexi is the index of the edge pi in the face
	fn getLineTicknessPerc p1 p2 p3 face edge_index1 edge_index2 edge_index3 =
	(
		line_t = float(line_thickness.value)

		-- get distance of p0 from segment p1-p2 (height of the triangle respective to p1-p2 segment)
		if include_invisible.checked == true then
			inset = getInsetVertex p1 p2 p3 line_t
		else
		(
			if getEdgeVis $ face edge_index2 == false and getEdgeVis $ face edge_index3 == false then
				inset = p3
			else if getEdgeVis $ face edge_index2 == false then
				inset = getHalfInsetVertex p2 p1 p3 line_t
			else if getEdgeVis $ face edge_index3 == false then
				inset = getHalfInsetVertex p1 p2 p3 line_t
			else
				inset = getInsetVertex p1 p2 p3 line_t
		)

		h = pointLineDist2 p1 p2 inset
		k = line_t / h
		
		root2 = sqrt(2)
		line_s  = float(line_size.value)
		map_s = float(map_size.value)
		l = (map_s - line_s * (2 + root2)) / map_s
		
		max_k = line_s/map_s*2 / (line_s/map_s*2 + l/root2)
			
		if k > 1 then return 1
		if k > max_k then return max_k else return k
	)
	
	-- get UV offsets of triangle p1-p2-p3 given k1 k2 k3 line thickness ratios
	fn getTriangleOffsets p1 p2 p3 k1 k2 k3 face =
	(
		local root2 = sqrt(2)
		local line_s  = float(line_size.value)
		local map_s = float(map_size.value)
		
		if k1 == 1 or k2 == 1 or k3 == 1 then
			return [0, 0,  1/root2]
		
		local l = (map_s - line_s * (2 + root2)) / map_s
		
		if include_invisible.checked == true then
		(
			local e1 = line_s / map_s - l * k1 / (1 - k1)
			local e2 = line_s / map_s - l * k2 / (1 - k2)
			local e3 = line_s / map_s - l / root2 * k3 / (1 - k3)
		)
		else
		(
			--format "getTriangleOffsets face:%\n" face

			if getEdgeVis $ face 2 == false and getEdgeVis $ face 3 == false then (
				ll = l - l * 0.1  - l * 0.1 * root2
				--format "a\n"
			)
			else if getEdgeVis $ face 2 == false then (
				ll = l - l * 0.1
				--format "b\n"
			)
			else if getEdgeVis $ face 3 == false then (
				ll = l - l * 0.1 * root2
				--format "c\n"
			)
			else (
				ll = l 
				--format "d\n"
			)
			local e1 = line_s / map_s - ll * k1 / (1 - k1)

			if getEdgeVis $ face 1 == false and getEdgeVis $ face 3 == false then (
				ll = l - l * 0.1  - l * 0.1 * root2
				--format "a\n"
			)
			else if getEdgeVis $ face 1 == false then (
				ll = l - l * 0.1
				--format "b\n"
			)
			else if getEdgeVis $ face 3 == false then (
				ll = l - l * 0.1 * root2
				--format "c\n"
			)
			else (
				ll = l 
				--format "d\n"
			)
			local e2 = line_s / map_s - ll * k2 / (1 - k2)

			if getEdgeVis $ face 1 == false and getEdgeVis $ face 2 == false then (
				ll = l / root2 - l * 0.1 * root2
				--format "a\n"
			)
			else if getEdgeVis $ face 1 == false or getEdgeVis $ face 2 == false then (
				ll = l * 0.9 / root2
				--format "b\n"
			)
			else (
				ll = l / root2
				--format "c\n"
			)
			local e3 = line_s / map_s - ll * k3 / (1 - k3)
		)
			
		return [e1, e2, e3]
	)
	
	-- creates UV coords for each triangle in order to obtain constant thickness edge lines
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
			
			--showAllEdges()
			
			unwrap = unwrap_UVW()
			addmodifier obj unwrap
			obj.unwrap_UVW.setMapChannel uv_channel.value
			
			breakFaces()
			
			uvArray = #([0, 0, 0], [0, 1, 0], [1, 1, 0])
				
			for face in #{1..obj.numfaces} do
			(
				--format "Face %...\n" face
				
				-- get mesh vertex indexes for current face
				meshverts = getFace $ face
				
				-- get mesh vertex positions for curent face
				mv1 = getVert obj meshverts[1]
				mv2 = getVert obj meshverts[2]
				mv3 = getVert obj meshverts[3]
				
				-- get offsets for each face edge
				k1 = getLineTicknessPerc mv1 mv2 mv3 face 1 2 3
				k2 = getLineTicknessPerc mv2 mv3 mv1 face 2 3 1
				k3 = getLineTicknessPerc mv1 mv3 mv2 face 1 3 2
				
				--format "tickness: (%, %, %)\n" k1 k2 k3
				
				line_s  = float(line_size.value)
				map_s = float(map_size.value)
				
				offsets = getTriangleOffsets mv1 mv2 mv3 k1 k2 k3 face
				--format "Edge offsets: %\n" offsets
				local eo1 = offsets[1]
				local eo2 = offsets[2]
				local eo3 = offsets[3]

				if include_invisible.checked == false then
				(
					local l = line_s / map_s
					local m = (map_s - line_s * (2 + sqrt(2))) / map_s / 10
					if getEdgeVis $ face 1 == false then eo1 = l + m
					if getEdgeVis $ face 2 == false then eo2 = l + m
					if getEdgeVis $ face 3 == false then eo3 = l + m
				)
				
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

toolsFloater = newRolloutFloater "UV Tools" 250 550
addRollout uvCollapseRoll toolsFloater
