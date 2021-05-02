#!/bin/bash
#prevent duplicate script
#https://www.unix.com/302415844-post6.html
#exclude $$ (PID of self), basename $0 = this script
if pidof -x -o $$ $(basename "$0") >/dev/null ; then
    echo "Already running, exiting"
    exit
fi

usage() { echo "Usage: $0 {[-i]||[-d]}{1||5} (increase/decrease 1 or 5)
    {[-j]||[-e]}{1} (inc/dec xrandr backlight by 0.1)
    -n 1|0 (1=turn on night mode, 0=off)" 1>&2; exit 1;}
while getopts "idjehn" arg; do
    case "${arg}" in
        i) i=1 ;;
        d) d=1 ;;
        j) j=1 ;;
        e) e=1 ;;
        n) n=1 ;;
        h) usage; exit 0 ;;
        *) usage; exit 0 ;;
    esac
done

#xrandr --output eDP1 --brightness 0.x
curbrightness=$( echo "scale=0; $( xbacklight -get )/1" | bc )
#https://manerosss.wordpress.com/2017/05/16/brightness-linux-xrandr/
xbacklight=$(xrandr --verbose | grep eDP1 -A 10 | grep Brightness | grep -o '[0-9].*')
xgamma=$(xrandr --verbose | grep eDP1 -A 10 | grep Gamma | grep -o '[0-9].*')
newXBright=$xbacklight
newXGamma=$xgamma
eDP=eDP1
extDP1=DP2
extDP2=HDMI

#https://github.com/WinEunuuchs2Unix/eyesome/blob/master/eyesome-src.sh#L91
setXBriGam () {
    echo "setting $newXBright $newXGamma"
    xrandr --output $eDP --brightness $newXBright --gamma $newXGamma
    if xrandr | grep "$extDP1 connected"; then
        xrandr --output $extDP1 --brightness $newXBright --gamma $newXGamma
    fi
    if xrandr | grep "$extDP2 connected"; then
        xrandr --output $extDP2 --brightness $newXBright --gamma $newXGamma
    fi
}

if [[ $# -ne 2 ]]; then
    echo "bad number args, i # to inc, d # to dec"
    exit 1
fi

echo "cur: $curbrightness xback: $xbacklight xgamma: $xgamma"
if [[ -n "${i}" ]]; then
     if [[ "$2" -eq 1 ]]; then
         xbacklight -inc 1
    elif [[ "$2" -eq 5 ]]; then
         xbacklight -inc 5
    else
        echo "not increasing"
    fi
elif [[ -n "${d}" ]]; then
    if [[ "$2" -eq 1 ]]; then
        if [[ $curbrightness -ge 1 ]]; then
            xbacklight -dec 1
        fi
    elif [[ "$2" -eq 5 ]]; then
        if [[ $curbrightness -le 6 ]]; then
            xbacklight -set 1
        else
            xbacklight -dec 5
        fi
    else
        echo "not decreasing"
    fi
elif [[ -n "${j}" ]]; then
    if [[ "$2" -eq 1 ]] && [[ $(echo "$xbacklight < 1.0" | bc) -eq 1 ]]; then
        newXBright=$(echo $xbacklight+0.1 | bc); setXBriGam
    else
        echo "not increasing xrandr backlight"
    fi
elif [[ -n "${e}" ]]; then
    if [[ "$2" -eq 1 ]] && [[ $(echo "$xbacklight > 0.4" | bc) -eq 1 ]]; then
        newXBright=$(echo $xbacklight-0.1 | bc); setXBriGam
    else
        echo "not decreasing xrandr backlight"
    fi
elif [[ -n "${n}" ]]; then
    if [[ "$2" -eq 1 ]]; then
        newXGamma="1.0:0.8:0.6"; setXBriGam
    else
        newXGamma="1.0:1.0:1.0"; setXBriGam
    fi
else
    echo "bad arguments"
fi
