# Métricas padrões e personalizadas
Nesta aula você vai entender as métricas padrões da JVM e criar algumas personalizadas.</br>

### Métricas padrões</br>

As métricas padrões são todas as que ja vem configuradas para monitorar a JVM e o uso de recursos do SO.</br>
Para entender o que cada métrica representa, antes é necessário entender a sintaxe delas:
```
<metric_name>{application="tag-app",} value
```
Por exemplo:
```
system_load_average_1m{application="app-forum-api",} 0.36083984375
```
</br>
Para visualizar isso melhor, podemos observar algumas métricas indispensáveis para o dia-a-dia:</br>

* Load Average: Monitora o load avg da VM.
```
system_load_average_1m{application="app-forum-api",} 0.36083984375
```

* JVM Threads State: Monitora o estado das threads na JVM.
```
jvm_threads_states_threads{application="app-forum-api",state="runnable",} 10.0
jvm_threads_states_threads{application="app-forum-api",state="waiting",} 13.0
jvm_threads_states_threads{application="app-forum-api",state="terminated",} 0.0
jvm_threads_states_threads{application="app-forum-api",state="timed-waiting",} 10.0
jvm_threads_states_threads{application="app-forum-api",state="blocked",} 0.0
jvm_threads_states_threads{application="app-forum-api",state="new",} 0.0
```

* Logback Events: Monitora os eventos (incidentes) em aberto.
```
logback_events_total{application="app-forum-api",level="info",} 28.0
logback_events_total{application="app-forum-api",level="trace",} 0.0
logback_events_total{application="app-forum-api",level="warn",} 2.0
logback_events_total{application="app-forum-api",level="error",} 0.0
logback_events_total{application="app-forum-api",level="debug",} 0.0
```

* Process Files Open Files: Monitora a quantidade de arquivos aberto pela JVM.
```
process_files_open_files{application="app-forum-api",} 31.0
```

* Hikaricp Connections Usage Seconds: Monitora o tempo da conexão da aplicação com o banco (em segundos).
```
hikaricp_connections_usage_seconds_count{application="app-forum-api",pool="HikariPool-1",} 2.0
hikaricp_connections_usage_seconds_sum{application="app-forum-api",pool="HikariPool-1",} 0.006
```
Há outras métricas de Hikaricp que monitoram outras coisas como, limite de conexões, conexões minimas para o sistema subir, etc.</br>

* System CPU Usage: Monitora o uso de CPU pelo sistema.
```
system_cpu_usage{application="app-forum-api",} 0.07462979950203119
```

* JVM Memory Usage: Monitora a quantidade de memória usada e sua área de uso "heap" ou "nonheap".
```
jvm_memory_used_bytes{application="app-forum-api",area="nonheap",id="Compressed Class Space",} 1.1171088E7
jvm_memory_used_bytes{application="app-forum-api",area="nonheap",id="CodeHeap 'profiled nmethods'",} 1.283008E7
jvm_memory_used_bytes{application="app-forum-api",area="heap",id="G1 Survivor Space",} 4194304.0
jvm_memory_used_bytes{application="app-forum-api",area="heap",id="G1 Old Gen",} 3.2845312E7
jvm_memory_used_bytes{application="app-forum-api",area="nonheap",id="Metaspace",} 8.16364E7
jvm_memory_used_bytes{application="app-forum-api",area="nonheap",id="CodeHeap 'non-nmethods'",} 1422592.0
jvm_memory_used_bytes{application="app-forum-api",area="heap",id="G1 Eden Space",} 4.9283072E7
jvm_memory_used_bytes{application="app-forum-api",area="nonheap",id="CodeHeap 'non-profiled nmethods'",} 3261184.0
```

* HTTP Server Requests Seconds Bucket: Monitora o status e tempo de resposta das requisições realizadas para a API (relacionada a propriedade de SLA que colocamos).
```
http_server_requests_seconds_bucket{application="app-forum-api",exception="None",method="GET",outcome="SUCCESS",status="200",uri="/topicos/{id}",le="0.05",} 0.0
http_server_requests_seconds_bucket{application="app-forum-api",exception="None",method="GET",outcome="SUCCESS",status="200",uri="/topicos/{id}",le="0.1",} 0.0
http_server_requests_seconds_bucket{application="app-forum-api",exception="None",method="GET",outcome="SUCCESS",status="200",uri="/topicos/{id}",le="0.2",} 1.0
http_server_requests_seconds_bucket{application="app-forum-api",exception="None",method="GET",outcome="SUCCESS",status="200",uri="/topicos/{id}",le="0.3",} 1.0
http_server_requests_seconds_bucket{application="app-forum-api",exception="None",method="GET",outcome="SUCCESS",status="200",uri="/topicos/{id}",le="0.5",} 1.0
http_server_requests_seconds_bucket{application="app-forum-api",exception="None",method="GET",outcome="SUCCESS",status="200",uri="/topicos/{id}",le="1.0",} 1.0
http_server_requests_seconds_bucket{application="app-forum-api",exception="None",method="GET",outcome="SUCCESS",status="200",uri="/topicos/{id}",le="+Inf",} 1.0
http_server_requests_seconds_count{application="app-forum-api",exception="None",method="GET",outcome="SUCCESS",status="200",uri="/topicos/{id}",} 1.0
http_server_requests_seconds_sum{application="app-forum-api",exception="None",method="GET",outcome="SUCCESS",status="200",uri="/topicos/{id}",} 0.161489462
```