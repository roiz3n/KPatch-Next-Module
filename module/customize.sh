if [ "$APATCH" ]; then
    abort "! APatch is unsupported"
fi

set_perm_recursive "$MODPATH/bin" 0 2000 0755 0755

mkdir -p /data/adb/kp-next
