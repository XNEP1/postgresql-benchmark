# postgresql-benchmark
A implementation of the TPC-H benchmark for Postgresql 

Baixe o TPC-H e coloque os arquivos nas pastas dbgen, dev-tools e ref_data.
Compile o conteudo de dbgen/ por meio do makefile (não se esqueça de abrir ele e preencher os campos no começo).

Execute os scripts.

$ 1_init.sh: Usa o dbgen para criar os dados e queriers. Converte os valores gerados para csv válido. Fica tudo armazenado na pasta dss/.

$ 2_tpch.sh: Carrega o banco de dados e faz o benchmark. Armazena resultados na pasta results/.

$ 3_calMetrics.sh [numero do teste|null]: Calcula e imprime as métricas do TPC-H. Você pode escolher para qual resultado ele irá calcular ou deixe o parametro vazio para calcular as metricas para o ultimo benchmark.

$ 4_clean.sh: Remove os arquivos .o e executáveis de dbgen/ e limpa os dados na pasta dss/. Mas mantem os resultados em results/.
