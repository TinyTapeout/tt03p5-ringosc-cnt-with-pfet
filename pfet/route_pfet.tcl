# VCC power connection
box 533 -800 6787 -376.00
paint via3
box 200 -800 6787 -376.00
paint metal4
box 200 -800 400 10060
paint metal4
label vccd1 FreeSans metal4
port vccd1 make n
port vccd1 use power
port vccd1 class bidirectional
port conn n s e w

# VSS (gnd) power connection
box 6648 -161 6802 68
paint via3
box 6648 -161 16160 68
paint metal4
box 16160 -161 16314 522
paint metal4

# User module power connections
box 525 -164 6600 266
paint via3
box 480 -164 6600 320
paint metal4
box 525 320 14540 480
paint metal4
set PDN_SPACING 3921
for {set strip 0} {$strip < 4} {incr strip} {  
  box  [expr 2426 + $strip * $PDN_SPACING] 480 [expr 2589 + $strip * $PDN_SPACING] 550
  paint metal4
}

# Ena power connection
box 6651 196 16447 236
paint metal3
box 16414 196 16447 236
paint via3
box 16414 196 16446 10851
paint metal4
box 16236 10808 16446 10847
paint metal4
