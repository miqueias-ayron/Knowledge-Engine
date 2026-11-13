# Knowledge Engine - Coffee Quality

Projeto da disciplina de Logica e Matematica Discreta que transforma avaliacoes de cafes em uma base de conhecimento Prolog. O ETL e executado em um Jupyter Notebook e as perguntas sao respondidas por regras Prolog.

## Dataset

Foi utilizado o [Coffee Quality Database from CQI](https://www.kaggle.com/datasets/volpatto/coffee-quality-database-from-cqi), que possui avaliacoes de qualidade feitas por especialistas do Coffee Quality Institute.

Para respeitar o requisito de uma unica tabela, o projeto usa somente `arabica_data_cleaned.csv`. O arquivo tambem esta disponivel no [repositorio publico original](https://github.com/jldbc/coffee-quality-database/blob/master/data/arabica_data_cleaned.csv).

O CSV possui 1.311 amostras de cafe arabica. O notebook seleciona campos de origem, variedade, processamento e notas sensoriais.

## Predicado principal

Cada linha valida do CSV gera um fato `cafe/9`:

```prolog
cafe(Id, Pais, Variedade, Processo, Aroma, Sabor, Acidez, Corpo, NotaTotal).
```

| Argumento | Coluna original | Tipo |
|---|---|---|
| `Id` | indice gerado pelo notebook | quantitativo |
| `Pais` | `Country.of.Origin` | qualitativo |
| `Variedade` | `Variety` | qualitativo |
| `Processo` | `Processing.Method` | qualitativo |
| `Aroma` | `Aroma` | quantitativo |
| `Sabor` | `Flavor` | quantitativo |
| `Acidez` | `Acidity` | quantitativo |
| `Corpo` | `Body` | quantitativo |
| `NotaTotal` | `Total.Cup.Points` | quantitativo |

Exemplo de fato gerado:

```prolog
cafe(1, ethiopia, desconhecido, washed_wet, 8.67, 8.83, 8.75, 8.50, 90.58).
```

Os textos sao convertidos para minusculas, sem acentos e com `_` no lugar de espacos. Campos textuais vazios recebem `desconhecido`. Linhas com notas numericas invalidas sao ignoradas.

## Estrutura do repositorio

```text
Knowledge-Engine/
|-- AGENTS.md
|-- README.md
|-- requirements.txt
|-- etl.ipynb
|-- data/
|   `-- raw/
|       `-- arabica_data_cleaned.csv
`-- prolog/
    |-- base_conhecimento.pl
    `-- consultas.pl
```

## Requisitos

- Python 3.10 ou superior
- Jupyter Notebook
- Pandas
- SWI-Prolog

Para instalar as dependencias:

```bash
python -m pip install -r requirements.txt
```

O SWI-Prolog pode ser obtido em [swi-prolog.org](https://www.swi-prolog.org/download/stable).

## Como executar o ETL

Na raiz do repositorio, inicie o Jupyter:

```bash
jupyter notebook etl.ipynb
```

No notebook, execute todas as celulas em ordem. Ele realiza quatro passos simples:

1. le e apresenta o CSV;
2. seleciona e limpa os nove campos;
3. converte cada linha em um fato `cafe/9`;
4. gera `prolog/base_conhecimento.pl`.

Na execucao atual foram lidas 1.311 linhas, gerados 1.311 fatos e nenhuma linha foi ignorada.

## Como executar as consultas

Depois de executar o notebook, abra o arquivo de consultas:

```bash
swipl -s prolog/consultas.pl
```

### Pergunta 1

Qual e o ranking dos paises pela media da nota total, considerando apenas paises com pelo menos 20 amostras?

```prolog
?- ranking_paises(Ranking).
```

Primeiros resultados:

```text
85.48-ethiopia-44
84.31-kenya-25
84.05-uganda-26
83.11-colombia-183
83.05-el_salvador-21
```

Cada resultado segue o formato `Media-Pais-Quantidade`.

### Pergunta 2

Qual e o ranking dos metodos de processamento pela media da nota total, considerando apenas metodos com pelo menos 20 amostras?

```prolog
?- ranking_processos(Ranking).
```

Resultado:

```text
82.63-semi_washed_semi_pulped-56
82.42-desconhecido-152
82.35-natural_dry-251
81.96-washed_wet-812
81.28-other-26
```

Cada resultado segue o formato `Media-Processo-Quantidade`.

### Pergunta 3

Quais cafes possuem nota total, aroma, sabor e acidez acima das respectivas medias gerais?

Para visualizar os cinco primeiros:

```prolog
?- cafes_acima_das_medias([A, B, C, D, E | _]).
```

Primeiros resultados:

```text
90.58-1-ethiopia-desconhecido-washed_wet-8.67-8.83-8.75
89.92-2-ethiopia-other-washed_wet-8.75-8.67-8.58
89.75-3-guatemala-bourbon-desconhecido-8.42-8.50-8.42
89.00-4-ethiopia-desconhecido-natural_dry-8.17-8.58-8.42
88.83-6-brazil-desconhecido-natural_dry-8.58-8.42-8.50
```

Foram encontrados 421 cafes que atendem aos quatro criterios. O formato de cada item e `NotaTotal-Id-Pais-Variedade-Processo-Aroma-Sabor-Acidez`.

Para obter a lista completa:

```prolog
?- cafes_acima_das_medias(Ranking).
```

## Tecnicas de Prolog utilizadas

As consultas usam apenas predicados basicos apresentados ou relacionados ao conteudo da disciplina:

- `findall/3` para montar listas;
- `sum_list/2` e `length/2` para calcular medias;
- comparacoes numericas;
- `setof/3` para remover repeticoes;
- `sort/2` e `reverse/2` para ordenar os rankings;
- predicados auxiliares para separar cada etapa do calculo.
