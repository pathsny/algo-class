{-# LANGUAGE BangPatterns #-}
module Main where
import System.IO
import System.Environment (getArgs)
import Control.Arrow (first)

main = do
  handle <- openFile "IntegerArray.txt" ReadMode
  numbers <- fmap (map read . lines) $ hGetContents handle
  print (countInversions numbers)
  hClose handle
  
countInversions :: (Num a, Ord a) => [a] -> Integer
countInversions = snd.merge_sort_count


merge_and_count  :: (Ord a) => [a] -> [a] -> ([a], Integer)
merge_and_count l1@(x:xs) l2@(y:ys) | x < y     = first (x:) (merge_and_count xs l2)
                                    |otherwise  = (y:merged, n + (fromIntegral (length l1)))
                                where (merged, !n) = merge_and_count l1 ys
merge_and_count l1 l2 = (l1 ++ l2, 0)                


merge_sort_count :: (Num a, Ord a) => [a] -> ([a], Integer)
merge_sort_count []  = ([], 0) 
merge_sort_count [x] = ([x], 0)
merge_sort_count xs  = (merged, left_invs + right_invs + split_invs)
       where 
           (left, right) = splitAt (length xs `div` 2) xs
           (l1, !left_invs) = merge_sort_count left
           (l2, !right_invs) = merge_sort_count right
           (merged, !split_invs) = merge_and_count l1 l2

           