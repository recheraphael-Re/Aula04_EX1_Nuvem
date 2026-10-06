# Guia Aula04 EX1 - Nuvem

**Computação em Nuvem · Aula 04 · Exercício 1**
Criando e executando uma aplicação Java 21 dentro de um container Docker.

| | |
|---|---|
| Pasta | `C:\Users\Instrutor\Aula04_EX1_Nuvem` |
| Terminal | PowerShell (Windows) |
| Imagem base | `eclipse-temurin:21-jdk` |

> Versão formatada para impressão/PDF: [Guia aula04 EX1-Nuvem.html](Guia%20aula04%20EX1-Nuvem.html)
> (abra no navegador e use `Ctrl+P` → Salvar como PDF)

---

## 0. O que vamos fazer

O objetivo é empacotar um programa Java em uma **imagem Docker** e executá-lo em um
**container**, sem precisar instalar o Java na máquina — o Java já vem dentro da imagem.

| Arquivo | Função |
|---|---|
| `Main.java` | Código-fonte Java que imprime mensagens no terminal. |
| `Dockerfile` | Receita que ensina o Docker a montar a imagem: copiar, compilar e executar. |

**Imagem** é o "molde" (o pacote pronto, salvo em disco). **Container** é o molde em
execução. De uma imagem você pode criar vários containers.

---

## 1. Abrir o terminal na pasta do projeto

```powershell
cd C:\Users\Instrutor\Aula04_EX1_Nuvem
```

Confirme que os arquivos estão presentes:

```powershell
ls
```

Devem aparecer `Dockerfile` e `Main.java`.

> ⚠️ Se você não estiver dentro dessa pasta, o `docker build` falha com erro de arquivo
> não encontrado.

---

## 2. Verificar se o Docker está funcionando

```powershell
docker --version
```

```powershell
docker info
```

> ⚠️ Se aparecer *"cannot connect to the Docker daemon"* ou *"error during connect"*,
> abra o **Docker Desktop**, aguarde o ícone da baleia ficar estável e rode `docker info`
> novamente.

---

## 3. Entender o Dockerfile

```dockerfile
# Imagem base: já vem com o JDK 21 instalado
FROM eclipse-temurin:21-jdk

# Diretório de trabalho dentro do container
WORKDIR /app

# Copia Main.java da máquina local para /app no container
COPY Main.java .

# Compila o código durante a CRIAÇÃO da imagem (gera Main.class)
RUN javac Main.java

# Comando executado quando o container é iniciado
CMD ["java", "Main"]
```

| Instrução | Quando roda | O que faz |
|---|---|---|
| `FROM` | build | Define a imagem base (sistema + JDK 21). |
| `WORKDIR` | build | Cria e entra na pasta `/app`. |
| `COPY` | build | Leva o arquivo do seu PC para dentro da imagem. |
| `RUN` | build | Executa a compilação e grava o resultado na imagem. |
| `CMD` | run | Comando padrão ao iniciar o container. |

---

## 4. Construir a imagem

```powershell
docker build -t aula04-java .
```

- `-t aula04-java` — dá um nome (tag) à imagem.
- `.` — o ponto final indica o **contexto de build**: a pasta atual. É obrigatório, e
  esquecê-lo é o erro mais comum.

Durante o build aparecem as etapas `[1/4] FROM`, `[2/4] WORKDIR`, `[3/4] COPY`,
`[4/4] RUN javac`. No final:

```
=> naming to docker.io/library/aula04-java
```

> Na primeira execução o download da imagem base (~300 MB) pode demorar. Nas próximas
> vezes o Docker reaproveita o cache e o build é quase instantâneo.

---

## 5. Conferir se a imagem foi criada

```powershell
docker images
```

A imagem `aula04-java` deve aparecer na lista, com a tag `latest`.

---

## 6. Executar o container

```powershell
docker run --rm aula04-java
```

`--rm` remove o container automaticamente ao terminar, evitando acúmulo de containers
parados na máquina.

**Saída esperada:**

```
============
Computação em nuvem - Aula 05
============
Olá Docker
Java 21 executando em um container
Prof Daniel Vieira
```

✅ Se apareceu isso, o código Java rodou dentro de um container isolado, usando o Java 21
que veio na imagem — não o da sua máquina.

---

## 7. Alterou o código? Refaça o build

O Java é compilado **durante o build**. Ao editar o `Main.java`, a imagem antiga continua
com o código velho. Rode os dois comandos na ordem:

```powershell
docker build -t aula04-java .
docker run --rm aula04-java
```

Para forçar tudo do zero, ignorando o cache:

```powershell
docker build --no-cache -t aula04-java .
```

---

## 8. Comandos úteis do dia a dia

| Comando | Para que serve |
|---|---|
| `docker ps` | Lista containers em execução. |
| `docker ps -a` | Lista todos os containers, inclusive os parados. |
| `docker images` | Lista as imagens salvas na máquina. |
| `docker run -it aula04-java bash` | Abre um terminal dentro do container para investigar. Saia com `exit`. |
| `docker rm <id>` | Remove um container parado. |
| `docker rmi aula04-java` | Remove a imagem. |
| `docker logs <id>` | Mostra a saída de um container já executado. |
| `docker system prune` | Limpa imagens/containers não utilizados (libera disco). |

---

## 9. Solução de problemas

| Mensagem | Causa | Solução |
|---|---|---|
| `cannot connect to the Docker daemon` | Docker Desktop fechado. | Abrir o Docker Desktop e aguardar iniciar. |
| `"docker build" requires exactly 1 argument` | Faltou o ponto final. | `docker build -t aula04-java .` |
| `failed to compute cache key: Main.java not found` | Terminal em outra pasta. | `cd C:\Users\Instrutor\Aula04_EX1_Nuvem` |
| `class Main is public, should be in a file named Main.java` | Nome do arquivo diferente do nome da classe. | O arquivo precisa se chamar exatamente `Main.java`. |
| `Could not find or load main class Main` | `CMD` com nome errado. | Deve ser `CMD ["java", "Main"]` (sem `.class`). |
| Saída antiga aparecendo | Imagem não reconstruída. | Rodar `docker build` de novo antes do `run`. |

---

## 10. Sequência completa (resumo)

```powershell
cd C:\Users\Instrutor\Aula04_EX1_Nuvem
ls
docker info
docker build -t aula04-java .
docker images
docker run --rm aula04-java
```

Esses seis comandos resolvem o exercício do início ao fim.
