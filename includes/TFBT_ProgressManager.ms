struct TFBT_ProgressManager
(
    private

		lastProgress=0,
	iteration=0,
	totalIterations=0,
	progressBarInst,
	labelInst,
	startTime,
	lastTime,
	lastIteration,
	eta,

	fn formatTime time =
	(
		time = int(time/1000)
		seconds = int(mod time 60)
		minutes = int(time / 60)

		if seconds < 10 then seconds = "0" + (seconds as string) else seconds = seconds as string
		if minutes < 10 then minutes = "0" + (minutes as string) else minutes = minutes as string

		minutes + ":" + seconds
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

    fn Init progressBarInstance labelInstance =
	(
		progressBarInst = progressBarInstance
		labelInst = labelInstance

		lastProgress = 0
		iteration = 0
		lastIteration = 0
		eta = "--"

		startTime = timeStamp()
		lastTime = startTime
	),

	fn Start total =
	(
		totalIterations = total

		if progressBarInst != undefined then
			progressBarInst.color = orange			
	),

	fn UpdateProgress =
	(
		if progressBarInst == undefined and labelInst == undefined then return true

		local currTime = timestamp()

		iteration = iteration + 1
		progress = iteration * 100 / totalIterations

		if progress - lastProgress >= 1 then 
		(
			if progressBarInst != undefined then
				progressBarInst.value = progress				

			if labelInst != undefined then
				labelInst.text = (progress as string) + "% " + formatTime(currTime - startTime) + " ETA:" + eta;

			lastProgress = progress	
			--windows.processPostedMessages()
		)

		if ((int)(currTime/1000)) != ((int)(lastTime/1000)) then
		(
			local estimatedTime = (currTime - lastTime) / (iteration - lastIteration) * (totalIterations - iteration)
			eta = formatTime(estimatedTime)

			--format "currTime %, lastTime %, iteration: %, lastIteration %, eta: %\n" currTime lastTime iteration lastIteration eta
			
			if labelInst != undefined then
				labelInst.text = (progress as string) + "% " + formatTime(currTime - startTime) + " ETA:" + eta;

			lastTime = currTime
			lastIteration = iteration
		)

		true
	),

	fn EndProgress =
	(
		if progressBarInst != undefined then
		(
			progressBarInst.value = 100
			progressBarInst.color = green
		)

		if labelInst != undefined then
			labelInst.text = "Complete!"
	),

    initalized = Constructor() -- This will be executed when this struct is created the first time.	   
)