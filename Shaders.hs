module Shaders where
import Ray
import Vector

ambient, lambert, phong, blinn, gaussian, beckmann :: Shader

ambient mat _ _ _ = matDiffuse mat

lambert mat _ (Ray p n) (Light lo lc) =
    (matDiffuse mat) * lc -*- (max 0 ((normal $ lo - p) <> n))

phongterm :: Vector -> Vector -> Vector -> Vector -> Scalar
phongterm vd p n lo = max 0 $ ((normal $ lo - p) `reflect` n) <> vd

phong mat (Ray _ vd) (Ray p n) (Light lo lc) =
    (matSpecVal mat) -*- (phongterm vd p n lo) ** (matSpecPow mat)

blinnterm :: Vector -> Vector -> Vector -> Vector -> Scalar
blinnterm vd p n lo =
    let ld = normal $ lo - p
        bd = ld - vd
    in if sqlen bd == 0 then 0 else max 0 $ (normal bd) <> n

blinn mat (Ray _ vd) (Ray p n) (Light lo lc) =
    (matSpecVal mat) -*- (blinnterm vd p n lo) ** (matSpecPow mat)

gaussian mat (Ray _ vd) (Ray p n) (Light lo lc) =
    (matSpecVal mat) -*- (exp $ -(t / matSpecGss mat)^2)
        where t = acos $ blinnterm vd p n lo

beckmann mat (Ray _ vd) (Ray p n) (Light lo lc) =
    (matSpecVal mat) -*- exp ((-(tan t)^2 / m^2) / (pi * m^2 * b^4))
        where b = blinnterm vd p n lo
              t = acos b
              m = matSpecRms mat