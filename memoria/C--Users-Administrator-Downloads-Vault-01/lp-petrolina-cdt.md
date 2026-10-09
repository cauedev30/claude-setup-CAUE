---
name: lp-petrolina-cdt
description: LP de Petrolina é Cartão de Todos (não Amor Saúde); remarcada e publicada em 2026-08-17 no app cdt-petrolina-lp
metadata: 
  node_type: memory
  type: project
  originSessionId: de4536cf-46cb-45fd-9a18-03b1b380581d
  modified: 2026-08-17T20:18:28.762Z
---

A unidade de Petrolina é **Cartão de Todos**, não Amor Saúde. O site tinha sido gerado com a marca errada e foi remarcado em 2026-08-17.

| Campo | Valor |
|---|---|
| Razão social | ADM PE ADMINISTRADORA DE CARTAO DE PETROLINA LTDA |
| CNPJ | 34.308.902/0001-01 |
| Endereço | R. Tobias Barreto, 48, Centro, Petrolina - PE, CEP 56.304-210 |
| Telefone | (81) 3196-0138 |
| Domínio | saudepetrolinape.online (apex) — nome legado, sem `cartaodetodos`; não existe domínio CDT para Petrolina |
| App Dokku | `cdt-petrolina-lp` |
| Repo | `cauedev30/cdt-petrolina-lp` (renomeado de `ams-petrolina-lp`) |

Grafia no padrão Aracati: razão social em CAIXA ALTA sem acentos, marca "Cartão de Todos" acentuada, corpo do site acentuado (difere de Aracati/Gravatá, que são sem acento). Ver [[lp-aracati-razao-social]] e [[lp-macapa-razao-social]].

**Layout:** mantém o "Ultra-Premium Design System" multi-arquivo (`index.html` + `style.css` + `script.js`), diferente do template single-file de Aracati/Gravatá. Hero usa `var(--gradient-mesh)` em vez de imagem; carrossel do Sobre e seção Galeria foram removidos porque **não existe nenhuma foto da unidade de Petrolina** — as 4 imagens originais eram branding Amor Saúde e uma era foto de uma unidade de João Pessoa - PB. Se aparecerem fotos reais da unidade, dá pra restaurar essas seções.

**Franqueadora nas páginas legais:** TODOS EMPREENDIMENTOS LTDA, CNPJ 04.644.515/0001-85, operadora do Cartão de Todos. Esse dado já estava no repo; a camada removida foi a da AMOR SAÚDE LTDA (CNPJ 27.602.235/0001-00), que era a franqueadora errada.

**Pendências deixadas em aberto em 2026-08-17:**
- Repo foi deixado **público** para o tarball baixar (ver [[painel-dokku-mcp-deploy-lps]]). Se voltar a privado, o deploy quebra de novo.
- App órfão `ams-petrolina-lp` continua no painel, sem domínio, com os arquivos antigos.
- Monitor do `cdt-petrolina-lp` pode ter ficado desligado.

**Contexto:** o site existe por exigência da Meta (campo de site nos templates do WhatsApp Business); em 2026-08-17 a Meta estava aguardando o site no ar para dar continuidade a uma verificação.
