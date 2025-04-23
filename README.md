
**⚠️ ATENÇÃO:**


## 🌿 Branch Principal
A branch `master` é a **branch principal** do projeto.  
Nela estão as versões mais estáveis e representativas do app até o momento.

Todas as novas funcionalidades e melhorias ainda estão em desenvolvimento.  
Espero ter a oportunidade de apresentar mais detalhes em uma conversa técnica!

# MyBookStore

Para concluir a etapa prática, você precisará criar o app chamado "**MyBookStore**".

#### Links úteis:


> Endereço da API: https://api-flutter-prova.hml.sesisenai.org.br/ (HTTP também disponível caso ocorram problemas)


#### Regras da prova:

- A aplicação desenvolvida deve seguir o wireframe das telas presentes no FIGMA (link será disponibilizado no repositório), sendo o mais fiel possível. Detalhes extras de UI/UX podem ser feitos e ficam à cargo dos candidatos.
- Deve ser utilizado BLOC para gerenciamento de estados.
- As imagens devem ser enviadas em base64 para a API
- Versão do Flutter >= 3.29.0
- A arquitetura e organização dos arquivos fica a critério do candidato, e será item de análise para a nota final.
- A API possui o básico necessário para realização da prova, não é robusta e também não possui validações extras.

#### Regras da aplicação:

O _MyBookStore_ é um app para o controle de catálogo de livros disponíveis em uma determinada livraria.

Haverão dois perfis de usuários com acesso ao aplicativo: **ADMIN** e **EMPLOYEE**.

- _ADMIN_: Será o responsável por criar a loja, cadastrar e editar os livros disponíveis. Assim como também criar e editar novos usuários que serão os funcionários de sua loja. O admin poderá fazer tudo que um employee também pode.
- _EMPLOYEE_: Como funcionário, poderá logar na aplicação e visualizar o catálogo de livros disponíveis, através dos filtros. Também poderá alterar o status de um livro entre "EM ESTOQUE" e "SEM ESTOQUE".

1. Tela de Login:

Tela inicial da aplicação.
A senha de usuário deve seguir as regras:
- Mais de 6 caracteres
- Menos de 10 caracteres
- Pelo menos 1 letra maiúscula
- Pelo menos um caracter especial

2. Home:

Contém a listagem de todos os livros disponíveis na loja do usuário, podendo buscar/filtrar os livros.

3. Tela do livro:

Ao clicar em um livro, o usuário é levado para a tela de detalhes daquele livro.

ADMIN: Pode editar o livro
EMPLOYEE: Pode apenas alterar entre "EM ESTOQUE" e "SEM ESTOQUE"

4. Cadastro do livro:

Usuários ADMIN terão acesso ao menu "Livros", onde é possível fazer o cadastro de novos livros para a loja.

5. Cadastro funcionários:

Usuários ADMIN terão acesso ao menu "Funcionários", onde ele pode visualizar, cadastrar ou editar funcionários de sua loja.
Esses funcionários poderão acessar o app como EMPLOYEE.

6. Tela meu perfil:

Tela que mostrará os dados do usuário logado e também os dados da loja desse usuário, incluindo o banner previamente cadastrado.
Usuários ADMIN podem editar seus dados e os dados da loja, enquanto EMPLOYEE apenas visualizam as informações.

#### API:

Todos os Endpoints, com exceção do `POST: v1/store` e `POST: v1/auth` são protegidos. É necessário informar no header o token:
```
Authorization: Bearer {token}
```

- `POST v1/store`:

Campos:

```json
{
    "name": "Minha Lojinha",
    "slogan": "A melhor lojinha do sul do mundo!",
    "banner": "imageBase64",
    "admin": {
        "name": "Julio Bitencourt",
        "photo": "imageBase64",
        "username": "julio.bitencourt",
        "password": "8ec4sJ7dx!*d"
    }
}
```

Retorno
```json
{
    "refreshToken": "eyJ0eXAiOiJKV1QiL..",
    "store": {
        "banner": "imageBase64",
        "id": 1,
        "name": "Minha Lojinha",
        "slogan": "A melhor lojinha do sul do mundo!"
    },
    "token": "eyJ0eXAiOiJKV1...",
    "user": {
        "id": 1,
        "name": "Julio Bitencourt",
        "photo": "imageBase64",
        "role": "Admin"
    }
}
```

- `POST v1/auth`:

Campos
```json
{
  "user": "julio.bitencourt",
  "password": "8ec4sJ7dx!*d"
}
```

Retorno
```json
{
    "refreshToken": "eyJ0eXAiOiJKV1QiL..",
    "store": {
        "banner": "imageBase64",
        "id": 1,
        "name": "Minha Lojinha",
        "slogan": "A melhor lojinha do sul do mundo!"
    },
    "token": "eyJ0eXAiOiJKV1...",
    "user": {
        "id": 1,
        "name": "Julio Bitencourt",
        "photo": "imageBase64",
        "role": "Admin"
    }
}
```

- `POST v1/auth/validateToken`:

Campos
```json
{
    "refreshToken": "eyJ0eXAiOiJ..."
}
```

Retorno
```json
{
    "refreshToken": "eyJ0eXAiOiJK...",
    "token": "eyJ0eXAiOiJKV1..."
}
```

- `GET /v1/store/1`:

Retorno
```json
{
    "banner": "imageBase64",
    "idStore": 1,
    "name": "Minha Lojinha",
    "slogan": "A melhor lojinha do sul do mundo!"
}
```


- `PUT /v1/store/1`:

Campos
```json
{
    "name": "Minha Lojinha Massaaa",
    "slogan": "A melhor lojinha do sul do mundo! E do país",
    "banner": "imageBase64444"
}
```

- `POST /v1/store/1/employee`:

Campos
```json
{
    "name": "Fulaninho",
    "photo": "imageBase64",
    "username": "ful.aninho",
    "password": "8ec4sJ7dx!*d"
}
```

- `GET /v1/store/1/employee`:

Retorno:
```json
[
    {
        "id": 2,
        "name": "Fulaninho",
        "photo": "imageBase64",
        "username": "ful.aninho"
    },
    {
        "id": 3,
        "name": "Ciclaninho",
        "photo": "imageBase64",
        "username": "cic.laninho"
    }
]
```

- `PUT /v1/store/1/employee/4`:
  Campos
```json
{
    "name": "Ciclaninho",
    "photo": "imageBase64",
    "username": "cic.laninho",
    "password": "8ec4sJ7dx!*d"
}
```

- `DELETE /v1/store/1/employee/4`:

- `POST /v1/store/1/book`

Campos:
```json
{
    "cover": "imageBase64",
    "title": "O guia de Dart",
    "author": "Julio Henrique Bitencourt",
    "synopsis": "...",
    "year": 2022,
    "rating": 5,
    "available": false
}
```

- `PUT /v1/store/1/book/1`

Campos:
```json
{
    "cover": "imageBase64",
    "title": "O guia de Dart",
    "author": "Julio Henrique Bitencourt",
    "synopsis": "O MELHOR LIVRO DE DART",
    "year": 2022,
    "rating": 5,
    "available": false
}
```

- `GET /v1/store/1/book/1`

- `DELETE /v1/store/1/book/1`

- `SEARCH v1/store/1/book?limit=20&offset=0&author=Julio%20Bitencourt&title=O%20guia&year-start=2020&year-finish=2023&rating=5&available=true`

Filtros:
1. limit
2. offset
3. author
4. title
5. year-start
6. year-finish
7. rating
8. available



