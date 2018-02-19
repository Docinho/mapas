#!/bin/bash

# a expressão javascript que cria a variável a plotar
EXP_PROPRIEDADE='d[0].properties = {renda: Number(d[1].V005.replace(",", "."))}, d[0]'

# a expressão js que decide os fills baseados em uma escala
#EXP_ESCALA='z = d3.scaleSequential(d3.interpolateViridis).domain([0, 1e3]), d.features.forEach(f => f.properties.fill = z(f.properties.renda)), d'
EXP_ESCALA='z = d3.scaleThreshold().domain([1, 3, 10, 20]).range(d3.schemeYlGnBu[5]), d.features.forEach(f => f.properties.fill = z(f.properties.renda)), d'

# !! Começamos já com a geometria projetada

# Prepara geometrias para o join
ndjson-map 'd.Cod_setor = d.properties.CD_GEOCODI, d' \
  < pbOrtho.ndjson \ # projeção do mapa para o plano
  > pbOrthoSetorMapaLeg.ndjson

# Transforma dados do IBGE para ndjson
dsv2json \
  -r ';' \
  -n \
  < PB/Base\ informaçoes\ setores2010\ universo\ PB/CSV/ResponsavelRenda_PB.csv \
  > pbCensoMapaLeg.ndjson

# Join geometrias + IBGE
ndjson-join 'd.Cod_setor' \
  pbOrthoSetorMapaLeg.ndjson \
  pbCensoMapaLeg.ndjson \
  > pbOrthoCensoMapaLeg.ndjson

# Cria propriedade e plota
ndjson-map \
  "$EXP_PROPRIEDADE" \
  < pbOrthoCensoMapaLeg.ndjson \
  | geo2topo -n \
    tracts=- \
  | toposimplify -p 1 -f \
  | topoquantize 1e5 \
  | topo2geo tracts=- \
  | ndjson-map -r d3 -r d3=d3-scale-chromatic \
    "$EXP_ESCALA" \
  | ndjson-split 'd.features' \
  | geo2svg -n --stroke none -w 1000 -h 600 \
    > pb-chroropleth.svg
