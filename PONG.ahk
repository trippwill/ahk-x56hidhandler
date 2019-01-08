#Persistent
#SingleInstance, force

class Pong
{
    static PM_ADDRCVR_REG := "84d4bf80-b68a-483e-8896-f0fc0a92649b"
    static PM_WELCOME := 0x8000

    __New()
    {
        msg_id := DllCall("RegisterWindowMessage", Str, Pong.PM_ADDRCVR_REG)
        OutputDebug % A_ThisFunc " " Format("msg_id:0x{1:04X}", msg_id) " LastError: " A_LastError " ErrorLevel: " ErrorLevel

        OnMessage(Pong.PM_WELCOME, this.OnPM_WELCOME.Bind(this))
        PostMessage, msg_id, A_ScriptHwnd,,, ahk_id 0xFFFF
    }

    OnPM_WELCOME(wParam)
    {
        OutputDebug % A_ThisFunc " wParam: " wParam
        m := StrGet(&wParam)
        OutputDebug % A_ThisFunc " m: " m
        return 0xBAD0
    }
}

p := new Pong

32768
49151