module Vector where

data Vector3 a = Vector3 a a a deriving (Show, Read, Eq)

instance Functor Vector3 where
    fmap f (Vector3 x y z) = Vector3 (f x) (f y) (f z)

vecZipWith :: (a -> b -> c) -> Vector3 a -> Vector3 b -> Vector3 c
vecZipWith f (Vector3 u v w) (Vector3 x y z) = Vector3 (f u x) (f v y) (f w z)

-- Vector a -> Vector a -> Vector a operations defined in terms of the basic numeric operators
instance Num a => Num (Vector3 a) where
    (+)           = vecZipWith (+)
    (-)           = vecZipWith (-)
    (*)           = vecZipWith (*)
    negate        = fmap negate
    abs           = fmap abs
    signum        = fmap signum
    fromInteger n = fmap fromInteger (Vector3 n n n)

instance Fractional a => Fractional (Vector3 a) where
    (/)            = vecZipWith (/)
    recip          = fmap ((/) 1.0)
    fromRational r = fmap fromRational (Vector3 r r r)

fromScalar :: a -> Vector3 a
fromScalar x = Vector3 x x x

-- Vector a -> a -> Vector a operations
(-*-) :: Num a => Vector3 a -> a -> Vector3 a
(-*-) v n = fmap (n *) v
infixl 7 -*-

(-/-) :: Fractional a => Vector3 a -> a -> Vector3 a
(-/-) v n = fmap (/ n) v
infixl 7 -/-

-- Dot and cross products
(<>) :: Num a => Vector3 a -> Vector3 a -> a
(<>) (Vector3 x1 y1 z1) (Vector3 x2 y2 z2) = x1 * x2 + y1 * y2 + z1 * z2

(><) :: Num a => Vector3 a -> Vector3 a -> Vector3 a
(><) (Vector3 x1 y1 z1) (Vector3 x2 y2 z2) =
    Vector3 (y1 * z2 - y2 * z1) (z1 * x2 - z2 * x1) (x1 * y2 - x2 * y1)

-- Various operations on single vectors
sqlen :: Num a => Vector3 a -> a
sqlen v = v <> v

len :: Floating a => Vector3 a -> a
len = sqrt . sqlen

normal :: Floating a => Vector3 a -> Vector3 a
normal v = v -/- (len v)

-- Reflecting vectors off of surface normals
refcor :: Num a => a -> Vector3 a -> Vector3 a -> Vector3 a
refcor c v n = v - (n -*- (v <> n) -*- (1 + c))

reflect :: Num a => Vector3 a -> Vector3 a -> Vector3 a
reflect = refcor 1

-- Convenience
project :: Floating a => Vector3 a -> Vector3 a -> Vector3 a
project u v = (normal v) -*- (u <> v)