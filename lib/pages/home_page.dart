import 'package:flutter/material.dart';
import 'package:myapp/components/my_drawer.dart';
import 'package:myapp/models/playlist_provider.dart';
import 'package:myapp/models/song.dart';
import 'package:myapp/pages/song_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PlaylistProvider playlistProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Inisialisasi provider menggunakan didChangeDependencies
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  void goToSong(int songIndex) {
    // Set current song index di provider
    playlistProvider.currentSongIndex = songIndex;

    // Navigasi ke halaman detail lagu
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SongPage(),)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: const Text("P L A Y L I S T")),
      drawer: const MyDrawer(),
      body: Consumer<PlaylistProvider>(
        builder: (context, value, child) {
          final List<Song> playlist = value.playlist;

          if (playlist.isEmpty) {
            return const Center(
              child: Text("Playlist kosong. Tambahkan lagu terlebih dahulu."),
            );
          }

          return ListView.builder(
            itemCount: playlist.length,
            itemBuilder: (context, index) {
              final Song song = playlist[index];

              return ListTile(
                leading: song.albumArtImagePath.isNotEmpty
                    ? Image.asset(song.albumArtImagePath)
                    : const Icon(Icons.music_note), // Default icon jika path kosong
                title: Text(song.songName),
                subtitle: Text(song.artisName),
                onTap: () => goToSong(index),
              );
            },
          );
        },
      ),
    );
  }
}

class SongDetailPage extends StatelessWidget {
  final int songIndex;

  const SongDetailPage({super.key, required this.songIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Lagu")),
      body: Center(
        child: Text("Menampilkan detail lagu ke-$songIndex"),
      ),
    );
  }
}
