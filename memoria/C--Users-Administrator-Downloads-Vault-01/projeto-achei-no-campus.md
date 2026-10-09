---
name: projeto-achei-no-campus
description: App de faculdade (Flutter+Firebase) do grupo Cauê/Daniel/Lúcio no repo dv-dev1/achei-no-campus; clone no Desktop com commit de docs aguardando push
metadata:
  node_type: memory
  type: project
  originSessionId: 7e0ebbed-ddca-44af-b1b6-5c06c069df68
  modified: 2026-10-06T02:18:13.888Z
---

Achados e perdidos da UNIPÊ, trabalho de disciplina. Repo `dv-dev1/achei-no-campus` (do Daniel, dv-dev1). Grupo: Daniel (base, Firebase, login, perfil, publicar), Cauê (tema, feed, filtros, busca, detalhe, devolvido + logo, Meus itens, chat), Lúcio (QA).

Em 2026-10-05: divisão do grupo PREVALECE sobre a spec do repo (que dizia "IA faz a base"). Docs `docs/divisao-de-tarefas.md` e `docs/escopo-detalhado.md` commitados (415b75a + c8766ed, branch `docs/divisao-de-tarefas`) no clone `Desktop\achei-no-campus`, virou colaborador e subiu como PR #1, já mergeado em 2026-10-05 (main = f7f562f).

Em 2026-10-06 o Daniel mudou o fluxo (c811455): commit e push DIRETO na main, sem PR. Flutter 3.47.6 instalado em 06/10 em C:\Users\Administrator\development\flutter (PATH do usuário). google_fonts fixo em ^8.2.1: a 9.0 usa material_ui e quebra com flutter/material. Ritmo: uma task por vez, avisar ao terminar antes de começar outra; cada parte ganha um guia humanizado em docs/.

Em 2026-10-06 o Daniel subiu a base (projeto Flutter com pubspec, emuladores, Sessao, firestore.rules + firestore-tests, CI). Desde então o repo roda `flutter analyze/test` sozinho, sem projeto temporário. Regras: `JAVA_HOME=C:\Program Files\Microsoft\jdk-21.0.12.101-hotspot`, depois `cd firestore-tests && npx --no-install firebase emulators:exec --config ../firebase.json --project demo-achei-no-campus --only auth,firestore "npm test"`. Antes de todo push, faça `git fetch` e confira se o Daniel subiu algo (o push de 06/10 foi recusado por isso; rebase resolveu). Todas as tasks do Cauê (1-8) feitas em 06/10. Logo = pino com mochila (dele, substitui a lupa+estrela da spec; cores ≠ tema, já avisado, não realertar). Ícone/splash regeneráveis por `dart run flutter_launcher_icons` + `dart run flutter_native_splash:create`; depois, conferir o diff (o gerador põe user-scalable=no no index.html e estraga uma opção do pbxproj).

Combinado 06/10: sobreposições com o código do Daniel NÃO se resolvem na hora; o grupo junta tudo e depois tira as diferenças. Aponte a sobreposição, mas não case com a dele sem ele pedir (ex.: Editar de Meus itens ficou só avisando de propósito).

**Why:** o combinado original (branch + PR) foi substituído pelo README do repo.
**How to apply:** `git pull --ff-only origin main` antes de editar; cheque `gh api repos/dv-dev1/achei-no-campus --jq .permissions.push`. Autor segue [[commits-repos-caue-autor-unico]]; padrão parecido com [[projeto-formula-de-impacto]].
