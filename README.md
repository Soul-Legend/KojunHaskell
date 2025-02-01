# KojunHaskell
Repositorio com o código que resolve o puzzle de Kojun utilizando a linguagem Haskell

O Kojun é um quebra-cabeça lógico que consiste em uma grade de células, cada uma a ser preenchida sob um conjunto de regras. A primeira regra determina que cada célula da grade deve ser preenchida com um número de modo que cada região de tamanho N contenha cada número de 1 a N exatamente uma vez. Essa propriedade implica que a repetição de números numa mesma região é proibida. Em seguida, a segunda regra estabelece que números em células ortogonalmente adjacentes devem ser diferentes. A terceira regra especifica que, se duas células estiverem verticalmente adjacentes na mesma região, o número na célula superior deve ser maior que o número na célula inferior.

![image](https://github.com/user-attachments/assets/a633f903-5a54-4c62-9a71-050e665adf3b)

## Descrição da solução
A solução para o problema do jogo Kojun foi implementada em Haskell, distribuída em três módulos principais: Main, Matrix, e Solver. O módulo Main é responsável pela interação inicial, onde tabuleiros de diferentes tamanhos são definidos e impressos. Cada tabuleiro é definido com valores iniciais e uma matriz que indica a área pertencente a cada célula, facilitando a verificação de restrições específicas de grupo.

### Módulo Matrix
No módulo Matrix, o tabuleiro é representado como uma matriz de inteiros (type Board = Matrix Int), onde cada célula pode conter um número inteiro representando um valor já conhecido ou zero para indicar que o valor é desconhecido.

A função areaSize calcula o tamanho de um grupo específico na matriz de grupos, contando a quantidade de ocorrências do grupo em questão. Esta informação é utilizada para determinar o conjunto de números possíveis que podem ser colocados em uma célula vazia. Para isso baseando-se no número máximo de elementos que o grupo pode conter. Esta propriedade é particularmente útil no processo de inicialização das escolhas no Solver, onde a função choices aplica o resultado de areaSize para restringir o conjunto inicial de números possíveis para cada célula.

A associação de células aos seus respectivos grupos é representada por uma matriz chamada Board, onde cada entrada é um inteiro que especifica o grupo ao qual a célula pertence. A função areaMatrix processa a matriz de valores e a matriz de áreas em conjunto. Utiliza-se a função zipWith zip para combinar correspondentes valores e áreas em pares (valor, área), resultando em uma lista de pares para cada linha da matriz. Essa lista é passada como parâmetro para a função pura concat, que por conseguinte executa o processo de achatamento, tornando-a uma única lista de pares para a totalidade do tabuleiro. A seguir os valores são agrupados por área utilizando compreensões de lista que filtram esta lista combinada por área única, que são extraídas e mantidas em uma lista uniqueAreas obtida através da função nub aplicada aos identificadores de área nos pares.

Cada grupo de valores é assim isolado e disponibilizado como uma submatriz dentro da lista de matrizes retornada por areaMatrix, permitindo que operações como verificação de duplicidade, ordenação e redução de escolhas sejam aplicadas a cada grupo específico.

### Módulo Solver
O core da solução está no módulo Solver, que emprega técnicas de backtracking para resolver o tabuleiro. A função solveBoard configura a integração de todas as operações, começando com a geração de escolhas possíveis para cada célula vazia através da função choices. Esta função determina as escolhas possíveis para uma célula, levando em consideração os valores permitidos pelo grupo ao qual a célula pertence, subtraindo os valores já presentes no grupo dos valores possíveis de 1 ao tamanho do grupo.

A função (reduceChoicesByArea) refina as escolhas de cada célula, processando as colunas que foram organizadas por grupos. Esta etapa reduz o espaço de busca, aplicando restrições baseadas nos valores únicos já determinados nas células de cada grupo. 

O processo de busca por uma solução (searchSolution) é então realizado. Esta que por sua vez caracteriza-se pela recursão e continua a buscar soluções ao expandir as escolhas das células com múltiplas possibilidades. A expansão é gerida pela função generateChoicesMatrices, a qual gera novas matrizes de escolhas para cada possibilidade, permitindo o algoritmo explorar diferentes caminhos de solução.

O controle de expansão de escolhas é realizado pela função generateChoicesMatrices. Quando a função searchSolution encontra uma célula com múltiplas opções, generateChoicesMatrices gera uma lista de novas matrizes de escolhas, cada uma representando uma possível direção a seguir no espaço de busca. Garantindo que todas as possíveis progressões sejam consideradas.

A validação do estado atual do tabuleiro é constantemente realizada por funções como valid, que verifica a ausência de duplicatas em vizinhos nas colunas e linhas, e descendingOrder, que assegura que os valores dentro dos grupos estejam em ordem decrescente. As funções neighborValid, rowValid, e descendingOrder garantem que cada passo dado na busca pela solução respeite as regras do Kojun. neighborValid verifica a ausência de duplicatas em células adjacentes, enquanto rowValid assegura que não haja números duplicados em qualquer linha ou grupo. A função descendingOrder é usada para verificar que os valores dentro de cada coluna de grupo estejam em ordem decrescente. Essas verificações são aplicadas a cada nova configuração de tabuleiro gerada durante o processo de busca, descartando imediatamente as configurações inválidas e, assim, reduzindo o espaço de busca de soluções.

## Input do código
Para resolver uma nova configuração de tabuleiro o usuário deve informar no arquivo board.hs a matriz que representa os valores iniciais do Kojun a serem resolvidos e também deve-se colocar no arquivo as áreas do tabuleiro, como pode ser observado na figura 2. Os espaços em branco são representados com 0.

![image](https://github.com/user-attachments/assets/b7dce96e-a607-46b3-81f2-0fc6caa5d21c)

Além disso, o usuário também deve incluir o tabuleiro no arquivo main.hs para realizar o print da solução do board desejado conforme a figura 3 demonstra.

![image](https://github.com/user-attachments/assets/a51fe290-f4b0-45f9-9da3-d43e5e496a18)

## ✒️ Autores
* ##### [Vitor Praxedes Calegari](https://github.com/Vitor-Calegari)
* ##### [Pedro Henrique Taglialenha](https://github.com/Soul-Legend)


