
### Conteinerizando a aplicação

Daqui pra frente vamos focar no grafana e prometheus. Para fechar o ciclo das configurações da aplicação, vamos anexa-la no contexto do Docker.
Para isso basta modificar dois valores no arquivo "~/api/app/src/main/resources/application-prod.properties". Vamos modificar a linha 5 e a linha 10 do arquivo:

```
# spring.redis.host=localhost
spring.redis.host=redis-forum-api

# spring.datasource.url=jdbc:mysql://localhost:3306/forum
spring.datasource.url=jdbc:mysql://mysql-forum-api:3306/forum

```
</br>
Agora crie faça a cópia dos arquivos de configuração do Proxy e do Prometheus e siga com as configurações abaixo:</br>
- ./api/prometheus/prometheus.yml</br>
- ./api/nginx/nginx.conf</br>
- ./api/nginx/proxy.conf</br>

</br>
Por fim vamos adicionar algumas configurações no nosso arquivo do docker-compose:

- Adicione as redes internas para a comunicação da aplicação com o mysql, redis, proxy e o prometheus:
```
	networks:
	database:
		internal: true
	cache:
		internal: true
	api:
		internal: true
	monit:
	proxy:
```
</br>
- Modifique a porta e a rede do container do redis (antes era feito um bind de porta, agora vamos fazer um expose):

```
    expose:
      - 6379
    networks:
      - cache
```
</br>
- Repita o processo de mudança nas portas e rede para o container de mysql:

```
    expose:
      - 3306
    networks:
      - database
```
</br>
- Agora vamos criar um container para a aplicação (coloque essas configurações no final do arquivo):

```
  app-forum-api:
    build:
      context: ./app/
      dockerfile: Dockerfile
    image: app-forum-api
    container_name: app-forum-api
    restart: unless-stopped
    networks:
      - api
      - database
      - cache
    depends_on:
      - mysql-forum-api
    healthcheck:
      test: "curl -s5 http://app-forum-api:8080/actuator/health"
      interval: 1s
      timeout: 30s
      retries: 60
```
</br>
- Crie um container para o proxy:

```
  proxy-forum-api:
  	image: nginx
    container_name: proxy-forum-api
    restart: unless-stopped
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./nginx/nginx.conf:/etc/nginx/conf.d/proxy.conf
    ports:
      - 80:80
    networks:
      - proxy
      - api
    depends_on:
      - app-forum-api
```
</br>
- Para concluir vamos criar um container dedicado para o prometheus:

```
  prometheus-forum-api:
    image: prom/prometheus:latest
    container_name: prometheus-forum-api
    restar: unless-stopped
    volumes:
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
      - ./prometheus/prometheus_data:/prometheus
    commnad:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/etc/prometheus/console_libraries'
      - '--web.console.templates=/etc/prometheus/consoles'
      - '--web.enable-lifecycle'
    ports:
      - 9090:9090
    netwoks:
      - monit
      - api
```