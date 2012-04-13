module Main where
import Control.Parallel.Strategies
import Data.Binary.Put
import Data.Word
import System.IO
import Projection
import Ray
import Shaders
import Targa
import Vector
import qualified Data.ByteString.Lazy as B

truncatePx :: Color -> (Word8, Word8, Word8)
truncatePx (Vector3 r g b) = (t r, t g, t b) where t = fromIntegral . truncate . (* 255)

xres = 640
yres = 480
pipe = [(blinn, (+)), (lambert, (+))]
cam  = (camera (Vector3 0 0 (-1000)) .) . perspective 1000
strt = parListChunk 500 rseq -- eval every 500 rays in parallel

main :: IO ()
main = do
  sce <- getContents >>= return . read
  let img = render sce pipe cam xres yres
  B.putStr $ runPut $ tgaHeader xres yres
  B.putStr $ runPut $ mapM tgaPixel ((map truncatePx img) `using` strt) >> return ()