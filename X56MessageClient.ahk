#Warn ClassOverwrite
#NoEnv
#KeyHistory 0
ListLines off
SendMode Input
SetWorkingDir %A_ScriptDir%

#include lib/ahk-argybargy/CArgyBargyIniClient.ahk
#include lib/ahk-utils/BYTEUTILS.ahk

NIRCMD := "nircmd"

if (DEBUG)
    NIRCMD := "nircmd showerror"

SetAppVolume(sApp, nVol) {
    global NIRCMD
    if WinExist("ahk_exe ".sApp)
	    Run, %NIRCMD% setappvolume %sApp% %nVol%
}

client := new CArgyBargyIniClient(A_ScriptDir . "\X56.ini", new X56ClientHandler)

GetX56MsgParams(ByRef curr, ByRef mode, wParam, lParam)
{
    curr := BYTE(wParam, 0)
    mode := BYTE(lParam, 0)
    return true
}

client.AdviseStatusChanged(Func("OnStatusChanged"))
client.Attach()

OnStatusChanged(status)
{
    OutputDebug % A_ThisFunc " Status: " status
}

class X56ClientHandler
{
    X56T_TH1(wParam, lParam)
    {
        res := GetX56MsgParams(curr, mode, wParam, lParam)
        OutputDebug % A_ThisFunc " " Format("wParam: 0x{1:016x} lParam: 0x{2:016x} curr: 0x{3:02x} mode: 0x{4:02x}", wParam, lParam, curr, mode)
    }

    X56T_TH2(wParam, lParam)
    {
        res := GetX56MsgParams(curr, mode, wParam, lParam)
        OutputDebug % A_ThisFunc " " Format("wParam: 0x{1:016x} lParam: 0x{2:016x} curr: 0x{3:02x} mode: 0x{4:02x}", wParam, lParam, curr, mode)
    }

    X56T_SW1(wParam, lParam)
    {
        res := GetX56MsgParams(curr, mode, wParam, lParam)
        OutputDebug % A_ThisFunc " " Format("wParam: 0x{1:016x} lParam: 0x{2:016x} curr: 0x{3:02x} mode: 0x{4:02x}", wParam, lParam, curr, mode)
    }

    X56T_SW2(wParam, lParam)
    {
        res := GetX56MsgParams(curr, mode, wParam, lParam)
        OutputDebug % A_ThisFunc " " Format("wParam: 0x{1:016x} lParam: 0x{2:016x} curr: 0x{3:02x} mode: 0x{4:02x}", wParam, lParam, curr, mode)
    }

    X56T_SW3(wParam, lParam)
    {
        res := GetX56MsgParams(curr, mode, wParam, lParam)
        OutputDebug % A_ThisFunc " " Format("wParam: 0x{1:016x} lParam: 0x{2:016x} curr: 0x{3:02x} mode: 0x{4:02x}", wParam, lParam, curr, mode)
    }

    X56T_SW4(wParam, lParam)
    {
        res := GetX56MsgParams(curr, mode, wParam, lParam)
        OutputDebug % A_ThisFunc " " Format("wParam: 0x{1:016x} lParam: 0x{2:016x} curr: 0x{3:02x} mode: 0x{4:02x}", wParam, lParam, curr, mode)
    }

    X56T_SW5(wParam, lParam)
    {
        res := GetX56MsgParams(curr, mode, wParam, lParam)
        OutputDebug % A_ThisFunc " " Format("wParam: 0x{1:016x} lParam: 0x{2:016x} curr: 0x{3:02x} mode: 0x{4:02x}", wParam, lParam, curr, mode)
    }

    X56T_SW6(wParam, lParam)
    {
        res := GetX56MsgParams(curr, mode, wParam, lParam)
        OutputDebug % A_ThisFunc " " Format("wParam: 0x{1:016x} lParam: 0x{2:016x} curr: 0x{3:02x} mode: 0x{4:02x}", wParam, lParam, curr, mode)
    }

    X56T_TG1U(wParam, lParam)
    {
        res := GetX56MsgParams(pressed, mode, wParam, lParam)
        OutputDebug % A_ThisFunc " " Format("wParam: 0x{1:016x} lParam: 0x{2:016x} curr: 0x{3:02x} mode: 0x{4:02x}", wParam, lParam, curr, mode)

        Critical

        static num_presses := 0
        
        if (pressed) {
            if (num_presses) > 0 {
                num_presses += 1
                return
            }

            num_presses := 1
            SetTimer, T_TG1U_TICK, -500
            return
        }

        return

        T_TG1U_TICK:
            if (num_presses = 1)
                SendInput {Media_Next}
            else if (num_presses = 2)
                SendInput {Media_Play_Pause}
            else if (num_presses > 2)
                SendInput {Media_Prev}

            num_presses := 0
        RETURN
    }

    X56T_RTY3(wParam, lParam)
    {
        OutputDebug % A_ThisFunc " " Format("wParam: 0x{1:016x} lParam: 0x{2:016x} curr: 0x{3:02x} mode: 0x{4:02x}", wParam, lParam, curr, mode)
        SetAppVolume("spotify.exe", wParam/255)
    }
}
