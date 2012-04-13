Scene
[
( Sphere (Vector3 233 290 0) 100
, Material { matDiffuse = (Vector3 1 1 0)
           , matReflect = 0.5
           , matSpecVal = (Vector3 1 1 1)
	   , matSpecPow = 60
	   , matSpecGss = 0.1
           , matSpecRms = 0.25
           }
)
,
( Sphere (Vector3 407 290 0) 100
, Material { matDiffuse = (Vector3 0 1 1)
           , matReflect = 0.5
           , matSpecVal = (Vector3 1 1 1)
	   , matSpecPow = 60
	   , matSpecGss = 0.1
           , matSpecRms = 0.25
           }
)
,
( Sphere (Vector3 320 140 0) 100
, Material { matDiffuse = (Vector3 1 0 1)
           , matReflect = 0.5
           , matSpecVal = (Vector3 1 1 1)
	   , matSpecPow = 60
	   , matSpecGss = 0.1
           , matSpecRms = 0.25
           }
)
]
[ Light (Vector3 0 240 (-100)) (Vector3 1 1 1)
, Light (Vector3 320 240 (-10000)) (Vector3 0.6 0.7 1.0)
]