/*
	UE Static Mesh Exporter 0.2
	2015
	Max Script 2014
	Copyright (c) 2014 Daniele Salvetti
	All rights reserved.
	--------------------------------
	Start: Menu Maxscript -> Run Script -> 
	Disclamer:I am not responsible or liable, directly or indirectly, for any damage or loss caused by or in connection with the use of this script.
	
	Works with Unreal Engine 4.8.1
	
TODO:

id = $Box01.handle 
node =maxOps.getNodeByHandle

*/


global UEExportFloater
rollout UEExport_roll "Static Mesh Parameters"
(
	-- funzione che crea l'icona rossa in stringa Base64 png 20x20 alpha
	fn fWrImg =
	(
		local WrImg = "iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAA"
			  WrImg += "OpgAABdwnLpRPAAAAAlwSFlzAAALEgAACxIB0t1+/AAABQdJREFUOE9llAtMk1cYho8FeqXU0jb0kupAhkMccwnCQGGohAaVgUCywSiGLAPicMnCRDJ1gOiYYwE1McZs"
			  WrImg += "c4M43EQ2ARkqQwQFxrhYrTdARYFyG3JxykUo776/ZFHjn7w55//e8z15z/nbsyguLm6FnZ3dCHvxWcRjGge+wd1Z9oFOpVotX7xYacdbxEbHxh/1jfzT1j06/uuDyckL"
			  WrImg += "djze7IttVqtVyZqbm1/StoT4sNPZmQPtBw/iZsFhUgGa8vJQRzKRblH9esEhlGfljGw3GmNeCsK9REZGqurq6hinXVsTv23I3Yf2fVm4mpMNc3YO2jMz0VtZgVHTNZi/"
			  WrImg += "PgBT1l5cy8qGae9eNH+Vi5zEj75jjGfjcixmMBiUVVVV7LPY9/Mad32Blh0ZaEtPxw2SOS0N9w7mA/Pz4J6pu3fRRLXbaZ/DRH7Lzh1ozchAZpyRoMzGYuvXr1dGG8LW"
			  WrImg += "XPw0FQ3bk9CW/AnMySnoSklBZ1KSTdaJCRt0tLQUbfR+j7wb27ahLSUZDalJqN+eioTQTe9xLBYYGKg8Gh87Vp+QgEZjPK4ajeiINeJBbBz6P07G4LFjGK2uxL9trRj8"
			  WrImg += "8QcMHvgG98nrio3HjTijrac+MR4n4j+cCgwMUrKNAWsiKmNiUB0RgabICJhJ98Oj0bl5MyZKS2xbxews5p9O2qbzj8dxJ2IzHpJ/OzwcrRHRuBwehQsxkYhauyaRpQYE"
			  WrImg += "lV4whOHihhC0hATjVsg6PKR5b3AwpsvKF85v5hlB5wDrPOYejaB3Qyj6yb8dGkw9BlxaZ0BNaAh2Bb3byPb7BQyUBfih1t8frf6+6PD1Q6/fWgz6+GCmqNiWDlOUbpaD"
			  WrImg += "PsNcTw+GfddiiPxO6mvzD0KtXwDOUv9h36AxlrviDZx8azlqvL3RutILHaQhr9UY8vTE9InjC8BJAs7QSPO5nm4MrvLECPndXt5oX7kKtSu9UeLqijydDmy3kyO+5/NQ"
			  WrImg += "LpDgiqMYN2VyDKiWoE+hoIQnaZtWSviEgNO2bc8NDZOvQJ9Uig7xYjQ5iFAh5KPQno8cMR8sVSztL+Tb4zd7IWr5fJh4juiieS9jeLpzD+a57XIJnxGQUk6Z2mFhPJtv"
			  WrImg += "thfjir0jyqi/iIBpYuEY2ygS/fIzJSvhC1FDahaK0UngQaE9LDweJnanU8KZhTMc6MdDsT0GqN5NkOu0vp6AZ4RCFBMjTiK5yNwEkk2FUhWKJRJUiaRoEglwRyBAHx1B"
			  WrImg += "j4MDJrbGUjqCcVu39KCPahbSHZEILbS2WiRDKfUVKWTwkkgSmEAgdM5wVo6eUklQKpejQSJDO51PF4lrGk9PW/gtcs/IsK12l3Sd/MsyCcrlMvyukOKATDYtEApVTCwW"
			  WrImg += "y92kMv9iFxVK6EP8KVOgiUazXIG/qOnRni+fAx8/wd9UM5NayK+REYzGU/R133aUbuJYzMnJSe7j48PCnBW5FTo9TutVOK+Ro1mhQhUlHsve/xxIs7NUayTVK1xQ4aJA"
			  WrImg += "hV6HaKXmKHc5cCzm7Owspz81d0mwKBdd7hnXpTivd8Efeg2BNTC9EwhLQT6GDxXAsj8L51RcXYdq8std9YjVaI78fydyLLZly5aXFKDShuW/5v7gnJsHLnm4oUyrRSGp"
			  WrImg += "iFRMuuyxBFUe7sh3c7cEq7VRr1ywarXaVavVyl+UWq1VheqXxKctXVZ2ZNlyy0+eb1qPe3laC173tKQvc6006HVbaY361T616391bUZlyu41ogAAAABJRU5ErkJggg=="
		-- icona rossa
		WrImg
	)
	-- funzione che crea l'icona verde in in stringa Base64 png 20x20 alpha
	fn fOkImg =
	(
		local OKImg = "iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAA"
			  OKImg += "OpgAABdwnLpRPAAAAAlwSFlzAAALEgAACxIB0t1+/AAABWNJREFUOE9dlAlMFEYYhccN4N4Xu+AuLLBARQSlIEWOQpFiFxGrHNpCW12QS3QhVrlBlEMIIAtGrKVYq9Ui"
			  OKImg += "h0orcskRURASD0BJkwoNTaNIQUWpCFV5Hdak0U7y8v8zyfvy/slkFvX39xsSQmao/lvDo8OMmvaamCWm8i1yhWypyFDMW0QWkcdTE88fjD289+CPh+fcrF0rPvZY8+Jt"
			  OKImg += "H+3ZpK+v7x35bFXtyPguY6q0pRTazhIUtRShqIGK1tL2MmjbtdC2apH1w4Hp9ZH+e/nWbGJgq0+IBcUpqa5cucKiWqgkcE9Ybd6FfOReykVOax5yWrJR0JmPM4NnUNRT"
			  OKImg += "hJy2bBy8TM+bc5DblIe8+oMITfmskamkQJM3LNLU1MSkIhtiNtak1aQj6XwqUi7R2pqGxNZEDDwdwML69flvSGpPxt6ORCRfTkFKQzqS69ORcj4FG/cENDNkDB2L1NXV"
			  OKImg += "MVf7e4TFnUzAzppY7KjXIL4xHnFtcYjtisXQ7B0dsG+6F9HXohHTGw1N1y5oWjSIq6e1RgPN6V3wCPNKWGCR4pJi5hc5oTPqE1uhPrsN6gY1wtu3IfL6doT2hiJmMApd"
			  OKImg += "j66iY7wNWff2I7QvFBHXtyGiMxzqRjW2n41A+KlwhJV89XJfbhaLuKx3jgopC8GmyiBsrgrG5xe3IOga7W8EIeBmALRjh/HnP/fxArN4iXlkjGQgoDsAQd2BCG4NQXB1"
			  OKImg += "CIKOU/83QXAMdsokbmq3ayqtCmsr/OBfpcK6Syr49argfcsbsaNRunGn8AzD86MU+FK3jxrZDu+r3lC1fQJVnS/8vveD79G1cI/1HCJuO90m3Q+5w7PiI3iddYdXqwdc"
			  OKImg += "ej6Ay4Azhl4N4jVNNfJ6GI/wFL88r0fPXDee4DE23AqCS7MLvGrd4V7pBvcSV6ze7fmE2EevmLPPXYn3y52w6idHODTbY0WXPc4/rtWlyXiWhJuv+nS99pkWm8cDdX3E"
			  OKImg += "cDhsm2zhXO0Eh6MOWJr1HuSRlrOEt0k0p69hgpPDgeSYGII6Hqy6zPE7TVU6UwzFfRnuzL95Ot/+XY5Px30xgXGsueED1jnqq2SBlysEN54FVih3jvBVoonFCQZgHmCC"
			  OKImg += "W86GoIoHbutiyAaFIHcJvB440WGn6ejA0PwQVo0sh8VtBSQdfLBr9MA9ygZvvxCceA6YmwVPiMBT1MnVsMHJZINbIoDwlACGDRwwuhlg9DHQMdeGv+gN7n+UoUuZOZkG"
			  OKImg += "RhsDkhZ9CKu4EBzmQbCPAr8WwGCdcIBw7ASRomgj8FMorEACwXE+JOeMof+zPnz7XXWQwul86F/Xxx3cxSSF81u5dNzFEJ0SQlgsgCBVBGGCABxXURoxlEmYki2yWXG6"
			  OKImg += "BIbZEojL+eCfFoN1moXO2TYdUHlDAVYLC2H3QnX7yNuRYB1jQVwhhfigIYSZNEyk5LXU0phDbGxs9IQrRV/Kd5tCkmYEaYExeIU8BHcF68z5Y4Xg0XsVNwvAu8Cj40/Q"
			  OKImg += "Rz4DSbkI/HwBjLOWYEkiDeKtSFhgEWdnZz0qIvGQVpsmW8I4WwFRsgg/jp6ktjkYnpRCcsIQVrUmEB0RIep2FB5SrHX5UogTpTDNMIfROqNGrpyrYxEfHx89qoVKzP0t"
			  OKImg += "qhXpSpjkKeB8xBH2FXaQlhnB4rgllJVmsDhmAWmxFLIyGczylbBMtYEs0PQi24ZNmKYMHYsEBga+I5MPTTRWcTaT8lQzyDPkUBZQ4yFrWBYqYV1Ea5455GlyWOywnDJe"
			  OKImg += "Y5zKt+cTtj2bsOifyLIyIEStVjOp9N6Wo5czV6FanmS21bJn2S7bMbskhxm75JUzNjuXjVtFKHsVfuZp1qttRP/3LbD+BaJFOPCedZz0AAAAAElFTkSuQmCC"
		-- icona verde
		OKImg
	)
	-- funzione che converte una stringa Base64 in immagine
	fn fB64StringConvertToImage str =
	(
		local ConvertClass = dotnetclass "system.convert"
		local ImageClass = dotnetclass "system.drawing.image"
		local byteArr = ConvertClass.FromBase64String str
		local memstream = dotnetobject "System.IO.MemoryStream" byteArr
		local DecodedImg = ImageClass.fromstream memstream
		memstream.close()
		-- immagine
		DecodedImg
	)
	local OkImg = fB64StringConvertToImage (fOkImg())
	local WrImg = fB64StringConvertToImage (fWrImg())
	---------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------
	-- Variabili con i nomi delle cartelle dentro UE per modificare l'esportazione in clipboard
	local target = "Content"
	local subst = "Game"
	---------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------
	local sdr = GetDir #export
	local docdr = GetDir #export
	local lbParam = #("Object At Origin  ","Pivot At Origin")
	
	label lbAsset "Asset Folder Path" align:#left offset:[-5,0]
	checkbox cbRemDir "Remember" checked:false align:#left offset:[220,-19]
	edittext etAssetPath width:300 offset:[-12,0]
	button btAssetFolder "..." width:25 height:17 align:#left offset:[292,-22]
	group "FBX Static Mesh Export"
	(
		label lbRem1 "- If there are UXC, select them with the object to be exported" align:#left
		groupBox grpSepSME width:322 height:7 offset:[-7,-2]
		radiobuttons rbParam labels:lbParam default:1 align:#left offset:[0,2]
		label lbFName "FBX File Name:" align:#left offset:[0,5]
		edittext etFName width:175 offset:[70,-20]
		button btnExport "Export" width:50 height:20 align:#left offset:[250,-24]
		button btnExpHelp "?" width:12 height:20 align:#left offset:[301,-25]
	)
	label lbUEAsset "UE Content Browser Folder Path" align:#left offset:[-5,20]
	checkbox cbUERemDir "Remember" checked:false align:#left offset:[220,-19]
	edittext etUEAssetPath width:300 offset:[-12,0]
	button btUEAssetFolder "..." width:25 height:17 align:#left offset:[292,-22]
	group "UE Scene Outliner Actors"
	(
		label lbRem2 "- Check the exact name and path in the Content Browser" align:#left offset:[0,5]
		label lbRem3 "- Do not select any of the UCX mesh" align:#left
		groupBox grpSepSOA width:322 height:7 offset:[-7,-2]
		checkbox cbWireCol "Override Wireframe color" checked:true align:#left offset:[0,5] 
		checkbox cbLmOver "Override Lightmap Size:" checked:false align:#left offset:[0,2] 
		dropdownlist ddlLmSize items:#("32","64","128","256","512","1024","2048") selection:5 width:55 height:8 align:#left offset:[138,-23] enabled:false
		label lbStmN "Static Mesh Name:" align:#left offset:[0,5]
		edittext etStaticMesh width:160 offset:[85,-20]
		button btnToClipB "Clipboard" width:50 height:20 align:#left offset:[250,-24]
		button btnClipHelp "?" width:12 height:20 align:#left offset:[301,-25]
	
	)
	dotNetControl pbPictureBox "System.Windows.Forms.PictureBox" Width:20 Height:20 align:#left offset:[-5,0]
	label lbWarning "Ready" align:#left offset:[25,-22]

	on btnExpHelp pressed do
	(
		local ExpHelpMes = "L'esportatore si occupa di esportare sia le Static Mesh singole\n"
			  ExpHelpMes += "sia quelle con i LODs, è comunque necessario selezionare anche\n"
			  ExpHelpMes += "gli oggetti UCX se esistono (non importa dove sia il loro Pivot).\n\n"
			  ExpHelpMes += "Non è possibile selezionare più mehses assieme (tranne gli UCX)\n\n"
			  ExpHelpMes += "Per usare il posizionamento tramite Clipboard NON è importante\n"
			  ExpHelpMes += "il path in cui le meshes vengono esportate in questa sezione.\n"
			  ExpHelpMes += "Il path che interessa è quello del Content Browser di UE\n"
			  ExpHelpMes += "\n"
		messagebox ExpHelpMes title:"HELP" beep:false
	)
	on btnClipHelp pressed do
	(
		local ClipHelpMes = "Per usare il sistema della Clipboard sono fondamentali solo 2 cose:\n"
			  ClipHelpMes += "- l'esatto nome della mesh visualizzata nel Content Browser (la mesh importata)\n"
			  ClipHelpMes += "- il path in cui la mesh è salvata NEL Content Browser\n\n"
			  ClipHelpMes += "Quando si usa il tasto cerca del path lo script si occupa di rinominare\n"
			  ClipHelpMes += "correttamente il path in maniera da renderlo compatibile con l'Outliner\n"
			  ClipHelpMes += "All' Otuliner interessa solo la parte terminale del path dopo ''Game''\n"
			  ClipHelpMes += "''Game'' è il nome sostitutivo di ''Content''\n\n"
			  ClipHelpMes += "Nel Content Browser esporto solo il gruppo LODs principale con i suoi UCX\n"
			  ClipHelpMes += "In Max posso copiare i gruppi con i LODs nella posizione desiderata senza UCX.\n"
			  ClipHelpMes += "Seleziono i LODs, premo Clipboard e copio le posizioni e rotazioni dei LODs\n"
			  ClipHelpMes += "E' fondamentale la posizione dei Pivot\n"
			  ClipHelpMes += "In UE seleziono l'Outliner e premo Ctrl+V.\n"
			  ClipHelpMes += "\n"
		messagebox ClipHelpMes title:"HELP" beep:false
	)

	--funzione che updata i materiali nella scena (metodo estremo ma funzionante)
	fn fForceUpdateMaterials =
	(
		saveNodes #() (GetDir #scene + "\\_Temp2Mat.max")
		deleteFile (GetDir #scene + "\\_Temp2Mat.max") 
	)
	-- funzione di esclusione automatica dalla selezione
	fn fObjFilter Obj =
	(
		local Found = true
		-- mi servono gli header dei gruppi ma non tutti gli helpers ------------------------------
		if (iskindof Obj Helper) and not (isGroupHead Obj) then Found = false 
		-----------------------------------------------------------------------------------------------
		-- superclass
		if (iskindof Obj Light) then Found = false
		if (iskindof Obj Camera) then Found = false
		if (iskindof Obj Shape) then Found = false
		if (iskindof Obj System) then Found = false
		if (iskindof Obj SpacewarpObject) then Found = false
		-- geometryclass
		if (iskindof Obj TargetObject) then Found = false
		if (iskindof Obj Biped_object) then Found = false
		if (iskindof Obj BoneObj) then Found = false
		if (iskindof Obj Spray) then Found = false 
		if (iskindof Obj SuperSpray) then Found = false
		if (iskindof Obj PCloud) then Found = false
		if (iskindof Obj PArray) then Found = false
		if (iskindof Obj Snow) then Found = false
		if (iskindof Obj Blizzard) then Found = false
		if (iskindof Obj PF_Source) then Found = false
		if (iskindof Obj ParticleGroup) then Found = false
		Found
	)
	-- funzione per il tipo di esportazione
	fn fExportToStaticMesh nod pth ucxArr =
	(
		clearSelection()
		case rbParam.state of
		(
			1:
			(
				local oldTrsf = nod.transform
				if (ucxArr.count > 0) then (for u in ucxArr do u.parent = nod)
				nod.rotation = (quat 0 0 0 1)
				nod.pos = [0.0,0.0,0.0]
				local selExport = #(nod)
				if (nod.children.count > 0) then join selExport nod.children
				-- L'esportatore ha problemi con il Level Of Detail + Parenti -------------------------
				if (ucxArr.count > 0) then (for u in ucxArr do u.parent = undefined) 
				----------------------------------------------------------------------------------------------
				select selExport
				exportFile pth selectedOnly:true using:fbxexporter
				---------------------------------------------------------------------------------------
				if (ucxArr.count > 0) then (for u in ucxArr do u.parent = nod)
				---------------------------------------------------------------------------------------
				nod.transform = oldTrsf
				if (ucxArr.count > 0) then (for u in ucxArr do u.parent = undefined)
			)
			2:
			(
				local selExport = #(nod)
				if (nod.children.count > 0) then join selExport nod.children
				if (ucxArr.count > 0) then join selExport ucxArr
				select selExport
				exportFile pth selectedOnly:true using:fbxexporter
			)
		)
		clearSelection()
	)
	-- funzione che converte il path in UE path
	fn fUEStripPath pth =
	(
		local newPth = ""
		local ckStr = false
		local StrArr = filterString pth "\\"
		for i = 1 to StrArr.count do 
		(
			if ckStr then newPth += ("/" + StrArr[i])
			if (not ckStr) and (StrArr[i] == "Content") then (newPth += "/Game"; ckStr = true)
		)
		--
		newPth
	)
	-- funzione di esportazione dei dati per UE tramite clipboard
	fn fExportToClipBoard ObjArr =
	(
		if (ObjArr.count > 0) then
		(
			SetClipBoardText ""
			local n = 0
			local StMeshName = etStaticMesh.text
			local relativePath = etUEAssetPath.text
			local ActorLabel = ""
			local clpStr = ""
			clpStr += ("Begin Map")
			clpStr += ("\n"+"   Begin Level")
			for o in ObjArr do
			(
				n += 1
				if (ObjArr.count == 1) then (ActorLabel = StMeshName) else (ActorLabel = (StMeshName+"_"+(n as string)))
				local PosX = o.transform.position.x as string
				local PosY = (o.transform.position.y * -1) as string
				local PosZ = o.transform.position.z as string
				local RotX = o.rotation.x_rotation as string
				local RotY = (o.rotation.y_rotation * -1) as string
				local RotZ = (o.rotation.z_rotation * -1) as string
				local SclX = o.transform.scale.x as string
				local SclY = o.transform.scale.y as string
				local SclZ = o.transform.scale.z as string
				local WCol = "B=" + ((o.wireColor.b as integer) as string) + ",G=" + ((o.wireColor.g as integer) as string) + ",R=" + ((o.wireColor.r as integer) as string)
				if (isGroupHead o) and (WCol == "B=0,G=0,R=0") then (WCol = "B=146,G=92,R=53")
				clpStr += ("\n"+"      Begin Actor Class=StaticMeshActor Name=" + ActorLabel  + " Archetype=StaticMeshActor'/Script/Engine.Default__StaticMeshActor'")
				clpStr += ("\n"+"         Begin Object Class=StaticMeshComponent Name=\"StaticMeshComponent0\" Archetype=StaticMeshComponent'Default__StaticMeshActor:StaticMeshComponent0'")
				clpStr += ("\n"+"         End Object")
				clpStr += ("\n"+"         Begin Object Name=\"StaticMeshComponent0\"")
				clpStr += ("\n"+"            StaticMesh=StaticMesh'" + relativePath + "/" + StMeshName + "." + StMeshName + "'")
				if cbWireCol.checked then clpStr += ("\n" + "            bOverrideWireframeColor=True")
				if cbWireCol.checked then clpStr += ("\n" + "            WireframeColorOverride=(" + WCol + ",A=255)")
				if cbLmOver.checked then clpStr += ("\n" + "            bOverrideLightMapRes=True")
				if cbLmOver.checked then clpStr += ("\n" + "            OverriddenLightMapRes=" + ddlLmSize.selected)
--				clpStr += ("\n"+"            StaticMeshDerivedDataKey=\"STATICMESH_\"")
				clpStr += ("\n"+"            RelativeLocation=(X=" + PosX + ",Y=" + PosY + ",Z=" + PosZ + ")")
				clpStr += ("\n"+"            RelativeRotation=(Pitch=" + RotY + ",Yaw=" + RotZ + ",Roll=" + RotX + ")")
				clpStr += ("\n"+"            RelativeScale3D=(X=" + SclX + ",Y=" + SclY + ",Z=" + SclZ + ")")
				clpStr += ("\n"+"         End Object")
				clpStr += ("\n"+"         StaticMeshComponent=StaticMeshComponent0")
				clpStr += ("\n"+"         RootComponent=StaticMeshComponent0")
				clpStr += ("\n"+"         ActorLabel=\"" + ActorLabel + "\"")
				clpStr += ("\n"+"      End Actor")
			)
			clpStr += ("\n"+"   End Level")
			clpStr += ("\n"+"Begin Surface")
			clpStr += ("\n"+"End Surface")
			clpStr += ("\n"+"End Map")
			SetClipBoardText clpStr
		)
	)
	-- Asset Path
	on btAssetFolder pressed do
	(
		local newAsPath = getSavePath initialDir:docdr caption:"Select Path"
		if (newAsPath != undefined) then 
		(
			if (pathConfig.isLegalPath newAsPath) then
			(
				if (not(pathConfig.isUncPath newAsPath)) then (newAsPath = pathConfig.convertPathToUnc newAsPath)
				etAssetPath.text = newAsPath + "\\"
				if cbRemDir.checked then
				(
					-- Salvataggio del path  -------------------------------------------------------------------------------------------
					setINISetting (sdr + "/UE_Export.ini") "UE Export Parameters" "Asset Path" etAssetPath.text
					----------------------------------------------------------------------------------------------------------------------
				)
			)
		)
	)
	on btUEAssetFolder pressed do
	(
		local newAsPath = getSavePath initialDir:docdr caption:"Select Path"
		if (newAsPath != undefined) then 
		(
			etUEAssetPath.text = fUEStripPath newAsPath
			if cbUERemDir.checked then
			(
				-- Salvataggio del path  -------------------------------------------------------------------------------------------
				setINISetting (sdr + "/UE_Export.ini") "UE Export Parameters" "UE Asset Path" etUEAssetPath.text
				----------------------------------------------------------------------------------------------------------------------
			)
		)
	)
	-- se si usa Remember dopo aver scelto il path
	on cbRemDir changed st do
	(
		if st and (etAssetPath.text.count > 0) then
		(
			local newPth = etAssetPath.text
			if (pathConfig.isLegalPath newPth) then
			(
				if (not(pathConfig.isUncPath newPth)) then (newPth = pathConfig.convertPathToUnc newPth)
				-- Salvataggio del path  -------------------------------------------------------------------------------------------
				setINISetting (sdr + "/UE_Export.ini") "UE Export Parameters" "Asset Path" newPth
				----------------------------------------------------------------------------------------------------------------------
			)
		)
	)
	on cbUERemDir changed st do
	(
		if st and (etUEAssetPath.text.count > 0) then
		(
			local newPth = etUEAssetPath.text
			-- Salvataggio del path  -------------------------------------------------------------------------------------------
			setINISetting (sdr + "/UE_Export.ini") "UE Export Parameters" "UE Asset Path" newPth
			----------------------------------------------------------------------------------------------------------------------
		)
	)
	-- apertura rollout
	on UEExport_roll open do
	(
		-- dotnet picturebox
		local mcolor = dotnetclass "System.drawing.color" 
		local MaxBackColor = colorMan.getColor #background
		local DNetMaxBackColor = mColor.FromArgb (MaxBackColor[1] * 255.0f) (MaxBackColor[2] * 255.0f) (MaxBackColor[3] * 255.0f)
		pbPictureBox.backcolor = DNetMaxBackColor
		pbPictureBox.Image = OkImg
		if ((getfiles (sdr + "/UE_Export.ini")).count != 0) then
		(
			-- Lettura parametri INI file --------------------------------------------------------------------------------------
			local Pth = (getINISetting (sdr + "/UE_Export.ini") "UE Export Parameters" "Asset Path")
			local UEPth = (getINISetting (sdr + "/UE_Export.ini") "UE Export Parameters" "UE Asset Path")
			------------------------------------------------------------------------------------------------------------------------
			if (doesFileExist Pth) and (getfileattribute Pth #directory) then etAssetPath.text = Pth
			if (UEPth != undefined) then etUEAssetPath.text = UEPth
		)
		-- Override della variabile docdr con il folder Documenti
		try (docdr = (dotNetClass "System.Environment").GetFolderPath (dotNetClass "System.Environment+specialFolder").MyDocuments) catch ()
	)
	-- attiva la dropdown list delle dimensioni delle lightmaps
	on cbLmOver changed ck do ddlLmSize.enabled = ck
	-- rinomina la Static Mesh se si rinomina il file FBX
	on etFName changed arg do etStaticMesh.text = etFName.text
	-- esportatore
	on btnExport pressed do
	(
		if (getSaveRequired()) then fForceUpdateMaterials()
		
		local selArr = #()
		local Pass = true
		
		-- Selezione vuota
		if (selection.count == 0) then (Pass = false; lbWarning.text = "Selection Empty !"; pbPictureBox.Image = WrImg)
		-- Array della selezione
		if Pass then (selArr = for o in selection where (fObjFilter o) collect o)
		-- Slezione multipla
		if Pass then
		(
			local multiSel = for o in selArr where (not isGroupHead o) and (not isGroupMember o) and (not (matchPattern o.name pattern:"UCX_*")) collect o
			if (multiSel.count > 1) then (Pass = false; lbWarning.text = "Select Only One Mesh !"; pbPictureBox.Image = WrImg)
		)
		-- Slezione multipla LODs
		if Pass then
		(
			local LODmultiSel = for o in selArr where (isGroupHead o) collect o
			if (LODmultiSel.count > 1) then (Pass = false; lbWarning.text = "Select Only One LODs Mesh !"; pbPictureBox.Image = WrImg)
		)
		-- Path
		if Pass and (etAssetPath.text.count == 0) then (Pass = false; lbWarning.text = "Asset Path Undefined !"; pbPictureBox.Image = WrImg)
		-- nome del file
		if Pass and (etFName.text.count == 0) then (Pass = false; lbWarning.text = "FBX File Name Undefined !"; pbPictureBox.Image = WrImg)

			
		if Pass and (selArr.count > 0) then
		(
			pbPictureBox.Image = OkImg
			lbWarning.text = "Ready"
			local pth = (etAssetPath.text + "\\" + etFName.text)
			
			local GrpHd = for hd in selArr where (isGroupHead hd) collect hd
			if (GrpHd.count == 1) then
			-- Esportazione LODs
			(
				local Hd = GrpHd[1]
				local chdArrName = for c in Hd.children collect c.name ; sort chdArrName
				local patt = "UCX_" + chdArrName[1] + "*"
				local ucxArr = for u in selArr where (matchPattern u.name pattern:patt) collect u
				fExportToStaticMesh Hd pth ucxArr
			)
			-- Esportazione oggetto singolo
			else
			(
				local objArr = for o in selArr where (not (matchPattern o.name pattern:"UCX_*")) collect o
				if (objArr.count == 1) then
				(
					local obj = objArr[1]
					local patt = "UCX_" + obj.name + "*"
					local ucxArr = for u in selArr where (matchPattern u.name pattern:patt) collect u
					fExportToStaticMesh obj pth ucxArr
				)
			)
		)
	)
	-- esportatore in clipboards
	on btnToClipB pressed do
	(
		local clpWrn = false
		if (selection.count == 0) then (clpWrn = true; lbWarning.text = "Selection Empty !"; pbPictureBox.Image = WrImg)
		if (not clpWrn) and (etStaticMesh.text.count == 0) then (clpWrn = true; lbWarning.text = "Static Mesh Name Empty !"; pbPictureBox.Image = WrImg)
		if (not clpWrn) and (etUEAssetPath.text.count == 0) then (clpWrn = true; lbWarning.text = "UE Asset Path Undefined !"; pbPictureBox.Image = WrImg)
		if (not clpWrn) then
		(
			pbPictureBox.Image = OkImg
			lbWarning.text = "Ready"
			local selArr = for o in selection where (fObjFilter o) collect o
			if (selArr.count > 0) then
			(
				local expArr = #()
				local objArr = for o in selArr where (not isGroupHead o) and (not isGroupMember o) and (not (matchPattern o.name pattern:"UCX_*")) collect o
				if (objArr.count > 0) then join expArr objArr
				local ghArr = for gh in selArr where (isGroupHead gh) collect gh
				if (ghArr.count > 0) then join expArr ghArr
				
				fExportToClipBoard expArr
			)
		)
	)
)
if (UEExportFloater != undefined) then CloseRolloutFloater UEExportFloater
UEExportFloater = NewRolloutFloater "UE Static Mesh Exporter 0.2" 345 422 1370 110
addRollout UEExport_roll UEExportFloater