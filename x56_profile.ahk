NIRCMD := "nircmd"

if (DEBUG)
    NIRCMD := "nircmd showerror"

SetAppVolume(sApp, nVol) {
    global NIRCMD
    if WinExist("ahk_exe ".sApp)
	    Run, %NIRCMD% setappvolume %sApp% %nVol%
}

class Throttle extends ActiveWinExeProfileHandler
{
    __New() {
        this.DefaultProfile := new Default
        this.ExeProfiles["starcitizen.exe"] := new StarCitizen
        this.ExeProfiles["notepad.exe"] := new Notepad
    }

    __Call(name, p1, p2) {
        OutputDebug % A_ThisFunc " name: " name " params: " p1 " " p2
    }

    RTY3(idx) {
        SetAppVolume("spotify.exe", idx/255)
    }
}

class StarCitizen extends ModeSwitchHandler
{
    __New()
    {
        this.Modes[3] := new StarCitizen.Mode3
    }

    class Mode3
    {
        SW6(pressed) {
            if (pressed) { ;Acquire missle lock
                SendInput {-}
            }
            else { ;Fire missle
                SendInput {'}
            }
            return
        }
    }
}

class Notepad extends ModelessSwitchHandler
{
    RTY4(idx) {
        SendInput {Text}%idx%
        SendInput {Space}
    }

    SW6(pressed) {
        if pressed {
            SendInput {p 3}
            SendInput {Space}
        }
    }
}

class Default extends ModelessSwitchHandler
{
    TGL4_D(pressed) {
        static num_presses := 0
        
        if (pressed) {
            if (num_presses) > 0 {
                num_presses += 1
                return
            }

            num_presses := 1
            SetTimer, TGL4_D_TICK, -400
            return
        }

        return

        TGL4_D_TICK:
            if (num_presses = 1)
                SendInput {Media_Next}
            else if (num_presses = 2)
                SendInput {Media_Play_Pause}
            else if (num_presses > 2)
                SendInput {Media_Prev}

            num_presses := 0
        RETURN
    }

    SCROL_F(pressed) {
        OutputDebug, %A_ThisFunc% %pressed%
    }

    SCROL_B(pressed) {
        OutputDebug, %A_ThisFunc% %pressed%
    }

    RTY4(idx) {
        SetAppVolume("steam.exe", idx/255)
    }

    SW1(pressed) {
        OutputDebug % A_ThisFunc " pressed: " pressed 
        if (pressed)
            OutputDebug, SW1 Rising Edge
        else
            OutputDebug, SW1 Falling Edge
    }

}