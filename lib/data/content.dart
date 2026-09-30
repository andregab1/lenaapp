import 'package:flutter/material.dart';
import '../models/track.dart';

/// ============================================================
/// EDIT HERE: this is the only file you need to touch to change
/// the songs, artists, durations, the relationship start
/// date, or the hidden letter text.
/// ============================================================

/// Used for the "há X dias juntos" counter on the Home screen.
/// >>> TROQUE ESSA DATA pela data de vocês (ano, mês, dia) <<<
final DateTime relationshipStartDate = DateTime(2025, 11, 8);

/// Todo dia 8 é aniversário de namoro (mensal); em novembro também é o
/// aniversário anual. Retorna a próxima ocorrência do dia 8 a partir de
/// [now] (o próprio dia, se [now] já for dia 8).
DateTime nextAnniversaryDate(DateTime now) {
  var year = now.year;
  var month = now.month;
  if (now.day > 8) {
    month += 1;
    if (month > 12) {
      month = 1;
      year += 1;
    }
  }
  return DateTime(year, month, 8);
}

/// Shown as a small signature at the very bottom of the Home screen.
/// >>> TROQUE ESSE TEXTO se quiser <<<
const String footerSummary = '10 músicas, 5 vídeos, incontáveis motivos... tudo nosso 💜';

/// Shown in a full-screen letter when you long-press the "Nós, Dre e
/// Lena" title on the Home screen.
const String hiddenLetter = '''
Eu te amo mais que tudo meu amor. Quero que nesse aniversário você se sinta especial, se sinta amada, se sinta bonita, se sinta feliz, pq isso é tudo que eu mais quero pra você e pra nós.

Você é a melhor coisa que me aconteceu. Ainda toca na minha cabeça DREAM quando estamos juntinhos. Eu quero casar com você cada dia mais, eu quero ser seu até o dia da minha morte, e que você seja minha até o último dia da existência desse universo.

Eu amo você, eu entrego a você a cada átomo do meu corpo, eu entrego a você a minha esperança que a vida pode ser boa, eu entrego a você cada dia mais o meu eu mais entregue.

Eu amo você, amo mais que consigo descrever em palavras. Eu amo você, amo mais do que cabe no meu peito ou que minha mente consegue suportar. Eu amo você, amo ao ponto de viver e melhorar por você.

Eu amo você, amo o suficiente para saber que você será meu último amor, que nunca mais vou poder sentir nem algo próximo ao que sinto por você. Amo saber que não existe ninguém tão bom quanto você, e amo ainda mais saber que eu tenho você pra mim.

Eu quero ter um futuro ao seu lado e saber que você também quer isso. Eu quero que seja além de planos, quero ter você a cada dia da minha vida, quero envelhecer ao seu lado, ver meus cabelos ficarem brancos e ainda ter você do meu lado, me fazendo sorrir, me fazendo chorar, me fazendo sentir vivo, porque é sobre isso: eu te amo tanto que eu tenho vontade de viver, e que seja ao seu lado!

Eu te amo meu amor, feliz 20 anos. Que essa virada faça muito bem pra você, mesmo que assuste, saiba que nada vai me tirar do seu lado, que sempre vai poder contar comigo e ainda ser minha bebezinha, meu colinho, minha princesinha, meu soninho ♡
''';

final List<Track> songs = [
  Track(
    title: 'Faixa Amarela',
    artist: '2ZDINIZZ',
    durationSeconds: 206,
    audioAsset: 'audio/faixa_amarela.mp3',
    coverAsset: 'assets/images/photo1.jpg',
    dominantColor: Color(0xFF8C5B00),
  ),
  Track(
    title: 'Lisboa',
    artist: 'ANAVITÓRIA & Lenine',
    durationSeconds: 223,
    audioAsset: 'audio/lisboa.mp3',
    coverAsset: 'assets/images/photo2.jpg',
    dominantColor: Color(0xFF8C673D),
  ),
  Track(
    title: 'Foi Assim',
    artist: 'Sotam & Rob',
    durationSeconds: 147,
    audioAsset: 'audio/foi_assim.mp3',
    coverAsset: 'assets/images/photo3.jpg',
    dominantColor: Color(0xFF8C6537),
  ),
  Track(
    title: 'Última Vez',
    artist: 'Alee',
    durationSeconds: 153,
    audioAsset: 'audio/ultima_vez.mp3',
    coverAsset: 'assets/images/photo4.jpg',
    dominantColor: Color(0xFF8C7F4F),
  ),
  Track(
    title: 'Cintura Ignorante',
    artist: '2ZDINIZZ',
    durationSeconds: 196,
    audioAsset: 'audio/cintura_ignorante.mp3',
    coverAsset: 'assets/images/photo5.jpg',
    dominantColor: Color(0xFF907D4F),
  ),
  Track(
    title: 'Quando Bate Aquela Saudade',
    artist: 'Rubel',
    durationSeconds: 395,
    audioAsset: 'audio/quando_bate_aquela_saudade.mp3',
    coverAsset: 'assets/images/photo6.jpg',
    dominantColor: Color(0xFF8C744C),
  ),
  Track(
    title: 'Quase Que Falei Te Amo',
    artist: 'Aka Rasta',
    durationSeconds: 164,
    audioAsset: 'audio/quase_que_falei_te_amo.mp3',
    coverAsset: 'assets/images/photo7.jpg',
    dominantColor: Color(0xFF8C5619),
  ),
  Track(
    title: 'Cristal (Acústico)',
    artist: 'Froid',
    durationSeconds: 195,
    audioAsset: 'audio/cristal.mp3',
    coverAsset: 'assets/images/photo1.jpg',
    dominantColor: Color(0xFF8C5B00),
  ),
  Track(
    title: 'Só Nós Dois',
    artist: 'Tim Bernardes',
    durationSeconds: 228,
    audioAsset: 'audio/so_nos_dois.mp3',
    coverAsset: 'assets/images/photo2.jpg',
    dominantColor: Color(0xFF8C673D),
  ),
  Track(
    title: 'Dream',
    artist: 'The Pied Pipers',
    durationSeconds: 168,
    audioAsset: 'audio/dream.mp3',
    coverAsset: 'assets/images/photo3.jpg',
    dominantColor: Color(0xFF8C6537),
  ),
];

final Playlist mainPlaylist = Playlist(
  id: 'mix',
  title: 'Nós, Dre e Lena',
  meta: 'Playlist • Nós, Dre e Lena',
  tracks: songs,
  coverAssets: [songs[0].coverAsset, songs[1].coverAsset, songs[2].coverAsset, songs[3].coverAsset],
);

Map<String, Playlist> buildPlaylists() {
  return {
    'mix': mainPlaylist,
  };
}
