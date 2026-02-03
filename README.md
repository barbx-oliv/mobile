# Aula do dia 27/01 :

## Sala nova e criação de usuário
Na aula de hoje criamos um novo usuário para utilizarmos no computador da sala nova, onde somente nós temos acesso. Com isso, é mais prático para conseguirmos mexer no computador sem ter que ficar deslogando todas nossas contas do computador.

## Uso do Github e instalação do Git 
Com o computador pronto para uso, conectamos nossa conta do Github no Git. Para isso, primeiro instalamos o Git no computador e logo conectamos nossa conta do Github no Git. Os comandos foram: 

git config --global user.email "meumeail" (não tenho certeza se está correto)
git config --global user.name "username" 
git config --list (para verificarmos se o email e nome de usuário está correto)

E pronto! Nossa conta do Github está vinculada ao Git.

## Instalação do VSCode, vinculação do Github e criação de usuários
Para conseguirmos fazer um código, realizamos a instalação do VSCode nos computadores para conseguirmos realizar os códigos. Com o VSCode instalado, fomos até a área de usuário do VSCode e vinculamos nosso Github. 

Com o nosso Github logado no VSCode, criamos usuários para utilizarmos em códigos específicos, por exemplo:
Uma conta para PHP
Uma conta para Python... E assim vai. 
Além de que, quando criamos o usuário e escolhemos a linguagem que será utilizado, o próprio VSCode já instala as versões necessárias para conseguir utilizar a lingaugem específica. 

Ainda na parte de extensões, adicionamos a extensão "live share" para o professor conseguir transmitir a tela dele em nossos monitores, para não termos que ficar virando toda hora para codificar. 

## Criação de pastas para as aulas 
Por ultimo, criamos pastas para utilizarmos durante as aulas. Para fazer, os comandos são os seguintes: 
    cd .\Documents\ (para entrar em Documentos)    
        mkdir (nomedapasta) (criação de pasta)
        cd .\(nomedapasta)\ (entrar na pasta nova)
            mkdir mobile
            mkdir backend
            mkdir frontend
            mkdir projeto
            (todas para criar pasta)

Por ultimo, criamos o documento README.md.
    cd .\mobile\ (entrar na pasta)
        type nul > README.md (criação do documento que estou escrevendo neste momento)

# Aula do dia 03/02 :
## Introdução ao Desenvolvimento

### Tipos de desenvolvimento
- Nativo 
    - Android:
        - SDK : Android SDK
        - IDE : Android Studio
        - Linguagens : Kotlin e Java
        - Ambientes : Mac, Win, Linux
    - iOS:
        - SDK : Cocoa Touch
        - IDE : Xcode
        - Linguagens : Swift / Objectype-c
        - Ambiente : Mac

- Multiplataforma
    - React Native
        - SDK : Node.JS
        - IDE : VSCode, ect
        - Linguagens : JS, TypeScript
        - Ambientes : Mac, Win, Linux

    - Flutter 
        - SDK : Flutter SDK
        - IDE : VSCode, Android Studio 
        - Linguagens : Dart 
        - Ambientes : Mac, Win, Linux