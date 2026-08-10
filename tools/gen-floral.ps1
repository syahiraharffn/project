# Generates watercolour floral SVG artwork for the burgundy / maroon wedding e-card.
# Deterministic: fixed seed -> identical output every run.

$ErrorActionPreference = 'Stop'
$OUT = "$env:USERPROFILE\OneDrive - Universiti Kuala Lumpur\Desktop\Kad-Digital-Burgundy\assets"
$INV = [System.Globalization.CultureInfo]::InvariantCulture

$script:rnd = [System.Random]::new(20261129)
function RndF([double]$a, [double]$b) { $a + ($script:rnd.NextDouble() * ($b - $a)) }
function RndI([int]$a, [int]$b) { $script:rnd.Next($a, $b + 1) }
function Pick($arr) { $arr[$script:rnd.Next(0, $arr.Count)] }
function Num([double]$n) { $n.ToString('0.##', $INV) }

# Burgundy / maroon palette.
#   $rose -> mid dusty-rose blooms (hydrangea heads)   $wine -> deep wine blooms
#   $burg  -> roses & peonies, burgundy through blush   $ivory -> ivory fillers
$rose = @('#BE7C8B', '#AD6478', '#D0929E', '#9E5468', '#C68B99', '#8E4A5E')
$wine = @('#7A2038', '#8C2942', '#5E1526', '#9B3A50')
$burg = @('#6B1B2C', '#7A1F32', '#8E2C44', '#A8455C', '#C4788A')
$sun = @('#E9D3A4', '#DDC189')
$green = @('#576F4F', '#6A8159', '#7F9470', '#61795A', '#8CA07D')
$ivory = @('#FDF6F3', '#F8EBE7')
$soft = @('#E8C6CD', '#F0D8D4', '#DFBCC2', '#EDD2CB')   # pale washes only

# ---------------------------------------------------------------- defs
function Build-Defs {
  $sb = [System.Text.StringBuilder]::new()
  $n = { param($s) [void]$sb.AppendLine($s) }

  # --- single hydrangea floret
  & $n '<g id="fl">'
  & $n '<ellipse cx="0" cy="-4.9" rx="4" ry="5.1"/><ellipse cx="4.9" cy="0" rx="5.1" ry="4"/>'
  & $n '<ellipse cx="0" cy="4.9" rx="4" ry="5.1"/><ellipse cx="-4.9" cy="0" rx="5.1" ry="4"/>'
  & $n '<circle cx="0" cy="0" r="1.5" fill="#F3E4BC"/>'
  & $n '</g>'

  # --- hydrangea clusters (3 variants)
  for ($v = 1; $v -le 3; $v++) {
    $count = RndI 17 24
    $rad = RndF 27 34
    & $n "<g id=`"hyd$v`">"
    for ($i = 0; $i -lt $count; $i++) {
      $a = RndF 0 6.2832
      $d = [math]::Sqrt((RndF 0 1)) * $rad
      $x = [math]::Cos($a) * $d
      $y = [math]::Sin($a) * $d * (RndF 0.8 1.0)
      $s = RndF 0.72 1.12
      $rot = RndF 0 90
      $op = RndF 0.7 1
      & $n ("<use href=`"#fl`" transform=`"translate({0},{1}) rotate({2}) scale({3})`" opacity=`"{4}`"/>" -f (Num $x), (Num $y), (Num $rot), (Num $s), (Num $op))
    }
    & $n '</g>'
  }

  # --- daisy
  $sbP = [System.Text.StringBuilder]::new()
  for ($i = 0; $i -lt 11; $i++) {
    $a = $i * (360 / 11) + (RndF -6 6)
    $ry = RndF 6.5 8.4
    [void]$sbP.Append(("<ellipse cx=`"0`" cy=`"-7.4`" rx=`"2.3`" ry=`"{0}`" transform=`"rotate({1})`"/>" -f (Num $ry), (Num $a)))
  }
  & $n ('<g id="daisy">' + $sbP.ToString() + '<circle r="3" fill="#E7BE68"/><circle r="1.3" fill="#D8A648"/></g>')

  # --- small five petal blossom
  $sbP = [System.Text.StringBuilder]::new()
  for ($i = 0; $i -lt 5; $i++) {
    $a = $i * 72 + (RndF -8 8)
    [void]$sbP.Append(("<ellipse cx=`"0`" cy=`"-4.6`" rx=`"3.1`" ry=`"4.3`" transform=`"rotate({0})`"/>" -f (Num $a)))
  }
  & $n ('<g id="blossom">' + $sbP.ToString() + '<circle r="1.6" fill="#EFDCA8"/></g>')

  # --- upright spike (veronica / lavender)
  $sbP = [System.Text.StringBuilder]::new()
  [void]$sbP.Append('<path d="M0 0 C -1.5 -14 1.5 -28 0 -42" stroke="#6F8767" stroke-width="1.3" fill="none" opacity=".8"/>')
  for ($i = 0; $i -lt 13; $i++) {
    $t = $i / 12.0
    $y = -6 - ($t * 36)
    $x = (RndF -4.2 4.2) * (1 - $t * 0.55)
    $r = (RndF 2.2 3.6) * (1 - $t * 0.5)
    [void]$sbP.Append(("<circle cx=`"{0}`" cy=`"{1}`" r=`"{2}`" opacity=`"{3}`"/>" -f (Num $x), (Num $y), (Num $r), (Num (RndF 0.72 1))))
  }
  & $n ('<g id="spike">' + $sbP.ToString() + '</g>')

  # --- leaf + sprigs
  & $n '<g id="leaf"><path d="M0 0 C6.2 -3.4 9.6 -11.5 8.2 -21.5 C1.8 -17.4 -1.6 -9 0 0 Z"/></g>'
  for ($v = 1; $v -le 3; $v++) {
    $sbP = [System.Text.StringBuilder]::new()
    $len = RndF 46 70
    $bend = RndF -16 16
    [void]$sbP.Append(("<path d=`"M0 0 Q {0} {1} {2} {3}`" stroke=`"currentColor`" stroke-width=`"1.5`" fill=`"none`" opacity=`".85`"/>" -f (Num ($bend * 0.6)), (Num (-$len * 0.5)), (Num $bend), (Num (-$len))))
    $pairs = RndI 4 6
    for ($i = 1; $i -le $pairs; $i++) {
      $t = $i / ($pairs + 0.6)
      $y = -$len * $t
      $x = $bend * $t * $t
      $sc = (RndF 0.55 0.95) * (1 - $t * 0.35)
      [void]$sbP.Append(("<use href=`"#leaf`" transform=`"translate({0},{1}) rotate({2}) scale({3})`"/>" -f (Num $x), (Num $y), (Num (RndF 18 48)), (Num $sc)))
      [void]$sbP.Append(("<use href=`"#leaf`" transform=`"translate({0},{1}) rotate({2}) scale({3},{4})`"/>" -f (Num $x), (Num $y), (Num (RndF -48 -18)), (Num (-$sc)), (Num $sc)))
    }
    & $n ('<g id="sprig' + $v + '">' + $sbP.ToString() + '</g>')
  }

  # --- baby's breath
  for ($v = 1; $v -le 2; $v++) {
    $sbP = [System.Text.StringBuilder]::new()
    $arms = RndI 6 9
    for ($i = 0; $i -lt $arms; $i++) {
      $a = (RndF -75 75) - 90
      $len = RndF 14 30
      $x = [math]::Cos($a * [math]::PI / 180) * $len
      $y = [math]::Sin($a * [math]::PI / 180) * $len
      [void]$sbP.Append(("<path d=`"M0 0 Q {0} {1} {2} {3}`" stroke=`"#7E9470`" stroke-width=`"0.9`" fill=`"none`" opacity=`".7`"/>" -f (Num ($x * 0.4)), (Num ($y * 0.7)), (Num $x), (Num $y)))
      [void]$sbP.Append(("<circle cx=`"{0}`" cy=`"{1}`" r=`"{2}`"/>" -f (Num $x), (Num $y), (Num (RndF 1.8 3.1))))
    }
    & $n ('<g id="gyp' + $v + '">' + $sbP.ToString() + '</g>')
  }

  # --- watercolour peony / rose: three rings of overlapping petals
  for ($v = 1; $v -le 2; $v++) {
    $sbP = [System.Text.StringBuilder]::new()
    [void]$sbP.Append('<circle r="19" opacity=".4"/>')
    $rings = @(@(18, 9, 7.5, 0.5), @(11.5, 7, 6.2, 0.6), @(5.5, 5, 4.6, 0.75))
    foreach ($ring in $rings) {
      $dist = $ring[0]; $cnt = [int]$ring[1]; $pr = $ring[2]; $op = $ring[3]
      $off = RndF 0 360
      for ($i = 0; $i -lt $cnt; $i++) {
        $a = $off + $i * (360 / $cnt) + (RndF -10 10)
        [void]$sbP.Append(("<ellipse cx=`"0`" cy=`"{0}`" rx=`"{1}`" ry=`"{2}`" transform=`"rotate({3})`" opacity=`"{4}`"/>" -f
            (Num (-$dist)), (Num ($pr * (RndF 0.85 1.15))), (Num ($pr * (RndF 0.7 0.95))), (Num $a), (Num ($op * (RndF 0.85 1.1)))))
      }
    }
    [void]$sbP.Append('<circle r="2.6" fill="#E7BE68" opacity=".9"/>')
    & $n ('<g id="rose' + $v + '">' + $sbP.ToString() + '</g>')
  }

  # --- bud
  & $n '<g id="bud"><ellipse cx="0" cy="-6" rx="4.2" ry="6.4"/><path d="M0 0 C-3 -2 -4 -5 -3.6 -8 C-1 -6 0 -3 0 0 Z" fill="#6F8767" opacity=".85"/><path d="M0 0 C3 -2 4 -5 3.6 -8 C1 -6 0 -3 0 0 Z" fill="#6F8767" opacity=".85"/></g>'

  return $sb.ToString()
}

# ------------------------------------------------------- one bouquet
function Add-Bouquet {
  param($x, $y, $scale, $wash, $greens, $blooms, $tops, [double]$fullness = 1)

  $j = { param($r) RndF (-$r) $r }
  $put = { param($list, $href, $col, $ox, $oy, $sc, $rot, $op)
    [void]$list.AppendLine(("<use href=`"#{0}`" color=`"{1}`" transform=`"translate({2},{3}) rotate({4}) scale({5})`" opacity=`"{6}`"/>" -f
        $href, $col, (Num ($x + $ox * $scale)), (Num ($y + $oy * $scale)), (Num $rot), (Num ($sc * $scale)), (Num $op)))
  }

  # soft colour wash underneath — kept pale so the deep reds stay as focal points
  [void]$wash.AppendLine(("<ellipse cx=`"{0}`" cy=`"{1}`" rx=`"{2}`" ry=`"{3}`" fill=`"{4}`" opacity=`"{5}`"/>" -f
      (Num ($x + (& $j 12))), (Num ($y + (& $j 12))), (Num ((RndF 48 76) * $scale)), (Num ((RndF 40 66) * $scale)), (Pick $soft), (Num (RndF 0.14 0.26))))

  # greenery first
  $ns = [int][math]::Round((RndI 4 6) * $fullness)
  for ($i = 0; $i -lt $ns; $i++) {
    & $put $greens ("sprig" + (RndI 1 3)) (Pick $green) (& $j 40) (& $j 36) (RndF 0.85 1.45) (RndF 0 360) (RndF 0.75 0.95)
  }

  # main blooms
  $nh = [int][math]::Round((RndI 2 3) * $fullness)
  if ($nh -lt 1) { $nh = 1 }
  for ($i = 0; $i -lt $nh; $i++) {
    $fam = if ((RndF 0 1) -gt 0.32) { $rose } else { $wine }
    & $put $blooms ("hyd" + (RndI 1 3)) (Pick $fam) (& $j 32) (& $j 28) (RndF 0.9 1.4) (RndF 0 360) (RndF 0.88 1)
  }
  if ((RndF 0 1) -gt 0.22) {
    & $put $blooms ("rose" + (RndI 1 2)) (Pick $burg) (& $j 34) (& $j 30) (RndF 0.8 1.25) (RndF 0 360) (RndF 0.82 0.96)
  }

  # accents on top
  $nd = [int][math]::Round((RndI 1 3) * $fullness)
  for ($i = 0; $i -lt $nd; $i++) {
    $c = if ((RndF 0 1) -gt 0.32) { Pick $ivory } else { Pick ($burg + $sun) }
    & $put $tops "daisy" $c (& $j 40) (& $j 36) (RndF 0.75 1.2) (RndF 0 360) (RndF 0.85 1)
  }
  $nk = RndI 1 2
  for ($i = 0; $i -lt $nk; $i++) {
    & $put $tops "spike" (Pick ($rose + $wine)) (& $j 38) (& $j 30) (RndF 0.8 1.2) (RndF -28 28) (RndF 0.8 1)
  }
  $ng = RndI 1 2
  for ($i = 0; $i -lt $ng; $i++) {
    & $put $tops ("gyp" + (RndI 1 2)) (Pick $ivory) (& $j 44) (& $j 38) (RndF 0.75 1.2) (RndF -40 40) (RndF 0.8 1)
  }
  $nb = RndI 1 2
  for ($i = 0; $i -lt $nb; $i++) {
    & $put $tops "blossom" (Pick ($burg + $rose + $ivory)) (& $j 44) (& $j 40) (RndF 0.65 1.1) (RndF 0 360) (RndF 0.8 1)
  }
  if ((RndF 0 1) -gt 0.5) {
    & $put $tops "bud" (Pick ($burg + $rose)) (& $j 44) (& $j 38) (RndF 0.75 1.15) (RndF -50 50) 0.9
  }
}

function Wrap-Svg {
  param($w, $h, $defs, $wash, $greens, $blooms, $tops, $id)
  @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 $w $h" fill="currentColor" aria-hidden="true">
<!-- Lapisan bunga sengaja TIADA penapis. WebKit (iOS Safari) meraster mana-mana
     subpokok bertapis ke dalam penimbal saiz tetap, lalu menskalakannya semula
     ke skrin Retina - hasilnya bunga nampak kabur pada iPhone. Tanpa penapis,
     bunga kekal vektor dan tajam pada sebarang ketumpatan piksel.
     Hanya lapisan wash yang bertapis, dan lapisan itu memang sepatutnya kabur. -->
<defs>
<filter id="blur$id" x="-30%" y="-30%" width="160%" height="160%"><feGaussianBlur stdDeviation="26"/></filter>
$defs
</defs>
<g filter="url(#blur$id)">
$wash
</g>
<g style="mix-blend-mode:multiply">
<g opacity=".9">
$greens
</g>
$blooms
$tops
</g>
</svg>
"@
}

# =============================================== 1. full hero frame
$W = 800; $H = 1400
$defs = Build-Defs
$wash = [System.Text.StringBuilder]::new()
$greens = [System.Text.StringBuilder]::new()
$blooms = [System.Text.StringBuilder]::new()
$tops = [System.Text.StringBuilder]::new()

$anchors = @()
# top + bottom bands (two staggered rows so the band reads deep like the reference)
for ($x = -40; $x -le 840; $x += 70) {
  $anchors += , @(($x + (RndF -16 16)), (RndF -22 40), (RndF 1.0 1.45), 1.0)
  $anchors += , @(($x + (RndF -18 18) + 35), (RndF 66 132), (RndF 0.75 1.15), 0.8)
  $anchors += , @(($x + (RndF -16 16)), ($H - (RndF -22 40)), (RndF 1.0 1.45), 1.0)
  $anchors += , @(($x + (RndF -18 18) + 35), ($H - (RndF 66 132)), (RndF 0.75 1.15), 0.8)
}
# side runners: outer column bleeds off the edge, inner column thins toward the centre
for ($y = 165; $y -le $H - 165; $y += 58) {
  # mirrored so both edges carry the same weight; only the flowers inside differ
  $ox = RndF -24 30; $oy = $y + (RndF -14 14); $os = RndF 0.9 1.3
  $anchors += , @($ox, $oy, $os, 0.95)
  $anchors += , @(($W - $ox), ($y + (RndF -14 14)), $os, 0.95)
  if ((RndF 0 1) -gt 0.35) {
    $ix = RndF 52 112; $iy = $y + (RndF -24 24); $isc = RndF 0.6 0.95
    $anchors += , @($ix, $iy, $isc, 0.6)
    $anchors += , @(($W - $ix), ($y + (RndF -24 24)), $isc, 0.6)
  }
}
# corner emphasis
$cx0 = 30; $cx1 = $W - 30; $cy0 = 40; $cy1 = $H - 40
$dx0 = 96; $dx1 = $W - 96; $dy0 = 118; $dy1 = $H - 118
foreach ($c in @(@($cx0, $cy0), @($cx1, $cy0), @($cx0, $cy1), @($cx1, $cy1), @($dx0, $dy0), @($dx1, $dy0), @($dx0, $dy1), @($dx1, $dy1))) {
  $anchors += , @($c[0], $c[1], (RndF 1.15 1.5), 1.0)
}

foreach ($a in $anchors) { Add-Bouquet $a[0] $a[1] $a[2] $wash $greens $blooms $tops $a[3] }

$svg = Wrap-Svg $W $H $defs $wash.ToString() $greens.ToString() $blooms.ToString() $tops.ToString() 'A'
[System.IO.File]::WriteAllText("$OUT\bingkai-bunga.svg", $svg, [System.Text.UTF8Encoding]::new($false))

# =============================================== 2. corner spray
$wash = [System.Text.StringBuilder]::new(); $greens = [System.Text.StringBuilder]::new()
$blooms = [System.Text.StringBuilder]::new(); $tops = [System.Text.StringBuilder]::new()
Add-Bouquet 66 62 1.15 $wash $greens $blooms $tops 1.0
Add-Bouquet 132 30 0.8 $wash $greens $blooms $tops 0.7
Add-Bouquet 28 132 0.85 $wash $greens $blooms $tops 0.7
Add-Bouquet 118 118 0.6 $wash $greens $blooms $tops 0.5
$svg = Wrap-Svg 220 220 $defs $wash.ToString() $greens.ToString() $blooms.ToString() $tops.ToString() 'B'
[System.IO.File]::WriteAllText("$OUT\sudut-bunga.svg", $svg, [System.Text.UTF8Encoding]::new($false))

# =============================================== 3. divider spray
$wash = [System.Text.StringBuilder]::new(); $greens = [System.Text.StringBuilder]::new()
$blooms = [System.Text.StringBuilder]::new(); $tops = [System.Text.StringBuilder]::new()
Add-Bouquet 200 62 0.8 $wash $greens $blooms $tops 0.75
Add-Bouquet 128 70 0.55 $wash $greens $blooms $tops 0.5
Add-Bouquet 272 70 0.55 $wash $greens $blooms $tops 0.5
Add-Bouquet 72 78 0.4 $wash $greens $blooms $tops 0.35
Add-Bouquet 328 78 0.4 $wash $greens $blooms $tops 0.35
$svg = Wrap-Svg 400 120 $defs $wash.ToString() $greens.ToString() $blooms.ToString() $tops.ToString() 'C'
[System.IO.File]::WriteAllText("$OUT\garis-bunga.svg", $svg, [System.Text.UTF8Encoding]::new($false))

Get-ChildItem $OUT -Filter *.svg | ForEach-Object { "{0}  {1} KB" -f $_.Name, [math]::Round($_.Length / 1KB, 1) }
