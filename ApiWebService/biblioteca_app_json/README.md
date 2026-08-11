# Projeto Biblioteca APP Json 

## 1. Identificação do Projeto 

- **Nome do Projeto**: Biblioteca App 
- **Descrição**: Aplicativo móver multiplataforma (Flutter) para gereciamento de bibliotecas, com funcionalidade CRUD (Criar, Ler, Atualizar e Deletar) para Usuários, livros e empréstimos. 

## 2. Pro´pósito e Escopo 

O sistema tem como objetivo digitalizar e simplificar a gestão de acervos bibliotecários. Ele permite o cadastro e conyrole de livros, usuários e empréstimos, oferencedo uma interface intuitiva para administradores. O escopo atual inclui operações básicas de gerenciamento, com dados persistidos em um backend simulado via Json Server 

## 3. Requisitos Funcionais (RF)

| ID | Requisito | Descrição |
| -- | --------- | --------- |
| RF01 | Gerenciar Livros | Listar, Cadastrar, editar e excluir livros do acervo | 
| RF02 | Gerenciar Usuários | Listar Cadastrar, Editar e Excluir usuários do sistema | 
| RF03 | Gerenciar Empréstimos de Livros | Visualizar e gerenciar empréstimos de livros | 
| RF04 | Navegação | Interface com navegação para abas (Livros, Empréstimos, Usuários) |

## 4. Requisitos Não Funcionais (RNF)

| ID | Requisitos | Descrição |
| -- | ---------- | --------- |
| RNF01 | Arquitetura | Baseada em camadas (Model, Service, Controllers, Views) seguindo o padrão MVC. |
| RNF02 | Persistência | Utiliza um arquivo db.json como fonte de dados acessando via APIREST | 
| RNF03 | Tecnologia | Desenvolvimento em Flutter/Dart, com consumo de API via pacote http | sincronas (GET, POST, PUT, DELETE)

## 5. Endpoints da API (BackEnd)

| Método | Endpoint | Descrição |
| ------ | -------- | --------- |
| GET | /users/ | Lista todos os usuários | 
| GET | /users/{id} | Busca um usuário por ID | 
| POST | /users | Cria um novo usuário |
| PUT | /users/{id} | Atualiza um usuário | 
| DELETE | /users/{id} | Remove um usuário | 
| GET | /book | Lista todos os livros | 
| GET | /book{id} | Busca um livro por ID |
| POST | /books | Cria um novo livro |
| PUT | /books/{id} | Atualiza um livro |
| DELETE | /books/{id} | Remove um livro |
| GET | /loans | Lista todos os empréstimos |
| POST | /loans | Registra um novo Empréstimo |

## 6. Diagramas 

### 6.1 Diagramas de Entidade Relacional (DER)

```mermaid 
    
    erDiagram 
        USER {
            int id PK 
            string name 
            string email 
        }

        BOOK {
            int id PK 
            string title 
            string author 
            boolean avaliable 
        }

        LOAN {
            int id PK 
            int userId FK 
            int bookId FK 
            date startDate 
            date dueDate
            boolean returned 
        }

        USER ||--o{ LOAN: "do"
        BOOK ||--o{ LOAN: "is loan in"
```

## 6.2 Diagrama de Classe 

```mermaid 

    classDiagram
        class ApiService{
            <<static>>
            _String_baseURL
            +getList(String path) Future~List~
            +getOne(String path, String id) Future~Map~
            +post(String path, Map body) Future~Map~
            +put(String path, Map body, String id) Future~Map~
            +delete(String path, String id) Future~void~
        }

        class UserModel {
            -String? id
            -String name 
            -String email
            +toMap() Map
            +fromMap(Map map) Usermodel
        }

        class BookModel {
            -String? id 
            -String title 
            -String author 
            -bool avaliable
            +toMap() Map 
            +fromtMap (Map map) BoolModel 
        }

        class LoanModel {
            -String? id 
            -UserModel user 
            -BookModel book 
            -DateTime startDate
            -DateTime dueDate 
            -bool returned 
            +toMap() Map 
            +fromMap(Map map) LoanModel
        }

        
        class UserController{

        }

        class BookController{

        }

        class LoanController {
            
        }

```