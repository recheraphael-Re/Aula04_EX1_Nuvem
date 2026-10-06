# Define a imagem base que será utilizada pelo container

FROM eclipse-temurin:21-jdk


# Define o diretorio de trabalho dentro do container

# Os proximo comandos serao executados dentro da pasta /app

WORKDIR /app

# Copia o arquivo Main.java da maquina local para o diretorio /app do container 

COPY Main.java .


# Compila o codigo Java durante a criaçao da imagem

RUN javac Main.java 

#Define o comando que será executado automaticamente quando o container for criado a partir dessa imagem

CMD ["java", "Main"]