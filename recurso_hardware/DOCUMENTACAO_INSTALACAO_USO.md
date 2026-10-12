# MANUAL DE INSTALAÇÃO, CONFIGURAÇÃO E USO
## Aplicativo de Registro de Ponto com Geolocalização e Biometria (PontoGeo & Bio)
**Projeto:** Avaliação Somativa - Recursos de Hardware em Flutter  
**Versão:** 1.0.0  

---

## 1. Pré-Requisitos do Ambiente de Desenvolvimento

Para executar e testar o projeto, certifique-se de possuir em sua máquina:
* **Flutter SDK:** versão 3.22.0 ou superior (testado e homologado no Flutter 3.44.8 / Dart 3.12.2).
* **Git:** instalado e configurado no PATH do sistema.
* **Ambiente de Destino (um dos seguintes):**
  * Dispositivo físico Android conectado via USB (com depuração ativada e biometria configurada);
  * Emulador Android (com suporte a biometria nas configurações do emulador);
  * Windows Desktop (suporta execução nativa com localização do Windows e Windows Hello);
  * Navegador Google Chrome / Edge.

---

## 2. Passo a Passo para Executar Localmente

### Passo 2.1 - Clonar / Acessar a pasta do projeto
No terminal, navegue até a pasta do projeto:
```bash
cd recurso_hardware
```

### Passo 2.2 - Instalar dependências
Execute o comando para baixar todos os pacotes:
```bash
flutter pub get
```

### Passo 2.3 - Executar os testes automatizados
Valide se as regras de negócio de geofencing de 100 metros e serialização estão íntegras:
```bash
flutter test
```
*Saída esperada:* `All tests passed!`

### Passo 2.4 - Executar o aplicativo
Para listar os dispositivos disponíveis:
```bash
flutter devices
```

Para rodar no dispositivo conectado ou no Windows:
```bash
# Execução no dispositivo padrão ou Windows desktop
flutter run

# Ou especificando a plataforma:
flutter run -d windows
flutter run -d chrome
flutter run -d <android-device-id>
```

---

## 3. Configurações de Recursos de Hardware

### 3.1 Configuração Android (Já pronta no projeto)
O projeto já se encontra totalmente configurado para o ecossistema Android:

1. **Permissões no `android/app/src/main/AndroidManifest.xml`:**
   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
   <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
   <uses-permission android:name="android.permission.USE_BIOMETRIC"/>
   <uses-permission android:name="android.permission.USE_FINGERPRINT"/>
   ```

2. **Compatibilidade com Biometria no `android/.../MainActivity.kt`:**
   O arquivo já estende `FlutterFragmentActivity`, essencial para o funcionamento do leitor biométrico:
   ```kotlin
   package com.example.recurso_hardware

   import io.flutter.embedding.android.FlutterFragmentActivity

   class MainActivity : FlutterFragmentActivity()
   ```

### 3.2 Configuração iOS (Caso deseje executar em Mac/iPhone)
No arquivo `ios/Runner/Info.plist`, adicione as chaves de descrição de uso:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>O aplicativo necessita de sua localização para validar o raio de 100 metros do local de trabalho.</string>
<key>NSFaceIDUsageDescription</key>
<string>O aplicativo necessita do Face ID para validar sua identidade no registro de ponto.</string>
```

---

## 4. Instruções para Configuração do Firebase

O aplicativo foi projetado com uma **arquitetura resiliente de modo duplo (Dual-Mode)**:
* **Modo Offline/Demonstração (Ativo por padrão):** O app funciona 100% imediatamente mesmo que o avaliador não configure chaves de nuvem no primeiro momento.
* **Modo Firebase Online:** Conecta-se diretamente ao Firebase Auth e Cloud Firestore seguindo os passos abaixo:

### Passo a passo para vincular seu projeto Firebase:
1. Acesse o [Firebase Console](https://console.firebase.google.com/) e crie um novo projeto.
2. Ative o serviço **Authentication** e habilite o provedor **E-mail/Senha**.
3. Crie um banco de dados no **Cloud Firestore** em modo de teste com a coleção `registros_ponto`.
4. Instale a ferramenta oficial da CLI do Firebase:
   ```bash
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   ```
5. Execute a configuração automática do projeto Flutter:
   ```bash
   flutterfire configure
   ```
6. Opcionalmente, baixe o arquivo `google-services.json` gerado pelo console e posicione-o em:
   `android/app/google-services.json`.

---

## 5. Guia Rápido de Uso para a Banca Avaliadora (Testes em 1 Minuto)

Para testar todas as funcionalidades de forma dinâmica durante a apresentação:

### 1. Tela de Login:
* **Opção 1 (Acesso Rápido):** Clique em um dos chips na caixa *"Acesso Rápido para Avaliação"* (ex: **Carlos Silva (1001)**) para preencher e entrar automaticamente com 1 clique!
* **Opção 2 (Manual):** Digite NIF `1001` e Senha `123`, ou utilize seu e-mail corporativo.
* **Opção 3 (Biometria):** Clique no botão *"Entrar com Reconhecimento Facial"*.

### 2. Tela Principal (Registro de Ponto):
* Observe o **Relógio Digital em Tempo Real** no topo com precisão de segundos.
* Observe o **Card de Geolocalização**:
  * O aplicativo calculará a distância da sua posição atual até a sede de São Paulo.
  * Como você provavelmente está a mais de 100 metros, o banner exibirá:  
    🔴 **FORA DO LIMITE PERMITIDO (> 100M)**.
  * Tente clicar em **Entrada**: o aplicativo bloqueará o registro e exibirá um alerta explicando a regra dos 100 metros!

### 3. Testando o Raio Permitido de 100 Metros:
* Para simular que você chegou na empresa:
  * Toque no botão **"Ajustar para Teste"** ou vá na aba **Sede & Raio** e clique em **"Definir Minha Localização Atual como Sede"**.
  * A distância mudará imediatamente para **~0 metros** e o banner ficará:  
    🟢 **DENTRO DO LIMITE (≤ 100 METROS) - Apto para bater**.
* Agora toque no botão **Entrada**, **Saída Intervalo**, **Volta Intervalo** ou **Saída Expediente**:
  * Confirme os dados na caixa de diálogo de auditoria;
  * Valide com a **Biometria/Reconhecimento Facial** do seu dispositivo;
  * O ponto será registrado com sucesso!

### 4. Tela de Histórico:
* Toque na aba **Histórico** na barra inferior para visualizar todos os registros.
* Filtre por tipo de marcação (*Entrada, Intervalo, Saída*).
* Toque em qualquer cartão para abrir o **Relatório Detalhado de Auditoria** com coordenadas GPS, distância, ID único e status de sincronização.
* Se houver registros locais pendentes, use o botão **"Sincronizar"** no topo.

### 5. Aba Perfil e Diagnóstico:
* Verifique o status dos sensores nativos (Sensor Biométrico, GPS Nativo e Conexão Nuvem).
* Realize o encerramento da sessão clicando em **"Encerrar Sessão do Colaborador"**.
