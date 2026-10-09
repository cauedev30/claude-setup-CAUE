---
name: kotlin-java-ambiente-local
description: "Como compilar e rodar Kotlin nesta máquina - JDK 21 instalado, kotlinc avulso em Downloads e fora do PATH"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 51432b95-bb10-40b3-a480-7f780ddb1864
  modified: 2026-09-17T23:12:03.731Z
---

Instalado em 2026-09-17 para rodar exercício de faculdade em Kotlin.

- **JDK 21**: `C:\Program Files\Microsoft\jdk-21.0.12.101-hotspot` (via `winget install Microsoft.OpenJDK.21`). O `java` NÃO está no PATH do sistema.
- **Compilador Kotlin 2.4.20**: extraído em `C:\Users\Administrator\Downloads\kotlinc` (zip baixado do GitHub JetBrains/kotlin, winget não tem esse pacote). Também fora do PATH.

Receita que funciona no PowerShell 5.1, a partir da pasta do `.kt`:

```powershell
$env:JAVA_HOME = "C:\Program Files\Microsoft\jdk-21.0.12.101-hotspot"
$env:PATH = "$env:JAVA_HOME\bin;C:\Users\Administrator\Downloads\kotlinc\bin;$env:PATH"
kotlinc.bat Main.kt -include-runtime -d app.jar
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
java "-Dstdout.encoding=UTF-8" -jar app.jar
```

As duas últimas linhas são obrigatórias para os acentos saírem certos no console. Sem `-Dstdout.encoding=UTF-8` o Java usa a codificação nativa do Windows e quebra ç/ã/é.

Ver [[aula-java-repo-apsii]].
