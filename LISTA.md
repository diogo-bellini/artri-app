# Análise Aplicativo Artri App

## [Gravação de Tela da Análise](https://drive.google.com/file/d/1KuRSmCwUd7bXKSJmr49VVQo9xFHW6Eit/view?usp=sharing)

## Bugs Identificados

- Autenticação e Cadastro
    - Falha na recuperação de senha: A função "Esqueci minha senha" não tem ação. Além disso, após inserir o e-mail na área de cadastro, a tela não redireciona de volta para o login.
    - Cadastro: Nenhum e-mail é recebido ao tentar realizar um novo cadastro.
    - Feedback de Login ausente: Tentar logar com usuário/senha incorretos, ou deixar um dos campos vazios, não gera nenhum alerta ou mensagem de erro para o usuário (o app simplesmente não faz nada).
    - Gestão de Sessão: O aplicativo não mantém o usuário logado de forma persistente. Se o app for pausado ou colocado em segundo plano, o usuário é deslogado.
- Navegação e Interface (UI/UX)
    - Botões sem ação: Os botões "Exercícios" (na Home), de Play (dos exercícios), "?" e "+" na área de medicamentos não funcionam.
    - Navegação quebrada (Voltar): O botão ou ação de "Voltar" não funciona na página de Registro nem na área de Tratamentos.
    - Scroll bloqueado/inexistente: Nas telas de seleção de "Dor" e "Inchaço", e no alerta de início de exercícios, não é possível fazer scroll para baixo. Isso esconde botões críticos, impossibilitando clicar em "Salvar" ou "Concordar".
    - Problemas de Responsividade/Orientação da Tela: O aplicativo quebra completamente ao mudar a orientação do celular. Scrolls param de funcionar, ocorrem alertas de overflow de pixels e elementos (textos/gráficos) ficam mal formatados. O app não se recupera mesmo voltando para a orientação original.
    - Formatação de Texto: Textos quebrados ou mal formatados nos seguintes locais: título de exercícios físicos, área de "Informações sobre atividades físicas", e nos níveis de exercícios (iniciante, intermediário e avançado). Além disso, seria interessante rever o tamanho das fontes no aplicativo todo, uma vez que em alguns locais as fontes são maiores do que deveriam e em outros são muito pequenas.
- Crashes (Travamentos Fatais)
    - Exceção nas Configurações: Tentar alterar o e-mail ou a senha gera uma exceção (Go Exception - responsável pelas rotas do flutter). O erro trava a tela e o botão de Home da tela de exceção não funciona, exigindo a reinicialização completa do aplicativo.
    - Crash de Vídeo: Interagir com o reprodutor de vídeo causou a quebra (crash) do aplicativo algumas vezes.
- Persistência de Dados e Salvamento
    - Checklist diário: Marcar os remédios não salva a ação. Ao sair e entrar novamente, eles constam como desmarcados.
    - Métricas de saúde: Os botões de salvar na área de Dor, Fadiga e Sono não apresentam feedback visual (não voltam para a Home) e os dados não estão sendo salvos (não aparecem no painel de admin).
- Áudio, Vídeo e Outros Módulos
    - Travamento de Áudio: Alterar a velocidade do vídeo repetidas vezes faz com que o áudio pare de funcionar e trave.
    - Módulos Inacessíveis: Não é possível acessar a área de "Mitos e Verdades" a partir da pergunta da home e a área de "Permissões" não funciona.

## Potenciais Problemas

Esses itens são comportamentos estranhos, lentidões ou problemas que podem depender do ambiente de teste (como o emulador), mas que exigem investigação.

- Comportamento de Scroll Instável: O movimento de rolagem está travado ou muito sensível nas áreas de "Mitos e Verdades", lista de "Exercícios" e na tela "Qual devo escolher".
- Glitches Visuais: Fazer scroll em cima da barra inferior gera um efeito de luz branca inesperado. O mesmo acontece ao fazer scroll em cima dos botões da área de exercícios (efeito de luz azul).
- Performance de Vídeo: Os vídeos demoram muito tempo para carregar e começar a reproduzir.
- Volume do Áudio: O som do vídeo está muito baixo (necessário validar se é um problema do próprio arquivo de vídeo, do player do app ou apenas uma limitação do emulador utilizado).
- Carregamento de Tela: A página de "Leis e Direitos" apresenta lentidão significativa para abrir.
- Vazamento de Memória (Memory Leak): Após usar o comando flutter run diversas vezes seguidas no emulador, ocorreu um erro de armazenamento insuficiente. Isso pode indicar um problema do ambiente de desenvolvimento ou que o aplicativo está retendo memória indevidamente.
- Dados Falsos (Mockados): O gráfico da área "Sua Evolução" não parece refletir os dados inseridos, indicando que os valores provavelmente estão mockados.

## Sugestões de Melhorias

- Aumentar Área de Clique (Hitbox) em Medicamentos: Atualmente, o usuário só consegue marcar o remédio clicando exatamente no quadrado de seleção. É altamente recomendado permitir a seleção clicando no nome do remédio ou em toda a área (div) do item.
- Melhorar Navegação em Medicamentos: A área de medicamentos não possui um botão de "Voltar para Home", o que pode deixar o usuário preso na tela ou forçá-lo a usar comandos do sistema operacional para sair.
- Aviso de Redirecionamento Externo: Ao clicar em "Links de Referência", seria ideal implementar um alerta rápido (dialog ou snackbar) avisando o usuário de que ele está prestes a sair do aplicativo para abrir o navegador.
- Scroll Completo na Tela de Respiração: Na tela "Técnicas de respiração", a experiência seria mais fluida se a tela inteira descesse no scroll, em vez de rolar apenas a lista contendo os vídeos.
- Login por E-mail: Atualmente só é possível logar utilizando o nome de usuário. Sugere-se adicionar a flexibilidade de logar também utilizando o endereço de e-mail.