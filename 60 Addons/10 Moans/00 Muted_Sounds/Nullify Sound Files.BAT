@Echo Off
Echo Off

if "%1%"=="" Set Fle=WAV
if Not "%1"=="" Set Fle=%1

ClS
Title Ulfbertho's WAV Zero'er   [Working...]

    Echo.
    Dir "%CD%\*.%Fle%" /A-D /B /ON /S>"%CD%\WaveFiles.LST"

    SetLocal EnableDelayedExpansion
    (For /F "UseBackQTokens=*" %%a in ("%CD%\WaveFiles.LST") Do (
        Set "input=%%a"
        Echo(  Zero'ing !input!...
        Echo.>"!input!"
    ))
    EndLocal

Del /F "%CD%\WaveFiles.LST">NUL
Echo.
Echo   Done.
Echo.
Echo.
Title Ulfbertho's WAV Zero'er   [Done]
Pause