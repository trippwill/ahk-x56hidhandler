#Persistent
#SingleInstance, force

class Ping
{
    static PM_ADDRCVR_REG := "84d4bf80-b68a-483e-8896-f0fc0a92649b"
    static PM_WELCOME := 0x8000

    __New()
    {
        msg_id := DllCall("RegisterWindowMessage", Str, Ping.PM_ADDRCVR_REG)
        OutputDebug % A_ThisFunc " " Format("msg_id:0x{1:04X}", msg_id) " LastError: " A_LastError " ErrorLevel: " ErrorLevel
        OnMessage(msg_id, this.OnPM_ADDRCVR.Bind(this))
    }

    OnPM_ADDRCVR(wParam, lParam)
    {
        OutputDebug % A_ThisFunc " " Format("wParam: 0x{1:x} lParam: 0x{2:x}", wParam, lParam)
        DetectHiddenWindows, On
        Message := "X56 SERVER"
        SendMessage, Ping.PM_WELCOME, &Message,,, ahk_id %wParam%
        OutputDebug % A_ThisFunc " ErrorLevel: " ErrorLevel
    }
}

p := new Ping