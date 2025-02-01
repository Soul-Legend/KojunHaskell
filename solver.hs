module Solver where

import Matrix
import Data.List

-- Define uma lista de valores possíveis para cada célula.
type Choices = [Value]

-- Resolve o tabuleiro de Sudoku retornando a primeira solução completa encontrada.
-- Utiliza a função 'searchSolution' para encontrar a solução válida reduzindo as escolhas possíveis.
solveBoard :: Board -> Board -> Board
solveBoard values areas = (searchSolution (reduceChoicesByArea (choices values areas) areas) areas) !! 0

-- Gera uma matriz de escolhas, onde células sem valores definidos recebem todas as opções possíveis para o grupo.
choices :: Board -> Board -> Matrix Choices
choices values areas = map (map determineChoices) (zipWith zip values areas)
  where
    -- Determina as escolhas possíveis para uma célula, baseando-se nos valores permitidos pelo grupo.
    -- Se a célula já tem um valor, a escolha é esse valor. Caso contrário, gera todas as opções possíveis menos os valores já utilizados no grupo.
    determineChoices (v, area) = if v == 0 
                                  then [1 .. (areaSize area areas)] `minus` (valuesByArea values areas area) 
                                  else [v]

-- Reduz o conjunto de escolhas de acordo com as restrições dos grupos em cada coluna.
-- Processa cada coluna dividida em grupos e aplica a redução com base nas células com valores únicos.
reduceChoicesByArea :: Matrix Choices -> Board -> Matrix Choices
reduceChoicesByArea choicesMatrix areas = columns $ originalColumns (map reduceChoicesList (columnsByArea choicesMatrix areas)) (size choicesMatrix)

-- Aplica redução nas escolhas, removendo valores já determinados nas células únicas.
-- Para cada célula, remove os valores que já são únicos em outras células da mesma linha.
reduceChoicesList :: Row Choices -> Row Choices
reduceChoicesList choicesRow = [choices `minus` singleValues | choices <- choicesRow]
  where
    -- Coleta todos os valores únicos presentes nas células da linha.
    singleValues = concat (filter singleElement choicesRow)

-- Remove os elementos de 'toRemove' de 'choices' se 'choices' não for uma célula com valor único.
minus :: Choices -> Choices -> Choices
choices `minus` toRemove = if singleElement choices then choices else choices \\ toRemove

-- Verifica se uma lista contém exatamente um elemento.
singleElement :: [a] -> Bool
singleElement [_] = True
singleElement _ = False

-- Busca por todas as soluções possíveis para o tabuleiro aplicando redução e expansão das escolhas.
-- A função continua a buscar soluções recursivamente até encontrar uma válida ou determinar que não há solução.
searchSolution :: Matrix Choices -> Board -> [Board]
searchSolution choicesMatrix areas
  -- Se a matriz de escolhas é impossível, retorna uma lista vazia.
  | impossible choicesMatrix areas = []
  -- Se todas as células têm um valor único, a solução é válida e é retornada.
  | all (all singleElement) choicesMatrix = [map concat choicesMatrix]
  -- Caso contrário, expande as escolhas e continua a busca recursivamente.
  | otherwise = [solution | expandedChoices <- expandChoices choicesMatrix, solution <- searchSolution (reduceChoicesByArea expandedChoices areas) areas]

-- Determina se a matriz de escolhas não possui solução viável.
-- Verifica se há células sem escolhas possíveis ou se a matriz não é válida.
impossible :: Matrix Choices -> Board -> Bool
impossible choicesMatrix areas = empty choicesMatrix || not (valid choicesMatrix areas)

-- Verifica se existe alguma célula sem possíveis valores (nula).
empty :: Matrix Choices -> Bool
empty matrix = any (any null) matrix

-- Verifica a validade da matriz com base nas seguintes regras:
-- 1. Não deve haver valores duplicados em vizinhos nas colunas.
-- 2. Não deve haver valores duplicados em vizinhos nas linhas.
-- 3. Não deve haver duplicatas dentro dos grupos.
-- 4. Os valores dentro dos grupos devem estar em ordem decrescente.
valid :: Matrix Choices -> Board -> Bool
valid choicesMatrix areas = all neighborValid (columns choicesMatrix) &&
                             all neighborValid (rows choicesMatrix) &&
                             all rowValid (areaMatrix choicesMatrix areas) &&
                             all descendingOrder (columnsByArea choicesMatrix areas)

-- Verifica se não há valores duplicados em células vizinhas nas colunas ou linhas.
-- Para cada par de células vizinhas, verifica se ambos têm valores únicos e se esses valores são diferentes.
neighborValid :: Eq a => Row [a] -> Bool
neighborValid [] = True
neighborValid [a] = True
neighborValid (a:b:rest)
  | (length a <= 1) && (length b <= 1) = if a == b then False else neighborValid (b:rest)
  | otherwise = neighborValid (b:rest)

-- Verifica se não há valores duplicados em uma linha da matriz.
-- Para cada célula, se tiver um valor único, verifica se não há duplicatas nas outras células da linha.
rowValid :: Eq a => Row [a] -> Bool
rowValid [] = True
rowValid (x:xs) = if (length x <= 1) then not (elem x xs) && rowValid xs else rowValid xs

-- Verifica se os valores nas colunas estão em ordem decrescente.
-- Para cada par de células vizinhas, se ambos têm valores únicos, verifica se estão em ordem decrescente.
descendingOrder :: Ord a => Row [a] -> Bool
descendingOrder [] = True
descendingOrder [a] = True
descendingOrder (a:b:rest)
  | (length a <= 1) && (length b <= 1) = if a < b then False else descendingOrder (b:rest)
  | otherwise = descendingOrder (b:rest)

-- Expande as escolhas na primeira célula que tem múltiplas opções, gerando novas matrizes para cada escolha.
-- Esta função gera todas as possíveis variações da matriz de escolhas com base nas opções de uma célula.
expandChoices :: Matrix Choices -> [Matrix Choices]
expandChoices matrix = [rowsBefore ++ [rowBefore ++ [choice] : rowAfter] ++ rowsAfter | choice <- choices]
  where
    -- Divide a matriz em partes até encontrar a célula com múltiplas opções.
    (rowsBefore, row:rowsAfter) = break (any (not . singleElement)) matrix
    (rowBefore, choices:rowAfter) = break (not . singleElement) row
