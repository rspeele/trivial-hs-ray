module Projection where
import Ray
import Vector

data Scene = Scene [Object] [Light] deriving (Show, Read, Eq)

type Projection = Scalar -> Scalar -> [Ray]

camera :: Vector -> [Ray] -> [Ray]
camera v = map (\(Ray o d) -> Ray (o + v) d)

orthographic :: Projection
orthographic mx my = [ Ray (Vector3 x y 0) (Vector3 0 0 1) | y <- [0 .. my - 1], x <- [0 .. mx - 1] ]

perspective :: Scalar -> Projection
perspective d mx my = [ Ray (Vector3 hx hy 0) (normal (Vector3 x y d)) | y <- [(-hy) .. hy - 1], x <- [(-hx) .. hx - 1] ]
    where (hx, hy) = (mx / 2, my / 2)

expose :: Color -> Color
expose = fmap ((1 -) . exp . ((-1) *))

render :: Integral a => Scene -> [Pipeline] -> Projection -> a -> a -> [Color]
render (Scene objs ligs) ss prj mx my =
    map (expose . trace 10 ss objs ligs) $ prj (fromIntegral mx) (fromIntegral my)
