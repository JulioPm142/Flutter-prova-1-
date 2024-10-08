# Flutter-prova-1-

1) IMPLEMENTAR UMA APLICAÇÃO EM FLUTTER PARA SOLUCIONAR O DESAFIO ABAIXO:


- TELA INICIAL
  - logo tipo (escola)
  - botão para acesso a tela 1
 
- TELA 1 - Login
    Solicitar nome e senha
    * emular no mockable.io uma reposta de resposta ao login
   * considerar que a resposta sempre dará acesso (nome e senha sempre serão aceitos)
   * neste caso, o endpoint é denominado login  e retorna um token
   - Mostrar token recebido antes de ir para a tela 2

- Tela 2
   - Recuperar as informações do endPoint notasAlunos
   * criar este endPoint no mockale.io
   * este endPoint retorna: Matrícula, Nome do aluno e respectiva nota (de 0 a 100)
  - Implementar 3 botões:
   - Alunos nota <60p
   - Alunos nota >=60 exceto 100
   - Alunos nota = 100
 * Visualizar as informações em um listview
 *  Alunos com nota <60 deverão ter background do item no listview na cor Amarelo
 *  Alunos com nota >=60 deverão ter background do item no listview na cor Azul
 * Alunos com nota =100 deverão ter background do tiem no listview na cor Verde
   * nota 100 prevalece em relação as notas>=60
 Os detalhes da visualização (quando todas as informações são carregadas na segunda tela a primeira vez,devem
 estar de acordo com o descrito anteriormente).
 Quando visualizadas por meio da seleção do botão, deve seguir  a orientação dada, porém individualmente.

Critério resolução de problemas e relacionamento de conceitos
Resposta: link do github da sua conta pessoal
Próxima aula apresentação com questionamento e modificações solicitadas que deverão ser implementadas em tempo real
