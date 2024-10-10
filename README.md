# Parametrizable unlevel edge hangboard for climbing

## Rendering times

### Without round edges

```bash
$ openscad -D round_edges=0 -o hangboard_noround.stl hangboard_both_hands.scad
Geometries in cache: 44
Geometry cache size in bytes: 70736
CGAL Polyhedrons in cache: 22
CGAL cache size in bytes: 2307024
Total rendering time: 0:00:00.862
   Top level object is a 3D object:
   Simple:        yes
   Vertices:      382
   Halfedges:    1146
   Edges:         573
   Halffacets:    400
   Facets:        200
   Volumes:         5
```

### With round edges

#### fn=10

Using `polyRoundExtrude`:

```bash
$ openscad -D round_edges=1 -D round_edges_minkowski=false -o hangboard_round_poly_fn10.stl hangboard_both_hands.scad
Geometries in cache: 40
Geometry cache size in bytes: 1872656
CGAL Polyhedrons in cache: 22
CGAL cache size in bytes: 77367360
Total rendering time: 0:00:22.465
   Top level object is a 3D object:
   Simple:        yes
   Vertices:     8158
   Halfedges:   34582
   Edges:       17291
   Halffacets:  18386
   Facets:       9193
   Volumes:        35
```

Using `minkowskiRound`:

```bash
$ openscad -D round_edges=1 -D round_edges_minkowski=true -o hangboard_round_minkowski_fn10.stl hangboard_both_hands.scad
Geometries in cache: 37
Geometry cache size in bytes: 151976
CGAL Polyhedrons in cache: 46
CGAL cache size in bytes: 21365360
Total rendering time: 0:00:09.799
   Top level object is a 3D object:
   Simple:        yes
   Vertices:     2334
   Halfedges:    8354
   Edges:        4177
   Halffacets:   3792
   Facets:       1896
   Volumes:        35
```

#### fn=50

Using `polyRoundExtrude`:

```bash
$ openscad -D round_edges_fn=50 -D round_edges=1 -D round_edges_minkowski=false -o hangboard_round_poly_fn50.stl hangboard_both_hands.scad
Geometries in cache: 41
Geometry cache size in bytes: 39811856
CGAL Polyhedrons in cache: 18
CGAL cache size in bytes: 1685920
Total rendering time: 0:00:07.670
   Top level object is a 3D object:
   Simple:        yes
   Vertices:      286
   Halfedges:     858
   Edges:         429
   Halffacets:    304
   Facets:        152
   Volumes:         5
```

Using `minkowskiRound`:

```bash
$ openscad -D round_edges_fn=50 -D round_edges=1 -D round_edges_minkowski=true -o hangboard_round_minkowski_fn50.stl hangboard_both_hands.scad
Geometries in cache: 37
Geometry cache size in bytes: 320936
CGAL Polyhedrons in cache: 11
CGAL cache size in bytes: 92287936
Total rendering time: 0:02:39.941
   Top level object is a 3D object:
   Simple:        yes
   Vertices:    20830
   Halfedges:   96802
   Edges:       48401
   Halffacets:  55248
   Facets:      27624
   Volumes:        35
```
