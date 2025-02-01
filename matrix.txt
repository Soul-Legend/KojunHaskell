module Matrix where

import Data.List

-- cada linha é uma lista de elementos
type Matrix a = [Row a]
type Row a = [a]
type Value = Int


-- Retorna as colunas da matriz, divididas em blocos conforme os grupos.
-- A função processa cada coluna da matriz, associando valores e grupos, e agrupa os elementos por grupo.
columnsByArea :: Eq a => Matrix a -> Board -> [Row a]
columnsByArea values areas = zipWith zip (columns values) (columns areas) >>= map (map fst) . groupBy (\a b -> snd a == snd b)

-- Calcula o tamanho de um grupo específico na matriz de grupos, contando a quantidade de ocorrências do grupo.
areaSize :: Eq a => a -> Matrix a -> Int
areaSize areaId areas = sum [countOccurrences areaId areaRow | areaRow <- areas]
  where
    -- Conta quantas vezes o identificador de grupo aparece em uma linha.
    countOccurrences x xs = length (filter (== x) xs)

-- Define o tabuleiro como uma matriz de valores.
type Board = Matrix Value

-- Retorna a dimensão baseada na primeira linha se a matriz for quadrada.
size :: Matrix a -> Int
size matrix = length (matrix !! 0)

-- Retorna todas as linhas da matriz sem alteração.
rows :: Matrix a -> [Row a]
rows r = r

-- Transpõe as linhas da matriz para obter as colunas.
columns :: Matrix a -> [Row a]
columns matrix = transpose matrix

-- Restaura as colunas originais da matriz de valores a partir das sublistas de blocos,
-- reagrupando os elementos na ordem original.
originalColumns :: [Row a] -> Int -> [Row a]
originalColumns blockColumns n = segmentList n (concat blockColumns)

-- Divide uma lista em sublistas de tamanho especificado 'n', processando até que todos os elementos sejam agrupados.
segmentList :: Int -> [a] -> [[a]]
segmentList n = takeWhile (not . null) . map (take n) . iterate (drop n)

-- Agrupa os elementos de uma matriz de valores conforme especificado pela matriz que define os grupos
-- A função combina cada elemento com seu grupo correspondente e os organiza por grupo.
areaMatrix :: Eq a => Matrix a -> Board -> Matrix a
areaMatrix values areas = [filterByArea area combinedValues | area <- uniqueAreas]
  where
    -- Combina os elementos e seus grupos em pares (valor, area).
    combinedValues = concat (zipWith zip values areas)
    -- Identifica todos os grupos únicos presentes na matriz de areas.
    uniqueAreas = nub (map snd combinedValues)
    -- Filtra os pares para retornar apenas os elementos que pertencem ao grupo especificado.
    filterByArea area list = map fst $ filter ((== area) . snd) list

-- Filtra e retorna todos os valores pertencentes a um grupo específico, identificados por 'groupId'.
valuesByArea :: Eq a => Matrix a -> Board -> Int -> [a]
valuesByArea values areas areaId = map fst $ filter ((== areaId) . snd) combinedValues
  where
    -- Combina elementos com seus grupos em pares (valor, grupo).
    combinedValues = concat (zipWith zip values areas)
