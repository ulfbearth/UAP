@Echo Off
Echo Off

if "%1%"=="" Set Fle=WAV
if Not "%1"=="" Set Fle=%1
if Exist "%CD%\%Fle%.DMY" Set Dmy=%Fle%.DMY

:Mnu
	Title Ulfbertho's %Fle% Zero'er  [Menu]
	ClS
	Echo.
	Echo   [1;33m[34mUlfbertho's %Fle% Zero'er[0m
	Echo   [1;33m[34m=======================[0m
	Echo.
	Echo   [1;33m[31mNOTE:[0m
	Echo   [1;33m[31mThis program affects all[0m [1;33m[29m%Fle%[0m [1;33m[31mfiles in[0m
	Echo   [1;33m[36m%CD%\[0m
	Echo   [1;33m[31mand all of its subfolders.[0m
	Echo.
	Echo   [1;33m[32mPlease choose what to do with all[0m [1;33m[29m%Fle%[0m [1;33m[32mfiles by pressing[0m
	Echo   [1;33m[32mthe number shown inbetween the square brackets and then[0m
	Echo   [1;33m[32mpress Return/Enter to confirm[0m
	Echo.
	Echo   [[1;33m[32m1[0m] Empty them
	if "%Dmy%"=="" Echo   [ ] [1;33m[31mNOT AVAiLABLE. %Fle%.DMY NOT FOUND.[0m
	if Not "%Dmy%"=="" Echo   [[1;33m[32m2[0m] Replace with %Dmy%
	Echo.
	Echo   [[1;33m[32mX[0m] Exit program
	Echo.
	Echo.
	Set Chc=
	Set /P Chc=[1;33m[30m  [0mSelection: 
	if Not "%Chc%"=="" Set Chc=%Chc:~0,1%
	if "%Chc%"=="1" GoTo Zre
	if "%Chc%"=="2" if Not "%Dmy%"=="" GoTo Rpl
	if "%Chc%"=="x" GoTo End
	if "%Chc%"=="X" GoTo End
	GoTo Mnu
:Zre
	Title Ulfbertho's %Fle% Zero'er   [Working...]
	ClS
    Echo.
	Echo   [1;33m[34mUlfbertho's %Fle% Zero'er - Working...[0m
	Echo.
    Dir "%CD%\*.%Fle%" /A-D /B /ON /S>"%CD%\%Fle%Files.LST"
    SetLocal EnableDelayedExpansion
    (For /F "UseBackQTokens=*" %%a in ("%CD%\%Fle%Files.LST") Do (
        Set "input=%%a"
        Echo(  [1;33m[31mZero'ing !input!...[0m
        Echo.>"!input!"
    ))
    EndLocal
	Del /F "%CD%\%Fle%Files.LST">NUL
	Echo.
	Echo   [1;33m[32mDone.[0m
	GoTo Key_End
:Rpl
	Title Ulfbertho's %Fle% Zero'er   [Working...]
	ClS
    Echo.
	Echo   [1;33m[34mUlfbertho's %Fle% Replacer - Working...[0m
	Echo.
    Dir "%CD%\*.%Fle%" /A-D /B /ON /S>"%CD%\%Fle%Files.LST"
    SetLocal EnableDelayedExpansion
    (For /F "UseBackQTokens=*" %%a in ("%CD%\%Fle%Files.LST") Do (
        Set "input=%%a"
        Echo(  [1;33m[31mReplacing !input!...[0m
        Del /F "!input!"
		if Exist "!input!" GoTo Del_Err
		Copy /V "%CD%\%Dmy%" "!input!">NUL
		if Not Exist "!input!" GoTo Cpy_Err
    ))
    EndLocal
	Del /F "%CD%\%Fle%Files.LST">NUL
	Echo.
	Echo   [1;33m[32mDone.[0m
	GoTo Key_End
:Del_Err
	CLS
	Echo.
	Echo   [1;33m[31mERROR[0m
	Echo.
	Echo   [1;33m[31mCould not delete
	Echo   [1;33m[36m!input![0m
	Echo   [1;33m[31mbefore replacing.[0m
	GoTo Key_End
:Del_Err
	CLS
	Echo.
	Echo   [1;33m[31mERROR[0m
	Echo.
	Echo   [1;33m[31mCould not copy[0m [1;33m[29m%Dmy%[0m [1;33m[31mto[0m
	Echo   [1;33m[36m!input![0m
	GoTo Key_End
:Key_End
	Echo.
	Echo.
	Echo   Press any key to exit this program.
	Title Ulfbertho's %Fle% Zero'er   [Done]
	Pause>NUL
:End
	ClS
	Exit