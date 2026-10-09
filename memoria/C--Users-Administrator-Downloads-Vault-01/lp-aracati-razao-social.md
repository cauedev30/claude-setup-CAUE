---
name: lp-aracati-razao-social
description: "LP Aracati usa razão social em CAIXA ALTA SEM acentos — o oposto do Macapá; grafia é por CNPJ, confirme caso a caso"
metadata: 
  node_type: memory
  type: project
  originSessionId: cc84f6c3-857e-4fc3-a3d4-cf804a2e72f7
  modified: 2026-08-13T16:53:48.432Z
---

Na LP do Cartão de Todos Aracati (`cauedev30/cdt-aracati-LP`, cópia local em `Downloads\cartaodetodos-aracati`) a razão social é `ADMINISTRADORA DE CARTOES DE DESCONTOS ARACATI LTDA` — caixa alta, **sem** acentos, a grafia do cartão CNPJ. Trocado e publicado em 2026-08-13, commit `57810d3`, deploy 38.

Deploy: app `cdt-aracati-lp` no painel Dokku, publica no **apex** `aracatice.online` (`subdomain` vazio, `mode: static`). Diferente do Macapá, o app já está visível no `list_apps` com o repo amarrado — o fluxo padrão roda limpo.

Isso é o **oposto** do que a Meta exigiu no Macapá (ver [[lp-macapa-razao-social]]), onde o pedido foi sair da caixa alta para a grafia acentuada.

**Why:** a grafia certa é a do cadastro de cada CNPJ, não um padrão do Cartão de Todos. Assumir que uma LP segue a outra leva a "corrigir" para o lado errado.

**How to apply:** ao mexer em razão social de qualquer LP, confirme a grafia daquele CNPJ com o usuário antes de editar — não replique o padrão de outra unidade. Vale também o [[um-passo-de-cada-vez]]: o resto do site continua sem acentos de propósito nas duas.
