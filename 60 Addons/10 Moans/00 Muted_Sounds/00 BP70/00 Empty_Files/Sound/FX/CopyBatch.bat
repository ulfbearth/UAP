for /r "C:\Users\Ulfberto\Documents\GitHub\UAP\60 Addons\10 Moans\00 Muted_Sounds\00 BP70\00 Empty_Files\Sound\FX\AnimationsByBP70" %%f in (*.wav) do (
	Echo %%f
	copy "_mute.wav" "%%f"
)