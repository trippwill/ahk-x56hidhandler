#Warn ClassOverwrite
#NoEnv
#KeyHistory 0
ListLines off
SendMode Input
SetWorkingDir %A_ScriptDir%

#include lib/ahk-argybargy/CArgyBargyClient.ahk
#include lib/ahk-utils/BYTEUTILS.ahk
#include X56_MSG.ahk

client := new CArgyBargyClient(X56_SERVER_ID)

GetX56MsgParams(ByRef curr, ByRef mode, wParam, lParam)
{
    curr := BYTE(wParam, 0)
    mode := BYTE(lParam, 0)
}

msg_names := ["X56T_SW1", "X56T_SW2", "X56T_SW3", "X56T_SW4"]

loop % msg_names.Length() {
    mn := msg_names[A_Index]
    rn := OnMessage(%mn%, mn)
    OutputDebug % "OnMessage Loop Index: " A_Index " mn: " mn " rn: " rn " deref: " %mn%
}

client.AdviseStatusChanged(Func("OnStatusChanged"))
client.Attach()

OnStatusChanged(status)
{
    OutputDebug % A_ThisFunc " Status: " status
}

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

X56T_TG1_U(wParam, lParam)
{
    res := GetX56MsgParams(curr, mode, wParam, lParam)
    OutputDebug % A_ThisFunc " " Format("wParam: 0x{1:016x} lParam: 0x{2:016x} curr: 0x{3:02x} mode: 0x{4:02x}", wParam, lParam, curr, mode) 
}
