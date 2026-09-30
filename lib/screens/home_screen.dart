import 'package:flutter/material.dart';
import '../controllers/player_controller.dart';
import '../data/content.dart';
import '../models/track.dart';
import '../theme/app_theme.dart';
import '../widgets/track_art.dart';
import '../widgets/track_card.dart';
import '../widgets/video_feed_item.dart';
import '../widgets/floating_particles.dart';
import 'now_playing_screen.dart';
import 'playlist_screen.dart';

const List<String> videoFeedAssets = [
  'assets/videos/momento.mp4',
  'assets/videos/feed1.mp4',
  'assets/videos/feed2.mp4',
  'assets/videos/feed4.mp4',
  'assets/videos/feed5.mp4',
];

const List<String> videoFeedPhrases = [
  'EU TE AMO',
  'MINHA PRINCESA',
  'PRA SEMPRE',
  'SÓ NÓS DOIS',
  'MEU AMOR',
];

class HomeScreen extends StatefulWidget {
  final PlayerController controller;
  const HomeScreen({super.key, required this.controller});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _openPlaylist(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PlaylistScreen(playlist: mainPlaylist, controller: widget.controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        // ---- Greeting + quick grid ----
        Container(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF3A1630), AppColors.bg],
              stops: [0.0, 1.0],
            ),
          ),
          child: Stack(
            children: [
              const Positioned.fill(child: FloatingParticles()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Um pouco de nós, Feliz aniversário minha princesa 💜',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.text),
                  ),
                  const SizedBox(height: 4),
                  Builder(builder: (context) {
                    final now = DateTime.now();
                    final todayMidnight = DateTime(now.year, now.month, now.day);
                    final days = todayMidnight.difference(DateTime(relationshipStartDate.year, relationshipStartDate.month, relationshipStartDate.day)).inDays;
                    final nextAnniv = nextAnniversaryDate(now);
                    final daysToNext = nextAnniv.difference(todayMidnight).inDays;
                    final annivLabel = daysToNext == 0 ? 'hoje é nosso mesversário! 💜' : 'faltam $daysToNext dias pro próximo mesversário';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'há $days dias juntos',
                          style: const TextStyle(fontSize: 12, color: AppColors.textDim, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          annivLabel,
                          style: const TextStyle(fontSize: 12, color: AppColors.textDim, fontWeight: FontWeight.w600),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 16),
                  _QuickGrid(controller: controller),
                ],
              ),
            ],
          ),
        ),

        // ---- Hero playlist card ----
        GestureDetector(
          onTap: () => _openPlaylist(context),
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PLAYLIST DO CASAL',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.5, color: Colors.white70),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Nós, Dre e Lena',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${songs.length} músicas nossas',
                      style: const TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 44,
                      child: Stack(
                        children: List.generate(3, (i) {
                          final s = songs[i * 2 % songs.length];
                          return Positioned(
                            left: i * 32.0,
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white54, width: 2),
                                image: DecorationImage(image: AssetImage(s.coverAsset), fit: BoxFit.cover),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () {
                      controller.playTrack(songs.first);
                      openNowPlaying(context, controller);
                    },
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
                      child: const Icon(Icons.play_arrow, color: Colors.black, size: 28),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        _SectionRow(
          title: 'Nossas músicas',
          tracks: songs,
          controller: controller,
        ),

        // ---- Video feed, further down the screen ----
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            'Nossos vídeos',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.text),
          ),
        ),
        ...List.generate(videoFeedAssets.length, (i) {
          final screenHeight = MediaQuery.of(context).size.height;
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 56),
            child: VideoFeedItem(
              asset: videoFeedAssets[i],
              phrase: videoFeedPhrases[i % videoFeedPhrases.length],
              height: screenHeight * 0.72,
              scrollController: _scrollController,
            ),
          );
        }),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Text(
              footerSummary,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.textDim, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickGrid extends StatelessWidget {
  final PlayerController controller;
  const _QuickGrid({required this.controller});

  @override
  Widget build(BuildContext context) {
    final items = songs.take(4).toList();

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 2.6,
      children: items.map((track) {
        return InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () {
            controller.playTrack(track);
            openNowPlaying(context, controller);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                TrackArt(track: track, size: 56, borderRadius: 6),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    track.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SectionRow extends StatelessWidget {
  final String title;
  final List<Track> tracks;
  final PlayerController controller;
  const _SectionRow({required this.title, required this.tracks, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.text)),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: tracks.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (_, i) => TrackCard(
                track: tracks[i],
                onTap: () {
                  controller.playTrack(tracks[i]);
                  openNowPlaying(context, controller);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
