#!/bin/bash
set -euo pipefail

DPI=600

# java -jar "$HOME/plantuml.jar" -tsvg full.puml
# java -jar "$HOME/plantuml.jar" -tsvg exclude.puml
# java -jar "$HOME/plantuml.jar" -tsvg mystd.puml
# java -jar "$HOME/plantuml.jar" -tsvg array.puml

inkscape "array.svg" \
  --export-area-drawing \
  --export-dpi=$DPI \
  --export-type=png \
  --export-filename="array.png"

inkscape "exclude.svg" \
  --export-area-drawing \
  --export-dpi=$DPI \
  --export-type=png \
  --export-filename="exclude.png"

SVG="full.svg"

F_WIDTH=$(inkscape "$SVG" --query-width | sed 's/px//')
F_HEIGHT=$(inkscape "$SVG" --query-height | sed 's/px//')
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
      --export-filename="full_page_w${i}_h${j}.png"
  done
done

SVG="mystd.svg"

F_WIDTH=$(inkscape "$SVG" --query-width | sed 's/px//')
F_HEIGHT=$(inkscape "$SVG" --query-height | sed 's/px//')
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
      --export-filename="mystd_page_w${i}_h${j}.png"
  done
done

