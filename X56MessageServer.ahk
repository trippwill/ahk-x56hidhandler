/* 
X56 MESSAGE SERVER
0.1 [Debug]

This version outputs additional debug information at a small performance cost.
Use X56HIDHANDLER.ahk if you don't need the extra debug information.

Dependencies:
  * HIDMESSAGE.ahk - HID Message Dispatcher
  * BYTEUTILS.ahk  - Simple byte handling "macros". Included by HIDMESSAGE.ahk

  Both are available from https://github.com/CharlesWillis3/ahk-hidmessage
*/

#Warn ClassOverwrite
#NoEnv
#KeyHistory 0
ListLines off
SendMode Input
SetWorkingDir %A_ScriptDir%

#include lib/ahk-hidmessage/CHidMessageByteDispatcher.ahk
#include lib/ahk-argybargy/CArgyBargyIniServer.ahk
#include CX56ProfileShell.ahk

;Constants
DEBUG := 2 ; Valid values are 0 (off), 1 (low), 2 (high), 3 (verbose)

;X56 Throttle Description
throttle_description := {USAGE_PAGE: 1, USAGE: 4, VENDOR_ID: 1848, PRODUCT_ID: 41505, VERSION: 256}

shell := new CX56ProfileShell
ab_server := new CArgyBargyIniServer(A_ScriptDir . "\X56.ini")
throttle_byte_handler := new CX56ThrottleByteHandler(ab_server)
dispatcher := new CHidMessageByteDispatcher(shell.HWND, throttle_description, throttle_byte_handler, CX56ThrottleByteHandler.InitState, Func("GetMode"))

GetMode(ByRef pData) {
    static OFFSET_MODE := 7

    sbMode := LO_NYB(NumGet(pData, OFFSET_MODE, "UChar"))

    if (sbMode & 0x2 == 0x2) {
        nMode := 1
    }
    else if (sbMode & 0x4 == 0x4) {
        nMode := 2
    }
    else if (sbMode & 0x8 == 0x8) {
        nMode := 3
    }
    else
        OutputDebug, Unknown or invalid mode %sbMode%

    return nMode
}

class CX56ThrottleByteHandler
{
    static InitState := [0x00, 0xFF, 0xFF, 0x0F, 0x00, 0x00, 0x00, 0x20, 0x7E, 0x7F, 0x7E, 0x7F, 0x00, 0x00]

    __New(msgServer) {
        this.msgServer := msgServer
    }

    __Call(name, curr, last, mode) {
        OutputDebug % Format("{1} {2} {3} {4} {5}", A_ThisFunc, name, curr, last, mode)
    }

    0x4(curr, last, mode) {
        currLo := LO_NYB(curr)
        currHi := HI_NYB(curr)
        lastLo := LO_NYB(last)
        lastHi := HI_NYB(last)

        if (currLo != lastLo) {
            ;if the current value is 0, then use the last value to identify the switch
            switch := currLo == 0x0 ? lastLo : currLo 

            if (switch == 0x1)
                this.msgServer.X56T_SW4(curr, mode)
            else if (switch == 0x2)
                this.msgServer.X56T_SW5( curr, mode)
            else if (switch == 0x4)
                this.msgServer.X56T_SW6(curr, mode)
            else if (switch == 0x8)
                this.msgServer.X56T_TG1U(curr, mode)
        }

        if (currHi != lastHi) {
            ;if the current value is 0, then use the last value to identify the switch
            switch := currHi == 0x0 ? lastHi : currHi

            if (switch == 0x2)
                this.msgServer.X56T_SW1(curr, mode)
            else if (switch == 0x4)
                this.msgServer.X56T_SW2(curr, mode)
            else if (switch == 0x8)
                this.msgServer.X56T_SW3(curr, mode)
        }
    }

    0x5(curr, last, mode) {
        currLo := LO_NYB(curr)
        currHi := HI_NYB(curr)
        lastLo := LO_NYB(last)
        lastHi := HI_NYB(last)

        if (currLo != lastLo) {
            ;if the current value is 0, then use the last value to identify the switch
            switch := currLo == 0x0 ? lastLo : currLo 

            if (switch == 0x1)
                this.msgServer.X56T_TG3D(curr, mode)
            else if (switch == 0x2)
                this.msgServer.X56T_TG4U(curr, mode)
            else if (switch == 0x4)
                this.msgServer.X56T_TG4D(curr, mode)
        }

        if (currHi != lastHi) {
            ;if the current value is 0, then use the last value to identify the switch
            switch := currHi == 0x0 ? lastHi : currHi

            if (switch == 0x1)
                this.msgServer.X56T_TG1D(curr, mode)
            else if (switch == 0x2)
                this.msgServer.X56T_TG2U(curr, mode)
            else if (switch == 0x4)
                this.msgServer.X56T_TG2D(curr, mode)
            else if (switch == 0x8)
                this.msgServer.X56T_TG3U(curr, mode)
        }
    }

    0x7(curr, last, mode) {
        currLo := LO_NYB(curr)
        currHi := HI_NYB(curr)
        lastLo := LO_NYB(last)
        lastHi := HI_NYB(last)

        if (currLo != lastLo) {
            ; even number indicates that SLD is off
            currSld := mod(currLo, 2)
            lastSld := mod(lastLo, 2)

            if (currSld != lastSld)
                this.msgServer.X56T_SLD(curr, mode)
        }

        if (currHi != lastHi) {
            if (currHi == 0x2)
                this.msgServer.X56T_SCROLF(curr, mode)
            else if (currHi == 0x4)
                this.msgServer.X56T_SCROLB(curr, mode)
        }
    }

    0x9(curr, last, mode) {
        this.msgServer.X56T_MINISTICKX(curr, mode)
    }

    0xB(curr, last, mode) {
        this.msgServer.X56T_MINISTICKY(curr, mode)
    }

    0xC(curr, last, mode) {
        this.msgServer.X56T_RTY4(curr, mode)
    }

    0xD(curr, last, mode) {
        this.msgServer.X56T_RTY3(curr, mode)
    }
}