# Tornando uma aplicação observável
Nesta aula você vai configurar sua aplicação e adicionar as dependências necessárias para que o Prometheus tenha visibilidade do status de Health, Info e Metrics da aplicação.</br>


### Dados populados no banco</br>
Na sua configuração você populou o banco com 3 topicos, que podem ser visualizados pelas urls abaixo:
* http://localhost:8080/topicos
* http://localhost:8080/topicos/1
* http://localhost:8080/topicos/2
* http://localhost:8080/topicos/3

### Configurando o Actuator</br>
Neste passo você deve adicionar as dependências do Actuator na aplicação para que ele externalize as informações que precisamos aplicar a observabilidade. Antes de tudo pare a aplicação que está rodando no Screen:
```
$ screen -r java-up
```
Aperte CTRL + C + D para encerrar a sessão screen.
</br>
As dependências podem ser encontradas na documentação oficial do <a href="https://spring.io/guides/gs/spring-boot/">spring.io</a>. Não se esqueça que você deve usar a que for compatível com Maven.</br>

Adicione a dependência ao arquivo pom.xml localizado no path "~/api/api/pom.xml":
```
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-actuator</artifactId>
		</dependency>
```
</br>
Após isso você também precisa adicionar os properties para que o Actuator externalize as informações de Health, Info e Metrics da aplicação.
Essa alteração deve ser feita no arquivo "~/api/app/src/main/resources/application-prod.properties":
```
# actuator
management.endpoint.health.show-details=always
management.endpoints.web.exposure.include=health,info,metrics
```
</br>

Ao finalizar as configurações você deve recompilar a API com o maven e inicializá-la novamente.
```
$ mvn clean package
$ screen -S java-up -dm bash -c '~/api/app; sh start.sh'
```
Você deve ser capaz de ver agora a página do actuator:
* http://localhost:8080/actuator
* http://localhost:8080/actuator/health
* http://localhost:8080/actuator/info
* http://localhost:8080/actuator/metrics

Para ver uma métrica específica basta acrescentar /<nome-da-metrica> na url do metrics, por exemplo:
* http://localhost:8080/actuator/metrics/jvm.memory.used

### Configurando o Micrometer</br>

Neste passo vamos traduzir as informações que externalizamos com o Actuator para um formato que o Prometheus consiga interpretar, para isso vamos utilizar o Micrometer.
Para configurar o Micrometer você precisa primeiro adicionar a dependência no pom.xml, que você pode encontrar na documentação oficial do <a href="https://micrometer.io/docs/installing">Micrometer</a>:
```
<dependency>
  <groupId>io.micrometer</groupId>
  <artifactId>micrometer-registry-prometheus</artifactId>
  <version>${micrometer.version}</version>
</dependency>
```
</br>
Após configurar a dependência, é necessário adicionar também as propriedades no application-prod.properties.
Primeiro externalize o endpoint do Prometheys na configuração do actuator:

```
management.endpoints.web.exposure.include=health,info,metrics, prometheus
```

Em seguida configure as metricas e SLA para o Prometheus:

```
# promeutheus
management.metrics.enable.jvm=true
management.metrics.export.prometheus.enabled=true
management.metrics.distribution.sla.http.server.requests=50ms,100ms,200ms,300ms,500ms,1s
management.metrics.tags.application=app-forum-api
```

Ao finalizar aplique o comando para compilar o pacote novamente e suba a aplicação.</br>
Agora você poderá cessar a página do actuator novamente onde haverá o endpoint do Prometheus configurado.
* http://localhost:8080/actuator/prometheus
