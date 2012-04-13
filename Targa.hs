module Targa where
import Control.Monad
import Data.Binary.Put
import Data.Word

tgaHeader :: Word16 -> Word16 -> Put
tgaHeader x y = do
  putWord8 0                -- No image ID, so length is 0
  putWord8 0                -- Image contains no color map
  putWord8 2                -- Image is uncompressed, true-color
  replicateM 5 (putWord8 0) -- 5 bytes of no color map specification
  replicateM 4 (putWord8 0) -- Origin coordinates, x and y
  putWord16le x             -- Width in pixels
  putWord16le y             -- Height in pixels
  putWord8 24               -- Bits per pixel
  putWord8 0                -- No alpha channel depth or direction

tgaPixel :: (Word8, Word8, Word8) -> Put
tgaPixel (r, g, b) = mapM putWord8 [b, g, r] >> return ()