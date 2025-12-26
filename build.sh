#!/bin/bash
set -euo pipefail

java -jar "$HOME/plantuml.jar" -tsvg diagrams/example_class_diagram.puml

SVG="diagrams/example_class_diagram.svg"

F_WIDTH=$(inkscape "$SVG" --query-width | sed 's/px//')
F_HEIGHT=$(inkscape "$SVG" --query-height | sed 's/px//')
C_WIDTH=$(awk -v n="$F_WIDTH" 'BEGIN {print (n==int(n)?n:int(n)+1)}')
C_HEIGHT=$(awk -v n="$F_HEIGHT" 'BEGIN {print (n==int(n)?n:int(n)+1)}')

inkscape "$SVG" \
  --export-area=0:0:$C_WIDTH:$C_HEIGHT \
  --export-dpi=96 \
  --export-type=png \
  --export-filename="diagrams/example_class_diagram.png"

DPI=300
P_WIDTH=$(echo "210 * $DPI / 25.4" | bc -l)
P_HEIGHT=$(echo "297 * $DPI / 25.4" | bc -l)
W_PAGES=$(echo "($F_WIDTH + $P_WIDTH - 1) / $P_WIDTH" | bc)
H_PAGES=$(echo "($F_HEIGHT + $P_HEIGHT - 1) / $P_HEIGHT" | bc)

for ((i=0; i<W_PAGES; i++)); do
  x0=$(echo "$i * $P_WIDTH" | bc -l)
  x1=$(echo "($i + 1) * $P_WIDTH" | bc -l)
  for ((j=0; j<H_PAGES; j++)); do
    y0=$(echo "$j * $P_HEIGHT" | bc -l)
    y1=$(echo "($j + 1) * $P_HEIGHT" | bc -l)
    inkscape "$SVG" \
      --export-area="$x0:$y0:$x1:$y1" \
      --export-dpi=$DPI \
      --export-type=png \
      --export-filename="diagrams/page_w${i}_h${j}.png"
  done
done

