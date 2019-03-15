## Objetivo do Projeto

Nesse projeto é realizado a raspagem, limpeza e análise dos dados da Assembléia Legislativa do Estado do Ceará visando extrair informações sobre o uso de verbas públicas pelos parlamentares no estado do Ceará.
Os dados são obtidos da página de dados abertos da assembleia legislativa nesse [link](https://www.al.ce.gov.br/index.php/transparencia/verba-de-desempenho-parlamentar).

Infelizmente os dados não apropriadamente disponibilizados em formatos amigáveis para análise (csv, XML, JSON etc), e alguém que deseja ter uma visão holística dos dados públicos necessitará de muito tempo e esforço, o que torna inviável essa análise. 

Dessa forma o projeto tem como principais objetivo: 

 * Tornar pública e facilmente acessível uma análise visual de como estão sendo direcionados os gastos públicos da assembleia legislativa cearense;
 * Ser uma fonte didática de guiar pessoas interessas nessas ações e motivar a comunidade Open Data a contribuir com diversos outros projetos;

Para fins didáticos, esse projeto é divido em três principais partes: 

 1. Raspagem dos dados (Web scraping)
 2. Limpeza dos dados 
 3. Visualização de dados

### Open Data Day Fortaleza

Esse projeto projeto será apresentado nas oficinas do encontro Open Data Day realizado em Fortaleza/CE no dia 23/03/2019. As oficinas serão dividias em três partes e ministradas por: 

 * [André Campos](https://www.linkedin.com/in/andreloc/)  (Raspagem de Dados)
 * [Riverson Rios](http://www.ica.ufc.br/index.php?nome=Jos%E9%20Riverson%20Ara%FAjo%20Cysne%20Rios&var=prof) (Limpeza de Dados)
 * [Emanuele Santos](https://www.linkedin.com/in/emanueles/) (Visualização de Dados)
 
 Maiores informações em: TODO

### Instalação e dependências

#### Docker

TODO

#### Linux

TODO

#### Windows

TODO

### Estrutura do projeto
A estrutura está descrita a seguir: 

```
.
└── open-data-assembleia-legislativa-ce
    ├── src
    │   ├── web-scrapping.R 
    │   ├── clean-data.R 
      ├── data 
      │   ├── raw 
      |   ├── temp 
      │   └── processed 
      ├── README.md 
      ├── run_analyses.R 
      ├── Dockerfile 
      └── .gitignore
```

TODO

### Adicional para aprendizado

#### Boas práticas de código
O projeto utiliza o seguinte padrão de código definido nesse [guia de estilo](http://r-pkgs.had.co.nz/style.html).

#### Boas práticas de projeto
O projeto segue o guia de boas práticas descrito nesse [link](https://www.r-bloggers.com/structuring-r-projects/).

#### Referências Úteis
TODO

 [Como Extrair Dados de Arquivos PDF](https://medium.com/@CharlesBordet/how-to-extract-and-clean-data-from-pdf-files-in-r-da11964e252e)
 
 [Curso de Web Scaping com R](http://material.curso-r.com/scrape/#passo-1-acessa-p%C3%A1gina-principal)
 
 [Como rodar seu ambiente R em Docker](http://material.curso-r.com/scrape/#passo-1-acessa-p%C3%A1gina-principal)
 
 
 
 
