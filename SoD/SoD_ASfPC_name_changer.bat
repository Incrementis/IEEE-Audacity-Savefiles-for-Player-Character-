REM Never Forget: Comments can "lie", but code not so much ;P
REM ---------------------------------------------------------
REM Check https://ss64.com for more information
REM ------------------------
REM Disables command echoing
REM ------------------------
@echo off
REM --------------------------------------------------------------------------
REM Disables the "!" as keyword, so it can be used as character for file names
REM --------------------------------------------------------------------------
Setlocal DISABLEDELAYEDEXPANSION
REM -----------------------------------------
REM Defines the base name for the sound files
REM -----------------------------------------
Set name=!_DEMO
REM --------------------------------------------------------------
REM Defines the source and target directories (Don't change these)
REM --------------------------------------------------------------
Set source_path="%~dp0\raw"
Set target_path="%~dp0\renamed" 

Setlocal ENABLEDELAYEDEXPANSION

REM ------------------------
REM INIT Soundset File Names
REM ------------------------
REM Counter for loop
Set count=1
REM Creates and fill the array with non-numeric values concatenated with the base name 
For %%G in (a 8 9 g_ h_ b c d e f g h 0 k_ l_ i j k 0_ 1_ 2_ 3_ s t u v l m n o p q r w z 1 2 3 4 5 6 7) Do (

	Set full_names[!count!]=!name!%%~G
	Set /a count+=1
)

REM ---------------------------------------------------
REM Copies .wav files from source to target directories
REM ---------------------------------------------------
xcopy %source_path% %target_path%

REM ----------------------------------------
REM Changes the path to the target directory
REM ----------------------------------------
cd %target_path%

REM ---------------------------
REM Renames all copied wav files
REM ---------------------------
REM https://ss64.com/nt/ren.html
Set /a idx_counter=1
REM Reads all WAV files in folder %target_path% and renames them accordingly.
For %%G in (*.wav) Do ( 
	REM Access the array using a nested loop, since direct access with "!full_names[%idx_counter%]!" doesn't work.
	For /L %%A in (!idx_counter!,1,!idx_counter!) Do (
		REN "%%G" "!full_names[%%A]!.wav")
		
	Set /a idx_counter+=1
)

PAUSE