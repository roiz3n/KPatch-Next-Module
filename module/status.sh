#!/bin/sh

MODDIR=${0%/*}
KPNDIR="/data/adb/kp-next"
PATH="$MODDIR/bin:$PATH"
key="$1"

set_prop() {
    local prop="$1"
    local value="$2"
    local file="$3"

    if ! grep -q "^$prop=" "$file"; then
        echo "$prop=$value" >> "$file"
        return
    fi
    sed "s/^$prop=.*/$prop=$value/" "$file" > "$file.tmp"
    cat "$file.tmp" > "$file"
    rm -f "$file.tmp"
}

active="Status: active 😊"
inactive="Status: inactive 😕"
info="info: key incorrect, not set or kernel not patched yet ❌"
string="$inactive | $info"

[ -z "$key" ] && key="$(cat $KPNDIR/key | base64 -d)"

until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 1
done

if [ -n "$key" ] && kpatch "$key" hello >/dev/null 2>&1; then
    KPM_COUNT="$(kpatch "$key" kpm num 2>/dev/null || echo 0)"
    [ -z "$KPM_COUNT" ] && KPM_COUNT=0
    string="$active | kpmodule: $KPM_COUNT 💉"
fi

set_prop "description" "$string" "$MODDIR/module.prop"
