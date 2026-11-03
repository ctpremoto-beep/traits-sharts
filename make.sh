#!/bin/bash
# Redeploy: put PNGs named hat_*, face_* or shirt_*.png in ../traits/, then run ./make.sh  (./make.sh nodeploy = build only)
cd "$(dirname "$0")"; rm -rf traits; mkdir -p traits; cp ../base.png ../preview_all.png .; cp ../traits/*.png traits/
I=""; G=""
for grp in shirt:Clothes face:Face hat:Hats; do k=${grp%%:*}; t=${grp#*:}
  G="$G<fieldset><legend>$t</legend><label><input type=radio name=$k value='' checked> None</label>"
  for f in traits/${k}_*.png; do n=$(basename $f .png); G="$G<label><input type=radio name=$k value=$n> ${n#${k}_}</label>"; I="$I<img class=$k id=$n src=$f style=display:none>"; done
  G="$G</fieldset>"; done
cat > index.html <<H
<!doctype html><html><head><meta charset=utf-8><meta name=viewport content="width=device-width"><title>TRAITS SHARTS</title><style>
body{background:#000;color:#fff;font-family:system-ui;text-align:center}h1{color:#00EC97}
#s{position:relative;width:min(90vw,640px);aspect-ratio:1;margin:auto;background:repeating-conic-gradient(#777 0 25%,#bbb 0 50%) 0 0/32px 32px;border:2px solid #00EC97}
#s img{position:absolute;inset:0;width:100%;height:100%}fieldset{display:inline-block;border:1px solid #00EC97;margin:10px;text-align:left}legend{color:#00EC97}label{display:block;margin:6px;font-size:18px}
</style></head><body><h1>TRAITS SHARTS</h1><p><a href=cyber.html style=color:#00EC97>Cyberpunk Set</a> · <a href=ff.html style=color:#00EC97>Final Fantasy Set</a> · <a href=mapper.html style=color:#00EC97>Open the mapper</a></p><div id=s><img src=base.png>$I</div>$G
<script>document.querySelectorAll('input').forEach(r=>r.onchange=()=>{document.querySelectorAll('img.'+r.name).forEach(i=>i.style.display=i.id==r.value?'':'none')})</script></body></html>
H
[ "$1" = nodeploy ] || { git add -A; git commit -qm update; git push -q origin main; }
