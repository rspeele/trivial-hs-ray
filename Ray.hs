module Ray where
import Data.List
import Data.Maybe
import Vector

type Scalar = Double
type Vector = Vector3 Scalar

-- Rays consist of an origin and a direction
data Ray = Ray Vector Vector deriving (Show, Read, Eq)

-- Parametric ray definition
rayT :: Ray -> Scalar -> Vector
rayT (Ray o d) t = o + (d -*- t)

{- To be drawable, a Primitive constructor must have a pattern matching it for both 'intersects' and 'surfnormal'.
 - This is the kind of requirement that would be best enforced by a typeclasse, but it's worth using different constructors
 - within the same data type instead, because it lets us put all kinds of primitives into a single homogeneous collection.
 -}
data Primitive = Sphere Vector Scalar
               | Plane Vector Vector
               | Tri Vector Vector Vector
                 deriving (Show, Read, Eq)

intersects :: Ray -> Primitive -> Maybe Scalar
intersects (Ray ro rd) (Sphere so sr) =
    let dist = so - ro
        b    = rd <> dist
        d    = b^2 - (sqlen dist) + sr^2
        t0   = b - (sqrt d)
        t1   = b + (sqrt d)
    in if d < 0.0 then Nothing else if t0 > 0.01 then Just t0 else
           if t1 > 0.01 then Just t1 else Nothing

intersects (Ray o d) (Plane p n) =
    let b = d <> n
        t = ((p - o) <> n) / b
    in if (abs b) < 0.01 || t < 0.01 then Nothing else Just t

intersects ray@(Ray ro rd) tri@(Tri v0 v1 v2) =
    let (u, v) = (v1 - v0, v2 - v0)
        n = surfnormal tri (Vector3 0 0 0)
        mt = ray `intersects` (Plane v0 n)
        t = fromJust mt
        w = (ray `rayT` t) - v0
        (uv, wv, vv, wu, uu) = (u <> v, w <> v, v <> v, w <> u, u <> u)
        dn = (uv^2 - uu * vv)
        si = (uv * wv - vv * wu) / dn
        ti = (uv * wu - uu * wv) / dn
    in if n == (Vector3 0 0 0) || isNothing mt || si < 0 || si > 1 || ti < 0 || ti + si > 1 then Nothing else Just t

surfnormal :: Primitive -> Vector -> Vector
surfnormal (Sphere so sr) p = normal (p - so)
surfnormal (Plane _ n) _ = n
surfnormal (Tri a b c) _ = normal $ (b - a) >< (c - a)

{- Colors act the same way as vectors and require many of the same operations (adding, multiplying, etc.), but
 - it's nice to have a type synonym to make it obvious what context a given function operates in.
 -}
type Color = Vector
black :: Color
black = Vector3 0 0 0

data Light = Light Vector Color deriving (Show, Read, Eq)

{- Material data describes the properties of a surface. It is liable to change with the addition of shaders,
 - so the field functions should always be used in place of pattern matching.
 -}
data Material = Material { matDiffuse :: Color  -- Used by any diffuse shader, currently only ambient, lambert
                         , matReflect :: Scalar -- Not used directly by shaders (currently), but factors into each trace
                         , matSpecVal :: Color  -- Used by all specular shaders
                         , matSpecPow :: Scalar -- Phong, Blinn-Phong
                         , matSpecGss :: Scalar -- Gaussian
                         , matSpecRms :: Scalar -- Beckmann
                         } deriving (Show, Read, Eq)

type Object = (Primitive, Material)

type Shader = Material -> Ray -> Ray -> Light -> Color

type Pipeline = (Shader, Color -> Color -> Color)

collapse :: [(a, (a -> a -> a))] -> a
collapse [(v, c)] = v
collapse ((v, c) : cvs) = v `c` (collapse cvs)

shade :: [Pipeline] -> Material -> Ray -> Ray -> Light -> Color
shade [] _ _ _ _ = black
shade ss mat vr r lig = collapse $ map (\(fun, com) -> (fun mat vr r lig, com)) ss

closest :: Ray -> [Object] -> Maybe (Object, Scalar)
closest r [] = Nothing
closest r ps = let ts  = map (intersects r . fst) ps
                   pts = filter (isJust . snd) (zip ps ts)
                   (bp, bt) = minimumBy (\(_, t0) (_, t1) -> compare t0 t1) pts
               in if null pts then Nothing else Just (bp, fromJust bt)

behind :: Light -> Ray -> Bool
behind (Light lo _) (Ray ro rd) = (lo - ro) <> rd <= 0

obstructs :: Vector -> Light -> Primitive -> Bool
obstructs p (Light lo _) pr =
    let dir = lo - p in
    case (Ray p (normal dir)) `intersects` pr of
      Just t  -> t < (len dir)
      Nothing -> False

obstructed :: Vector -> [Primitive] -> Light -> Bool
obstructed p prs l = any (obstructs p l) prs

unobstructed :: Vector -> [Primitive] -> [Light] -> [Light]
unobstructed p prs = filter (not . obstructed p prs)

trace :: Int -> [Pipeline] -> [Object] -> [Light] -> Ray -> Color
trace 0 _ _ _ _  = black
trace _ [] _ _ _ = black
trace _ _ [] _ _ = black
trace _ _ _ [] _ = black
trace dep ss objs ligs vr@(Ray ro rd) =
    case vr `closest` objs of
      Nothing              -> black
      Just ((prm, mat), t) ->
          let p   = vr `rayT` t
              n   = surfnormal prm p
              ir  = Ray p n
              vls = filter (not . (`behind` ir)) $ unobstructed p (delete prm $ map fst objs) ligs
              ref = sum $ map (shade ss mat vr ir) vls
          in ref + trace (dep - 1) ss objs ligs (Ray p (rd `reflect` n)) -*- matReflect mat