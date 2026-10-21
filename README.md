# Painel meteorológico público

Este repositório contém somente o frontend estático do painel. Os dados são consultados no Supabase e o acesso continua protegido por autenticação e aprovação de usuários.

## Publicação no GitHub Pages

1. Crie um repositório público no GitHub para estes arquivos.
2. Envie `index.html` para a branch `main`.
3. Em **Settings → Pages**, selecione a branch `main` e a pasta `/ (root)`.
4. No Supabase, em **Authentication → URL Configuration**, adicione o endereço publicado em **Site URL** e **Redirect URLs**.
5. Aguarde a publicação e valide login, solicitação de acesso e aprovação de usuário.

O frontend usa somente a chave **publishable** do Supabase, que é destinada a código público. Nunca coloque `SUPABASE_SECRET_KEY`, `service_role`, senhas ou tokens de bot neste repositório. O controle de acesso aos dados deve permanecer nas políticas RLS do Supabase.
