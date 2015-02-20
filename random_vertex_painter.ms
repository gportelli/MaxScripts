
global rFloater
try(closeRolloutFloater  rFloater)catch()

Rollout RL_Test "Random Vertex Painter"
(
	local Rad_MinColor = color 0 0 0
	local Rad_MaxColor = color 255 255 255
	local Debug = true
	--------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------
	fn isPoly obj = ((isKindOf obj Editable_Poly) or (isKindOf obj PolyMeshObject))
	--------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------
    button btn_paint "Paint"
	--------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------
	
	fn fColInt c = (color (c.r as integer) (c.g as integer) (c.b as integer))
	
	fn PaintVertex =
	(
		local V_Channel = 0
		local srcObjs = for iobj in selection where (isPoly iobj) collect iobj

		for myObj in srcObjs do
		(
			if Debug then (format "Poly: %\n" myObj.name)
			local faceCount = myObj.getnumfaces()
			for face_i = 1 to faceCount do
			(
				local myverts = polyop.getFaceVerts myObj  face_i
				local rand_color = random Rad_MinColor Rad_MaxColor
				local rndColorInt = fColInt rand_color
				local Faceverts = myverts as bitarray
				case classOf myObj of
				(
					Editable_Poly : (polyop.setVertColor myObj  V_Channel Faceverts rndColorInt)
					PolyMeshObject : (polyop.setVertColor myObj  V_Channel Faceverts rndColorInt)
				)
				if Debug then (format "Face: %    %\n" face_i (rndColorInt as string))
			)
		)
	)
	--------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------
    on btn_paint pressed do (PaintVertex()) 
)

rFloater = newRolloutFloater "Vertex tools" 200 100
addRollout RL_Test rFloater