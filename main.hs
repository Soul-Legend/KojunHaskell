module Main where

import Solver
import Matrix

-- links dos problemas
-- https://www.janko.at/Raetsel/Kojun/001.a.htm  (6x6)
-- https://www.janko.at/Raetsel/Kojun/004.a.htm  (8x8)
-- https://www.janko.at/Raetsel/Kojun/010.a.htm  (10x10)
-- Areas e tabuleiros foram obtidos ispecionando o codigo fonte dos links

board6x6Values :: Board
board6x6Values = [[2,0,0,0,1,0],
                        [0,0,0,3,0,0],
                        [0,3,0,0,5,3],
                        [0,0,0,0,0,0],
                        [0,0,3,0,4,2],
                        [0,0,0,0,0,0]]
board6x6areas :: Board
board6x6areas = [[1,1,7,7,7,11],
                        [2,2,2,2,2,11],
                        [3,6,6,6,2,10],
                        [3,3,3,6,10,10],
                        [4,4,8,9,9,9],
                        [5,5,8,8,9,9]]
                        
board8x8Values :: Board
board8x8Values = [[2,5,0,0,3,0,0,0],
                        [0,0,6,0,0,0,0,0],
                        [0,0,5,0,5,2,0,0],
                        [0,0,0,2,0,0,0,0],
                        [0,0,1,0,4,0,0,0],
                        [3,0,2,0,0,4,0,0],
                        [0,0,0,6,0,0,0,0],
                        [0,0,0,0,4,0,3,2]]
board8x8areas :: Board
board8x8areas = [[1,4,4,4,4,12,14,14],
                        [1,1,7,4,12,12,15,15],
                        [2,5,7,10,12,12,16,16],
                        [2,6,7,7,7,12,16,16],
                        [2,6,7,11,11,11,16,17],
                        [3,6,8,11,8,8,17,17],
                        [3,3,8,8,8,13,13,17],
                        [3,3,9,9,13,13,13,17]]
                        
board10x10Values :: Board
board10x10Values = [[5,0,2,0,2,0,3,1,3,1],
                        [0,4,0,1,0,5,0,5,0,4],
                        [7,5,1,7,0,0,3,1,3,0],
                        [0,4,0,0,0,0,0,0,0,3],
                        [2,0,3,4,0,2,0,0,4,0],
                        [5,0,2,0,6,0,0,0,0,0],
                        [0,1,3,0,1,0,0,4,0,3],
                        [6,7,0,3,0,1,4,0,0,1],
                        [4,0,3,0,4,0,0,0,0,3],
                        [0,1,0,2,0,6,2,0,2,1]]
board10x10areas :: Board
board10x10areas = [[1,5,5,5,9,9,9,9,20,20],
                        [1,1,1,5,6,6,13,13,20,13],
                        [2,2,1,6,6,12,14,13,13,13],
                        [2,2,6,6,10,12,14,14,14,18],
                        [2,2,2,6,10,10,15,18,18,18],
                        [3,3,7,7,7,10,16,16,21,21],
                        [3,3,3,7,7,11,17,19,21,21],
                        [4,4,3,7,11,11,17,19,22,22],
                        [4,4,8,8,8,8,17,19,19,23],
                        [4,4,4,8,8,8,17,17,23,23]]

main = do

    putStr("\n---------\n")
    putStrLn "Board 6x6:"
    mapM_ print (solveBoard board6x6Values board6x6areas)
    putStr("\n---------\n")
    putStrLn "Board 8x8:"
    mapM_ print (solveBoard board8x8Values board8x8areas)
    putStr("\n---------\n")
    putStrLn "Board 10x10:"
    mapM_ print (solveBoard board10x10Values board10x10areas)
    
