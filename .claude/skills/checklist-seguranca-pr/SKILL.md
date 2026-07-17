---
nome: checklist-seguranca-pr
descricao: Checklist de segurança para revisão de Pull Requests. Usar sempre que analisar mudanças de código quanto a secrets, injeção, permissões e dependências vulneráveis.
---

# Checklist de Segurança para PRs

1. Nenhuma credencial, chave de API ou token aparece em texto plano no diff.
2. Toda entrada externa (parâmetros de rota, corpo de requisição, query string)
   é validada antes do uso.
3. Consultas a banco de dados usam parametrização, nunca concatenação de string.
4. Mudanças em permissões ou escopos de acesso vêm com justificativa explícita
   na descrição do PR.
5. Dependências novas não têm CVE conhecida aberta (verificar em
   https://osv.dev ou `pip-audit` / `npm audit`).
