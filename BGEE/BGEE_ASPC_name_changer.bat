@echo off 
REM Never Forget: Comments can "lie", but code not so much ;P
REM ---------------------------
REM Never Forget, comments can "lie", but code not so much ;P 
REM Ensures that the commands are not shown when the code is executed.


REM TODO
REM Never Forget: Comments can "lie", but code not so much ;P
REM https://stackoverflow.com/questions/1645843/resolve-absolute-path-from-relative-path-and-or-file-name
REM echo %%~dp0 is "%~dp0"
REM echo %%0 is "%0"
REM echo %%~dpnx0 is "%~dpnx0"
REM echo %%~f1 is "%~f1"
REM echo %%~dp0%%~1 is "%~dp0%~1"

REM Output is
REM %~dp0 is "C:\temp\"
REM %0 is "\temp\example.bat"
REM %~dpnx0 is "C:\temp\example.bat"
REM %~f1 is "C:\Users\windows"
REM %~dp0%~1 is "C:\temp\..\windows"
REM batch-relative %~f1 is "C:\Windows"

REM Used to disable the "!" as keyword, so it can be used as character for file names.
REM https://stackoverflow.com/questions/3288552/how-can-i-escape-an-exclamation-mark-in-cmd-scripts
setlocal DISABLEDELAYEDEXPANSION

REM The values of the variables are changable. The rest of the code shouldn`t be changed.
set name=!_DEMA
set source_path="%~dp0\raw"
set target_path="%~dp0\renamed" 

REM Will buffer variable changes within a line and thus will show the changed value of the same variable
REM Check https://ss64.com for more information
Setlocal ENABLEDELAYEDEXPANSION

REM -------1.----------
REM Counter for loop
Set count=1

REM Creating and filling an array of none numeric values and concatenating with other string variables  
FOR %%G IN (a 8 9 g_ h_ b c d e f g h 0 k_ l_ i j k 0_ 1_ 2_ 3_ s t u v l m n o p q r w) DO (
	REM REN Mecho %%G
	Set full_names[!count!]=!name!%%~G
	Set /a count+=1
)

REM Number of elements in array
REM Set /a count-=1

REM Accessing the array and printing elements to terminal
REM Echo Now enumerating the array:
REM For /L %%A in (1,1,%count%) Do (
	REM echo Array item full_names[%%A] is !full_names[%%A]!
REM )

REM -------2.----------
REM Copy all wav files from one folder and move it to another
xcopy %source_path% %target_path%

REM -------3.---------- 
REM Change path
cd %target_path%

REM -------4.---------- 
REM Rename all copied wav files
set /a idx_counter=1

REM Changing file names none-recursevly (doesn`t work properly renaming the first file)
For %%G in (*.wav) Do ( 
	REM Accessing the array with loop, because "!full_names[%idx_counter%]!" doesn't work here.
	For /L %%A in (!idx_counter!,1,!idx_counter!) Do (
		REN "%%G" "!full_names[%%A]!.wav")
		
	set /a idx_counter+=1
)

REM Fixes the failed first renaming.
REM REN ".wav" "!full_names[1]!.wav"



PAUSE