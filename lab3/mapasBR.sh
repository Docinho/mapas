#!/bin/bash

# a expressão js que decide os fills baseados em uma escala
# EXP_ESCALA='z = d3.scaleSequential(d3.interpolateViridis).domain([0, 100]),
#             d.features.forEach(f => f.properties.fill = z(f.properties["Percentual Aprendizado Adequado (%)"])),
#             d'


EXP_ESCALA='z = d3.scaleThreshold().domain([-9, -7, -5, -3, 0, 3, 5, 7, 9]).range(d3.schemePRGn[8]),
            d.features.forEach(f => f.properties.fill = z(f.properties["2013"])),
            d'

../node_modules/.bin/ndjson-map -r d3 -r d3=d3-scale-chromatic \
  "$EXP_ESCALA" \
< geo4-municipios-e-ideb-simplificado.json \
| ../node_modules/.bin/ndjson-split 'd.features' \
| ../node_modules/.bin/geo2svg -n --stroke none -w 1000 -h 600 \
  > aprendizagem-na-pb-choroplethDivergente.svg
