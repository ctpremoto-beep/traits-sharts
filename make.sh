#!/bin/bash
# Redeploy: drop new PNG in ../traits/, then run ./make.sh
cd "$(dirname "$0")"; mkdir -p traits; cp ../base.png ../preview_all.png .; cp ../traits/*.png traits/
L=""; for f in traits/*.png; do n=$(basename $f .png); L="$L<label><input type=checkbox checked data-t=\"$n\"> $n</label>"; I="$I<img id=\"t-$n\" src=\"$f\">"; done
cat > index.html <<H
<!doctype html><html><head><meta charset=utf-8><meta name=viewport content="width=device-width"><title>TRAITS SHARTS</title><style>
body{background:#000;color:#fff;font-family:system-ui;text-align:center}h1{color:#00EC97}
#s{position:relative;width:min(90vw,640px);aspect-ratio:1;margin:auto;background:repeating-conic-gradient(#777 0 25%,#bbb 0 50%) 0 0/32px 32px;border:2px solid #00EC97}
#s img{position:absolute;inset:0;width:100%;height:100%}label{display:inline-block;margin:8px 12px;font-size:18px}
</style></head><body><h1>TRAITS SHARTS</h1><div id=s><img src=base.png>$I</div><div>$L</div>
<script>document.querySelectorAll('input').forEach(c=>c.onchange=()=>document.getElementById('t-'+c.dataset.t).style.display=c.checked?'':'none')</script></body></html>
H
[ "$1" = nodeploy ] || { git add -A; git commit -qm update; git push -q origin main; }
