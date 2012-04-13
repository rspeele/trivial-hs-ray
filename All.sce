Scene
[
( Plane (Vector3 0 0 150) (Vector3 0.44 0 (-0.9))
, Material { matDiffuse = (Vector3 1 1 1)
           , matReflect = 0.25
           , matSpecVal = (Vector3 1 1 1)
	   , matSpecPow = 60
	   , matSpecGss = 0.1
           , matSpecRms = 0.25
           }
)
,
( Plane (Vector3 0 100 0) (Vector3 0 1 0)
, Material { matDiffuse = (Vector3 1 1 1)
           , matReflect = 0.25
           , matSpecVal = (Vector3 1 1 1)
	   , matSpecPow = 60
	   , matSpecGss = 0.1
           , matSpecRms = 0.25
           }
)
,
( Sphere (Vector3 420 200 0) 100
, Material { matDiffuse = (Vector3 0 1 1)
           , matReflect = 0.5
           , matSpecVal = (Vector3 1 1 1)
	   , matSpecPow = 60
	   , matSpecGss = 0.1
           , matSpecRms = 0.25
           }
)
,
( Tri (Vector3 220 100 0) (Vector3 120 300 0) (Vector3 320 300 0)
, Material { matDiffuse = (Vector3 1 0 1)
           , matReflect = 0.5
           , matSpecVal = (Vector3 1 1 1)
	   , matSpecPow = 60
	   , matSpecGss = 0.1
           , matSpecRms = 0.25
           }
)
]
[ Light (Vector3 320 240 (-1000)) (Vector3 1 1 1)
]