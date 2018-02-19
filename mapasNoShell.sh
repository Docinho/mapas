#evita problemas de download npm, caso este já esteja instalado
npm init
export PATH=$PATH:./node_modules/.bin/
# o -g eh utilizando apenas quenado se tem permissao sudo
# npm install -g shapefile
# deve ser feito dentro da pasta com todos os arquivos
shp2json 25SEE250GC_SIR.shp -o mapaPB.json
# npm install -g d3-geo-projection
geoproject 'd3.geoOrthographic().rotate([54,14,-2]).fitsize([1000,600], d)' \
< mapas.json
> pb-ortho.json
geo2svg -w 1000 -h 600 < pb-ortho.json > pb-ortho.svg
# npm install -g ndjson-cli
ndjson-split 'd.features' < pb-ortho.json > pb-ortho-splitted.ndjson
# npm install -g d3-dsv
dsv2json -r ';' -n < ResponsavelRenda_PB.csv > pb-censo.ndjson
ndjson-map 'd.Cod_setor = d.properties.CD_GEOCODI, d' < pbOrtho.ndjson > pbOrthomap.ndjson
ndjson-join 'd.Cod_setor' pbOrthomap.ndjson pb-censo.ndjson  > merge.ndjson
ndjson-map 'd[0].properties = {rendaMensal: Number(d[1].V005.replace(",","."))}, d[0]' < merge.ndjson > rendaPB.ndjson
# npm install topojson
geo2topo -n tracts=rendaPB.ndjson > rendaPBTractsTopo.json 
toposimplify -p 1 -f < rendaPBTractsTopo.json | topoquantize 1e5 > rendaPBQuantizedTopo.json 
# npm install d3
# npm install d3-scale-chromatic
topo2geo tracts=- < rendaPBQuantizedTopo.json | ndjson-map -r d3 'z=d3.scaleSequential(d3.interpolateGnBu).domain([0,93]),d.features.forEach(f => f.properties.fill = z(f.properties.rendaMensal)), d' | ndjson-split 'd.features' | geo2svg -n --stroke none -w 1000 -h 600 > pb-tracts-threshold-light.svg

