Scene
[
( Sphere (Vector3 320 240 0) 100
, Material { matDiffuse = (Vector3 1 0 0)
           , matReflect = 0.25
           , matSpecVal = (Vector3 1 1 1)
	   , matSpecPow = 60
	   , matSpecGss = 0.1
           , matSpecRms = 0.25
           }
)
,
( Sphere (Vector3 160 120 200) 100
, Material { matDiffuse = (Vector3 0 1 0)
           , matReflect = 0.5
           , matSpecVal = (Vector3 1 1 1)
	   , matSpecPow = 60
	   , matSpecGss = 0.1
           , matSpecRms = 0.25
           }
)
,
( Sphere (Vector3 480 360 200) 100
, Material { matDiffuse = (Vector3 0 0 1)
           , matReflect = 0.5
           , matSpecVal = (Vector3 1 1 1)
	   , matSpecPow = 60
	   , matSpecGss = 0.1
           , matSpecRms = 0.25
           }
)
]
[ Light (Vector3 320 240 (-1000)) (Vector3 0.6 0.6 0.6)
, Light (Vector3 640 480 0) (Vector3 0.4 0.4 0.4)
, Light (Vector3 320 240 1000) (Vector3 0.2 0.2 0.2)
]