@echo off
REM Never Forget: Comments can "lie", but code not so much ;P
REM ---------------------------
REM Disables the "!" as keyword
REM ---------------------------
REM https://stackoverflow.com/questions/3288552/how-can-i-escape-an-exclamation-mark-in-cmd-scripts
setlocal DISABLEDELAYEDEXPANSION

REM ------------------------
REM INIT Soundset File Names
REM ------------------------
Set soundsetName[0]=!_DEMA
Set soundsetName[1]=!_DEMB
REM --------------
REM INIT Languages
REM --------------
REM (en_US = English, de_DE = German)
Set languages[0]=en_US
Set languages[1]=de_DE
REM --------------------------
REM INIT Soundset Custom Names
REM --------------------------
Set en_US[0]=!_Demo(Complete):Female Robot
Set en_US[1]=!_Demo(Incomplete):Female Robot
Set de_DE[0]=!_Demo(Vollständig):Weiblich Roboter
Set de_DE[1]=!_Demo(Unvollständig):Weiblich Roboter
REM -----------------
REM INIT Folder Paths
REM -----------------
REM https://ss64.com/nt/syntax-args.html
Set MOD_FOLDER="%~dp0"
Set VOX_FOLDER="%~dp0vox\"
REM -------------
REM INIT Counters
REM -------------
Set nameNumbers=0
Set slotNumbers=0
REM -----------------------
REM INIT List for Positions
REM -----------------------
Set positionsList[0]=9
Set positionsList[1]=10
Set positionsList[2]=11
Set positionsList[3]=12
Set positionsList[4]=13
Set positionsList[5]=6
Set positionsList[6]=7
Set positionsList[7]=8 
Set positionsList[8]=20
Set positionsList[9]=26
Set positionsList[10]=27
Set positionsList[11]=28
Set positionsList[12]=29
Set positionsList[13]=30
Set positionsList[14]=31
Set positionsList[15]=32 
Set positionsList[16]=33
Set positionsList[17]=34
Set positionsList[18]=35
Set positionsList[19]=36
Set positionsList[20]=37
Set positionsList[21]=38
Set positionsList[22]=79
Set positionsList[23]=80
Set positionsList[24]=81
Set positionsList[25]=82
Set positionsList[26]=18
Set positionsList[27]=19
Set positionsList[28]=21
Set positionsList[29]=22
Set positionsList[30]=23
Set positionsList[31]=24
Set positionsList[32]=25
Set positionsList[33]=53 
REM --------------
REM INIT LAM Names
REM --------------
Set texts=!_Texts
Set voxNames=!_VoxNames
Set voxSelectNames=!_VoxSelectNames
Set sounds=!_Sounds
Set positions=!_Positions


REM ---------------------
REM Main Loop (Languages)
REM ---------------------
REM https://stackoverflow.com/questions/18462169/how-to-loop-through-array-in-batch
for /F "tokens=2 delims==" %%l in ('Set languages[') do ( 
	echo -----------------------------
	echo Preparing files for language: %%l
	echo -----------------------------
	REM https://ss64.com/nt/delayedexpansion.html
	Setlocal ENABLEDELAYEDEXPANSION
	
	REM ----------------------------
	REM Count Custome Names for Loop
	REM ----------------------------
	Set countedCustomNames=0
	for /F "tokens=2 delims==" %%t in ('Set %%l[') do ( 
		
		Set /a countedCustomNames+=1
	)
	Set /a countedCustomNames-=1
	
	REM -------------------------------
	REM Change path to read sound files
	REM -------------------------------
	REM https://ss64.com/nt/dir.html; bare(/b) file sorted by name(/o:n)
	cd "%VOX_FOLDER%\%%l"
	set countedFiles=0
	Set index=0
	for /f "tokens=*" %%s in ('dir /b /o:n "*.wav"') do (
		REM "^" allows to get files with "!" in it.
		Set soundsetFiles[!index!]="^%%~s"
		Set /a index+=1
		Set /a countedFiles+=1
	)
	Set soundsetFiles
	Set /a countedFiles-=1

	REM -----------------------------------------------------------
	REM Change path to create init-file and fill it with WeiDU code
	REM -----------------------------------------------------------
	cd "%MOD_FOLDER%\%%l"
	Copy NUL "InitVoxArrays.tpa"
	REM --------------------------
	REM INITIALIZE DYN ARRAY TEXTS
	REM --------------------------
	Set index=0
	>>InitVoxArrays.tpa echo // ---INITIALIZE DYN ARRAY TEXTS
	for /L %%i in (0,1,!countedFiles!) do ( 
	
		>>InitVoxArrays.tpa echo OUTER_SPRINT ~Texts!index!~ ~TODO~ //!soundsetFiles[%%i]!
		Set /a index+=1
		
	)
	>>InitVoxArrays.tpa echo LAM ~!texts!~
	REM --------------------------
	REM INITIALIZE DYN ARRAY NAMES
	REM --------------------------
	Set index=0
	>>InitVoxArrays.tpa echo // ---INITIALIZE DYN ARRAY NAMES
	for /L %%n in (0,1,!countedCustomNames!) do ( 
		
		Set name=!soundsetName[%%n]!

		>>InitVoxArrays.tpa echo OUTER_SPRINT ~VoxNames!index!~ ~!name!~
		Set /a index+=1
	)
	>>InitVoxArrays.tpa echo LAM ~!voxNames!~
	REM -------------------------------------
	REM INITIALIZE DYN ARRAY SELECTABLE NAMES
	REM -------------------------------------
	Set index=0
	Set array=%%l
	>>InitVoxArrays.tpa echo // ---INITIALIZE DYN ARRAY SELECTABLE NAMES
	for /L %%t in (0,1,!countedCustomNames!) do (  
	
		Set sname=!%%l[%%t]!
		
		>>InitVoxArrays.tpa echo OUTER_SPRINT ~VoxSelectNames!index!~ ~!sname!~
		Set /a index+=1		
	)
	>>InitVoxArrays.tpa echo LAM ~!voxSelectNames!~	
	REM ---------------------------
	REM INITIALIZE DYN ARRAY SOUNDS
	REM ---------------------------
	Set index=0
	>>InitVoxArrays.tpa echo // ---INITIALIZE DYN ARRAY SOUNDS
	for /L %%k in (0,1,!countedFiles!) do ( 

		Set ssname=!soundsetFiles[%%k]!
		
		>>InitVoxArrays.tpa echo OUTER_SPRINT ~Sounds!index!~ ~!ssname:~1,-5!~
		Set /a index+=1
	)
	>>InitVoxArrays.tpa echo LAM ~!sounds!~
	REM ------------------------------
	REM INITIALIZE DYN ARRAY POSITIONS
	REM ------------------------------
	Set index=0
	>>InitVoxArrays.tpa echo // ---INITIALIZE DYN ARRAY POSITIONS
	for /L %%j in (0,1,!countedFiles!) do ( 

		Set sfname=!soundsetFiles[%%j]!
		
		Set /a count=0
		for %%g IN (a 8 9 g_ h_ b c d e f g h 0 k_ l_ i j k 0_ 1_ 2_ 3_ s t u v l m n o p q r w) DO (
			
			if /i "%%g"=="!sfname:~-6,-5!" (
				
				REM Accessing the array with loop, because "!full_names[%idx_counter%]!" doesn't work here.
				For /L %%u in (!count!,1,!count!) Do (
					>>InitVoxArrays.tpa echo OUTER_SET ~Positions!index!~ = !positionsList[%%u]!
				)
				
			) else if /i "%%g"=="!sfname:~-7,-5!" (
				
				REM Accessing the array with loop, because "!full_names[%idx_counter%]!" doesn't work here.
				For /L %%u in (!count!,1,!count!) Do (
					>>InitVoxArrays.tpa echo OUTER_SET ~Positions!index!~ = !positionsList[%%u]!
				)
			)
			Set /a count+=1
		)
		
		Set /a index+=1
	)
	>>InitVoxArrays.tpa echo LAM ~!positions!~
	
	
	REM -----------------------------------
	REM Counts the number of soundset names
	REM -----------------------------------
	for /F "tokens=2 delims==" %%n in ('Set soundsetName[') do ( 
		Set /a nameNumbers+=1
	)
	REM -----------------------------------
	REM Counts the number of soundset files
	REM -----------------------------------
	for /F "tokens=2 delims==" %%n in ('Set soundsetFiles[') do ( 
		Set /a slotNumbers+=1 
	)	
	REM --------------------------------------------
	REM Create init-file and fill it with WeiDU code
	REM --------------------------------------------
	Copy NUL "InitAllSlotNumbers.tpa"
	REM ---------------------------
	REM INITIALIZE ALL SLOT-NUMBERS
	REM ---------------------------
	>>InitAllSlotNumbers.tpa echo // ---INITIALIZE ALL SLOT-NUMBERS	
	>>InitAllSlotNumbers.tpa echo OUTER_SET slotNumbers = !slotNumbers!
	>>InitAllSlotNumbers.tpa echo OUTER_SET nameNumbers = !nameNumbers!
	

	REM ----------------------------
	REM Redistribute all sound files
	REM ----------------------------
	cd "%VOX_FOLDER%\%%l"
	REM https://ss64.com/nt/move.html; https://ss64.com/nt/if.html
	REM https://stackoverflow.com/questions/26391925/in-a-batch-file-how-do-you-verify-part-of-a-filename-matches-a-given-string
	for /F "tokens=2 delims==" %%w in ('Set soundsetFiles[') do ( 
				
		rem echo "^%%~w"
		set file="^%%~w"
		set flag=^%%~w
		rem echo !file:~-5!
		
		REM Checks the last 5 characters found in file. 
		REM Sound file names with "_" as postfix will be moved in wav folder, else in sound folder. 
		if /i "!flag:~-5!"=="_.wav" (
			move /Y ".\!file!" ".\wav\"
		) else (
			move /Y ".\!file!" ".\sound\"
		)
		
	)
		
	REM Deletes every content of variables within this loop iteration
	endlocal
)

PAUSE