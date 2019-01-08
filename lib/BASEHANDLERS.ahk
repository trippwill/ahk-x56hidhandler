class ActiveWinExeProfileHandler
{
    ExeProfiles := {}
    DefaultProfile := {}

    __Call(name, curr, mode) {
        activeExeKey := this.GetActiveWinExe()

        if (this.ExeProfiles.HasKey(activeExeKey) and this.ExeProfiles[activeExeKey].QuerySwitch(name, mode)) {
            this.ExeProfiles[activeExeKey][name](curr, mode)
            return true
        }

        if (this.DefaultProfile.QuerySwitch(name, mode)) {
            ObjBindMethod(this.DefaultProfile, name).Call(curr, mode)
            return true
        }
    }

    GetActiveWinExe() {
        WinGet, sActiveWinExe, ProcessName,  A
        StringLower, sActiveWinExe, sActiveWinExe
        return sActiveWinExe
    }
}

class ModeSwitchHandler
{
    Modes := {}

    __Call(name, val, mode) {
        if (IsFunc(this.Modes[mode][name]))
            return this.Modes[mode][name](val)
    }

    QuerySwitch(name, mode) {
        return this.Modes.HasKey(mode) and IsFunc(this.Modes[mode][name])
    }
}

class ModelessSwitchHandler
{
    __Call(name, val , mode) {
        if (IsFunc(this[name]))
            return this[name](val)
    }

    QuerySwitch(name) {
        return IsFunc(this[name])
    }
}