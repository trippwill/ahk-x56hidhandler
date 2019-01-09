class CX56ProfileShell
{
    HWND
    {
        get {
            return A_ScriptHwnd
        }
    }

    __New()
    {
        this.SetIcon(Icon.GAMEPAD)
    }

    SetIcon(pIcon)
    {
        Menu, Tray, Icon, % pIcon.Path, % pIcon.Idx
    }
}

class Icon {
    static _IMAGERES := "imageres.dll"
    static _DDORES   := "ddores.dll"
    static _SHELL32  := "shell32.dll"

    static SUN              := {Path: Icon._IMAGERES, Idx: 332}
    static ERROR            := {Path: Icon._IMAGERES, Idx: 94}
    static GAMEPAD          := {Path: Icon._DDORES, Idx: 107}
    static MOUSE            := {Path: Icon._DDORES,   Idx: 109}
    static FOLDER           := {Path: Icon._SHELL32,  Idx: 310}
    static OPEN_FOLDER      := {Path: Icon._SHELL32, Idx: 311}
    static COMPUTER_SAYS_NO := {Path: Icon._SHELL32, Idx: 312}
}