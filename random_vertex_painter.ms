try(closeRolloutFloater  rFloater)catch()

fn GetRandomColor Rad_MinColor Rad_MaxColor  =
(
	min_1= Rad_MinColor.r as integer
	min_2= Rad_MinColor.g  as integer
	min_3= Rad_MinColor.b as integer

	Max_1= Rad_MaxColor.r as integer
	Max_2= Rad_MaxColor.g as integer
	Max_3= Rad_MaxColor.b as integer


	rad_1= random min_1  Max_1
	rad_2= random min_2 Max_2
	rad_3= random min_3  Max_3
		
		
	rand_color= color rad_1 rad_2 rad_3
		
	return rand_color
)

Rollout RL_Test "Random Vertex Painter"
(
    button btn_paint "Paint"
    on btn_paint pressed do
    (
		 PaintVertex ()
    ) 
)

fn  isPoly obj=
(
  if ( classof obj == Editable_Poly  or  classof obj  == PolyMeshObject ) then  
	  return true
  else
	return false
)


fn PaintVertex =
(
	V_Channel = 0
	
	srcObjs = #()
	srcObjs = for iobj in selection where isPoly(iobj) collect iobj --Only EDitpoly

	local nObjs= srcObjs.count
    format "nObjs: %\n"  nObjs
	
	faceIndex = 0
	for myObj in srcObjs do
	(
		faceCount = myObj.getnumfaces()
		format "Facecount = %\n" faceCount
		
		--aceTest = ((myObj.getnumfaces()) != 0)
		for face_i= 1 to faceCount  do	--ends loop when there are no faces left to select
		(
			--myObj.EditablePoly.SetSelection #Face #{face_i} -- Select face 
			--format "FACE: %  \n" face_i
			myverts = polyop.getFaceVerts myObj  face_i
			format "Face %\n" faceIndex
			print myverts
			
			Rad_MinColor = color 0 0 0
			Rad_MaxColor = color 255 255 255
			rand_color = GetRandomColor Rad_MinColor Rad_MaxColor
			
			format "color %\n\n" rand_color
			
			Faceverts= myverts as bitarray
							 
			case classOf myObj of
			(
				Editable_Mesh :  meshop.setVertColor myObj  V_Channel  Faceverts rand_color
				Editable_Poly :  polyop.setVertColor myObj  V_Channel  Faceverts rand_color
				PolyMeshObject : polyop.setVertColor  myObj  V_Channel Faceverts rand_color
			)
			
			faceIndex = faceIndex +1
		)
	)
)

rFloater = newRolloutFloater "Vertex tools" 200 100
addRollout RL_Test rFloater