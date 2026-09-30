# Nós, Dre e Lena 💜

App de aniversário personalizado com layout inspirado no Spotify, feito em Flutter.

## Como rodar

```
cd lena_spotify_app
flutter pub get
flutter run
```

## Gerar o ícone e a splash screen personalizados (rode uma vez)

Depois do `flutter pub get`, rode:

```
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

Isso troca o ícone padrão do Flutter pelo coraçãozinho gerado (`assets/icon/icon.png`) e a tela branca de abertura pela splash personalizada (`assets/splash/splash.png`). Só precisa rodar de novo se trocar essas imagens.

## Gerar o APK pra instalar no celular da Lena

```
flutter build apk --release
```
O arquivo fica em `build/app/outputs/flutter-apk/app-release.apk`. Transfira esse APK pro celular dela e instale (pode precisar permitir "instalar de fontes desconhecidas" nas configurações do Android).

## O que editar pra personalizar

Tudo fica em **`lib/data/content.dart`** — é o único arquivo que você provavelmente vai querer mexer:

- `relationshipStartDate` — data que aparece no contador "há X dias juntos" no topo da Home. **Troque pela data de vocês.**
- `hiddenLetter` — mensagem que aparece ao segurar o dedo no título "Nós, Dre e Lena" na Home. **Troque pelo seu texto de verdade.**
- `songs` — lista das 10 músicas: título, artista, duração, arquivo de áudio, foto de capa, legenda (`caption`, aparece embaixo do nome no "Tocando agora") e cor de destaque (`dominantColor`, usada pra tingir o fundo daquela música).
- Pra trocar uma foto: coloque o arquivo em `assets/images/` e referencie o caminho em `coverAsset`.
- Pra trocar/adicionar uma música: coloque o mp3 em `assets/audio/`, declare o caminho no `pubspec.yaml` (seção `flutter: assets:`) e adicione uma entrada em `songs`.

Vídeos do feed ficam configurados em **`lib/screens/home_screen.dart`**, nas listas `videoFeedAssets` (arquivos) e `videoFeedPhrases` (frases que aparecem durante a transição de cada vídeo).

## Funcionalidades

- Player de música real (10 faixas, com progresso, play/pause)
- Feed de vídeos que toca automaticamente conforme você rola a tela, com frases animadas aparecendo durante a transição e sumindo quando o vídeo assenta
- Vídeos horizontais mostram a barra preta (não são cortados); verticais preenchem a tela
- Botão de replay quando um vídeo termina
- Duplo toque em vídeos ou na capa do "Tocando agora" solta uma chuva de corações
- Segurar o dedo no título "Nós, Dre e Lena" revela uma carta escondida
- Contador discreto de dias juntos
- Cada música tinge o fundo do "Tocando agora" com uma cor extraída da própria foto de capa
- A capa da música "voa" da lista até o "Tocando agora" ao abrir (efeito Hero) — **funciona na maioria dos casos**, mas como o app usa uma navegação em duas camadas (pra manter o mini-player sempre visível), pode não animar em 100% das aberturas; nesses casos ele simplesmente aparece direto, sem quebrar nada.

## Limitações importantes (leia antes de usar)

- **Não compilei/testei este código.** Não tenho o SDK do Flutter disponível aqui pra rodar `flutter run` ou `flutter analyze`, então revisei tudo manualmente. Se der erro ao rodar, me manda a mensagem exata que eu conserto.
- O ícone/splash só aparecem depois de rodar os comandos `dart run flutter_launcher_icons` e `dart run flutter_native_splash:create` (uma vez só, depois do `pub get`).

## Estrutura do projeto

```
lena_spotify_app/
  lib/
    main.dart                  # tela raiz, mini player persistente
    theme/app_theme.dart        # cores e tema (estilo Spotify)
    models/track.dart           # modelo de dados de faixa/playlist
    data/content.dart           # ⭐ conteúdo editável (músicas, legendas, data, carta)
    controllers/player_controller.dart  # estado do player de áudio
    screens/                    # Home, Playlist, Now Playing
    widgets/                    # cards, mini player, feed de vídeo, corações, carta
  assets/
    images/                     # suas fotos
    audio/                      # as 10 músicas
    videos/                     # vídeos do feed
    icon/, splash/              # imagens geradas pro ícone e splash screen
  pubspec.yaml
```
