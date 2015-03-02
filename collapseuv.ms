global toolsFloater
try(closeRolloutFloater toolsFloater)catch()

rollout uvCollapseRoll "Collapse UV"
(	
	button btn_collapse "Collapse UV to random points"	
	--button btn_randomw "Set Random W"	
	
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
)	

toolsFloater = newRolloutFloater "UV Tools" 200 150
addRollout uvCollapseRoll toolsFloater
