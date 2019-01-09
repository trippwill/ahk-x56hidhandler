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
#include lib/ahk-argybargy/CArgyBargyServer.ahk
#include CX56ProfileShell.ahk
#include X56_MSG.ahk

;Constants
DEBUG := 2 ; Valid values are 0 (off), 1 (low), 2 (high), 3 (verbose)

;X56 Throttle Description
throttle_description := {USAGE_PAGE: 1, USAGE: 4, VENDOR_ID: 1848, PRODUCT_ID: 41505, VERSION: 256}

shell := new CX56ProfileShell
ab_server := new CArgyBargyServer(X56_SERVER_ID)
throttle_byte_handler := new CX56ThrottleByteHandler(ab_server)
dispatcher := new CHidMessageByteDispatcher(shell.HWND, throttle_description, throttle_byte_handler, throttle_byte_handler.InitState, Func("GetMode"))

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
    InitState := [0x00, 0xFF, 0xFF, 0x0F, 0x00, 0x00, 0x00, 0x20, 0x7E, 0x7F, 0x7E, 0x7F, 0x00, 0x00]

    __New(msgServer) {
        this.msgServer := msgServer
    }

    __Call(name, curr, last, mode) {
        OutputDebug % Format("{1} {2} {3} {4} {5}", A_ThisFunc, name, curr, last, mode)
    }

    0x4(curr, last, mode) {
        global X56T_SW1, X56T_SW2, X56T_SW3, X56T_SW4, X56T_SW5, X56T_SW6, X56T_TG1_U
        currLo := LO_NYB(curr)
        currHi := HI_NYB(curr)
        lastLo := LO_NYB(last)
        lastHi := HI_NYB(last)

        if (currLo != lastLo) {
            ;if the current value is 0, then use the last value to identify the switch
            switch := currLo == 0x0 ? lastLo : currLo 

            if (switch == 0x1)
                this.msgServer.PostMessage(X56T_SW4, curr, mode)
            else if (switch == 0x2)
                this.msgServer.PostMessage(X56T_SW5, curr, mode)
            else if (switch == 0x4)
                this.msgServer.PostMessage(X56T_SW6, curr, mode)
            else if (switch == 0x8)
                this.msgServer.PostMessage(X56T_TG1_U, curr, mode)
        }

        if (currHi != lastHi) {
            ;if the current value is 0, then use the last value to identify the switch
            switch := currHi == 0x0 ? lastHi : currHi

            if (switch == 0x2)
                this.msgServer.PostMessage(X56T_SW1, curr, mode)
            else if (switch == 0x4)
                this.msgServer.PostMessage(X56T_SW2, curr, mode)
            else if (switch == 0x8)
                this.msgServer.PostMessage(X56T_SW3, curr, mode)
        }
    }

    0x5(curr, last, mode) {
        local currLo := LO_NYB(curr)
        local currHi := HI_NYB(curr)
        local lastLo := LO_NYB(last)
        local lastHi := HI_NYB(last)

        if (currLo != lastLo) {
            ;if the current value is 0, then use the last value to identify the switch
            switch := currLo == 0x0 ? lastLo : currLo 

            if (switch == 0x1)
                this.throttleHandler.TGL3_D(curr, mode)
            else if (switch == 0x2)
                this.throttleHandler.TGL4_U(curr, mode)
            else if (switch == 0x4)
                this.throttleHandler.TGL4_D(curr, mode)
        }

        if (currHi != lastHi) {
            ;if the current value is 0, then use the last value to identify the switch
            switch := currHi == 0x0 ? lastHi : currHi

            if (switch == 0x1)
                this.throttleHandler.TGL1_D(curr, mode)
            else if (switch == 0x2)
                this.throttleHandler.TGL2_U(curr, mode)
            else if (switch == 0x4)
                this.throttleHandler.TGL2_D(curr, mode)
            else if (switch == 0x8)
                this.throttleHandler.TGL3_U(curr, mode)
        }
    }

    0x7(curr, last, mode) {
        local currLo := LO_NYB(curr)
        local currHi := HI_NYB(curr)
        local lastLo := LO_NYB(last)
        local lastHi := HI_NYB(last)

        if (currLo != lastLo) {
            ; even number indicates that SLD is off
            currSld := mod(currLo, 2)
            lastSld := mod(lastLo, 2)

            if (currSld != lastSld)
                this.throttleHandler.SLD(curr, mode)
        }

        if (currHi != lastHi) {
            if (currHi == 0x2)
                this.throttleHandler.SCROL_F(curr, mode)
            else if (currHi == 0x4)
                this.throttleHandler.SCROL_B(curr, mode)
        }
    }

    0x9(curr, last, mode) {
        this.throttleHandler.MINISTICK_X(curr, mode)
    }

    0xB(curr, last, mode) {
        this.throttleHandler.MINISTICK_Y(curr, mode)
    }

    0xC(curr, last, mode) {
        this.throttleHandler.RTY4(curr, mode)
    }

    0xD(curr, last, mode) {
        this.throttleHandler.RTY3(curr, mode)
    }
}