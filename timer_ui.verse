
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Colors/NamedColors }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /Verse.org/Random }
using { /Fortnite.com/Characters }
using { /Fortnite.com/AI }
using { config.ui_config}


# Not made for multiplayer, too lazy

timer_ui := class(creative_device):


    TimerTextBlock : text_block = text_block{DefaultTextColor := White}

    @editable
    Minutes :  type{_X:int where 0 <= _X, _X <= 9223372036854775807} = 0

    @editable
    Seconds : type{_X:int where 0 <= _X, _X <= 60} = 45

    TimerDone : event() = event(){}

    OnBegin<override>()<suspends>:void=
        spawn{AwaitTimerSuccess()}
        for(Player : GetPlayspace().GetPlayers()):
            if(PlayerUI := GetPlayerUI[Player]):
                PlayerUI.AddWidget(MakeTimerCanvas())
                StartTimer()

    AwaitTimerSuccess()<suspends>:void=
        loop:
            TimerDone.Await()
            Print("Timer is done.")
            #  Code to run when the timer is done.

    StartTimer()<suspends>:void=
        var _Seconds : int = Seconds
        var _Minutes : int = Minutes
            loop:
                Sleep(1.0)
                set _Seconds -= 1
                if(_Seconds < 0 and not _Minutes = 0):
                    set _Minutes -= 1
                    set _Seconds = 59
                else if(_Seconds <= 0 and _Minutes = 0):
                    TimerTextBlock.SetText(S2M(""))
                    TimerDone.Signal()
                    break
                StringMin := if(_Minutes < 10) then "0{_Minutes}" else "{_Minutes}" 
                StringSec := if(_Seconds < 10) then "0{_Seconds}" else "{_Seconds}" 
                TimerTextBlock.SetText(S2M("{StringMin}:{StringSec}"))
    
    MakeTimerCanvas():canvas=
        return canvas:
            Slots := array:
                canvas_slot:
                    Widget := overlay:
                        Slots := array:
                            overlay_slot:
                                Widget := TimerTextBlock
                                HorizontalAlignment := HorCen
                                VerticalAlignment := VerTop
                                Padding := margin{Top := 100.0}
                    Anchors := anchors{Minimum := vector2{X:= 0.0, Y:= 0.0}, Maximum := vector2{X:= 1.0, Y:= 1.0}}
