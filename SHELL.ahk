class CX56ProfileShell
{
    HWND
    {
        get {
            return this.hProfileShellHwnd
        }
    }

    __New()
    {
        static sExeName, sProfileFile, xButtonAdd
        this.SetIcon(Icon.GAMEPAD)
        Gui, New, +HWNDhProfileShellHwnd, X56 Profile Settings
        Gui, Font, s14
        this.hProfileShellHwnd := hProfileShellHwnd
        Gui, %hProfileShellHwnd%:Add, Edit, section vsExeName, exe name
        Gui, %hProfileShellHwnd%:Add, Edit, ys vsProfileFile, profile file
        Gui, %hProfileShellHwnd%:Add, Button, ys vxButtonAdd +HWNDhButtonAdd, Add
        
        fnAddHandler := this._buttonAdd.Bind(this)
        GuiControl, +g, %hButtonAdd%, % fnAddHandler
    }

    __Delete()
    {
        h := this.HWND
        Gui, %h%:Destroy
    }

    SetIcon(pIcon)
    {
        Menu, Tray, Icon, % pIcon.Path, % pIcon.Idx
    }

    Show()
    {
        h := this.HWND
        Gui, %h%:Show
    }

    AddExeProfile(sExeName, sProfileName)
    {
        h := this.HWND
        Gui, %h%:Add, Text,   xm section w30, % sExeName
        Gui, %h%:Add, Text,   ys w30, % sProfileName
        Gui, %h%:add, Button, ys +HWNDhButtonRemove, Remove

        this.rgsExeProfiles[%hButtonRemove%] := sExeName

        fnHandler := this._onRemoveExeProfile.Bind(this)
        GuiControl, +g, %hButtonRemove%, % fnHandler
    }

    Hide()
    {
        h := this.HWND
        Gui, %h%:Hide
    }

    _buttonAdd(CtrlHwnd, GuiEvent, EventInfo, ErrLevel := "")
    {
        ListVars
        Pause
    }

    _onRemoveExeProfile(CtrlHwnd)
    {
        this.rgsExeProfiles.Delete(CtrlHwnd)
        ListVars
        Pause
    }
}

class Icon {
    static _IMAGERES := "imageres.dll"
    static _DDORES   := "ddores.dll"
    static _SHELL32  := "shell32.dll"

    static SUN      := {Path: Icon._IMAGERES, Idx: 332}
    static ERROR    := {Path: Icon._IMAGERES, Idx: 94}
    static GAMEPAD  := {Path: Icon._DDORES, Idx: 107}
    static MOUSE    := {Path: Icon._DDORES,   Idx: 109}
    static FOLDER   := {Path: Icon._SHELL32,  Idx: 310}
    static OPEN_FOLDER      := {Path: Icon._SHELL32, Idx: 311}
    static COMPUTER_SAYS_NO := {Path: Icon._SHELL32, Idx: 312}
}