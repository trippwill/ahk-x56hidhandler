/* 
X56 HID Message Handler
0.1 [Debug]

Use X56HIDHANDLER_DBG.ahk if you need extra debug information.

Dependencies:
  * HIDMESSAGE.ahk - HID Message Dispatcher
  * BYTEUTILS.ahk  - Simple byte handling "macros"

  Both are available from https://github.com/CharlesWillis3/ahk-hidmessage
*/

#Warn ClassOverwrite
#NoEnv
#KeyHistory 0
ListLines off
SendMode Input
SetWorkingDir %A_ScriptDir%

#include lib/HIDMESSAGE_DBG.ahk
#include lib/BYTEUTILS.ahk
#include x56_profile.ahk

;Constants
DEBUG := 0 ; Valid values are 0 (off), 1 (low), 2 (high), 3 (verbose)

;X56 Throttle Description
OFFSET_MODE := 7
USAGE_PAGE  := 1
USAGE       := 4
VENDOR_ID   := 1848
PRODUCT_ID  := 41505
VERSION     := 256

;Create GUI to receive messages
Gui, +LastFound
hGui := WinExist()

throttle_init_state := [0x00, 0xFF, 0xFF, 0x0F, 0x00, 0x00, 0x00, 0x20, 0x7E, 0x7F, 0x7E, 0x7F, 0x00, 0x00]
dispatcher := new CHidMessageByteDispatcher(hGui, USAGE_PAGE, USAGE, VENDOR_ID, PRODUCT_ID, VERSION, new CThrottleByteHandler, throttle_init_state, Func("GetMode"))

GetMode(ByRef pData) {
    local sbMode, nMode
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

class CThrottleByteHandler
{
    rgpThrottleHandlers := [new Throttle.Mode1
                          , new Throttle.Mode2
                          , new Throttle.Mode3]

    __Call(name, c, l, m) {
        OutputDebug % Format("{1} 0x{2:01X} {3} {4} {5}", A_ThisFunc, name, c, l, m)
    }

    0x4(curr, last, mode) {
        local currLo := LO_NYB(curr)
        local currHi := HI_NYB(curr)
        local lastLo := LO_NYB(last)
        local lastHi := HI_NYB(last)

        if (currLo != lastLo) {
            if (currLo == 0x1)
                key = SW4
            else if (currLo == 0x2)
                key = SW5
            else if (currLo == 0x4)
                key = SW6
            else if (currLo == 0x8)
                key = TGL1_U

            this.rgpThrottleHandlers[mode][key](curr)
        }

        if (currHi != lastHi) {
            if (currHi == 0x2)
                key = SW1
            else if (currHi == 0x4)
                key = SW2
            else if (currHi == 0x8)
                key = SW3

            this.rgpThrottleHandlers[mode][key](curr)
        }
    }

    0x5(curr, last, mode) {
        local currLo := LO_NYB(curr)
        local currHi := HI_NYB(curr)
        local lastLo := LO_NYB(last)
        local lastHi := HI_NYB(last)

        if (currLo != lastLo) {
            if (currLo == 0x1)
                key = TGL3_D
            else if (currLo == 0x2)
                key = TGL4_U
            else if (currLo == 0x4)
                key = TGL4_D

            this.rgpThrottleHandlers[mode][key](curr)
        }

        if (currHi != lastHi) {
            if (currHi == 0x1)
                key = TGL1_D
            else if (currHi == 0x2)
                key = TGL2_U
            else if (currHi == 0x4)
                key = TGL2_D
            else if (currHi == 0x8)
                key = TGL3_U

            this.rgpThrottleHandlers[mode][key](curr)
        }
    }

    0x7(curr, last, mode) {
        local currLo := LO_NYB(curr)
        local currHi := HI_NYB(curr)
        local lastLo := LO_NYB(last)
        local lastHi := HI_NYB(last)

        if (currLo != lastLo) {
            if (mod(currLo, 2) = 0) ; even number indicates that SLD is off
                this.rgpThrottleHandlers[mode].SLD(0)
            else
                this.rgpThrottleHandlers[mode].SLD(curr)
        }

        if (currHi != lastHi) {
            if (currHi == 0x2)
                key = SCROL_F
            else if (currHi == 0x4)
                key = SCROL_B

            this.rgpThrottleHandlers[mode][key](curr)
        }
    }

    0x9(curr, last, mode) {
        this.rgpThrottleHandlers[mode].MINISTICK_X(curr)
    }

    0xB(curr, last, mode) {
        this.rgpThrottleHandlers[mode].MINISTICK_Y(curr)
    }

    0xC(curr, last, mode) {
        this.rgpThrottleHandlers[mode].RTY4(curr)
    }

    0xD(curr, last, mode) {
        this.rgpThrottleHandlers[mode].RTY3(curr)
    }
}