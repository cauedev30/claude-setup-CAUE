---
name: projeto-loca
description: "Loca (SaaS de contratos de locação) — cópia de trabalho, base demo, e a decisão de não rotacionar as chaves"
metadata: 
  node_type: memory
  type: project
  originSessionId: d9c1e254-2617-49e9-b3ff-07a7c231f47e
  modified: 2026-08-10T23:34:52.408Z
---

Projeto Loca (`github.com/dv-dev1/loca`, Next.js 16 + Supabase), sócio de Cauê é
`pandadois10@gmail.com`. A nota `Projects/Active/Projeto Loca.md` no vault é a
fonte de verdade; o "For future Claude" no topo dela carrega o estado da última
sessão.

Três coisas que não dá para deduzir do repo:

1. **Cópia de trabalho única: `C:\Users\Administrator\Desktop\loca`.** Em
   2026-08-10 existiam quatro cópias na máquina e eu cheguei a clonar uma quinta
   antes de descobrir a certa. Confirme o caminho antes de clonar qualquer coisa.
2. **As chaves reais estão commitadas no repo público de propósito.** O sócio vai
   rotacionar. Não é pendência esquecida — foi decidido mais de uma vez. Não
   reabrir, não sugerir de novo, e **não tocar no `.env.local`**.
3. **O Supabase ligado é base de demonstração** (`Imobiliária Demo`, 1 org), não
   carteira de cliente real — confirmado pelo usuário em 2026-08-10. Dá para
   validar ao vivo criando dado próprio e apagando depois; ainda assim, não
   reaproveitar linha existente.

Armadilha de ambiente: rodar `next build` com `next dev` ativo derruba o dev
server (disputam o diretório `.next`). E `next dev` no Windows deixa processos
órfãos segurando a porta 3000 entre sessões — cheguei a achar quatro vivos há
três dias.

Ver [[um-passo-de-cada-vez]] e [[notas-sem-pendencia-arrastada]], que valem
bastante aqui.
