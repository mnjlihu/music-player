import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  final List<Song> _playlist = [
    Song(
      songName: "Seorang Kapiten",
      artisName: "Neni Arisanti",
      albumArtImagePath: "assets/images/maxresdefault (1).png",
      audioPath:
          "audio/AKU SEORANG KAPITEN Diva Bernyanyi Lagu Anak Channel.mp3",
    ),
    Song(
      songName: "Balonku",
      artisName: "Riris Alfiana",
      albumArtImagePath: "assets/images/maxresdefault.png",
      audioPath: "audio/Balonku 🎈💚🎈 Lagu Anak Indonesia Balita.mp3",
    ),
    Song(
      songName: "Bintang Kecil",
      artisName: "Ali Rozai",
      albumArtImagePath: "assets/images/lagu-anak-bintang-kecil.png",
      audioPath: "audio/Lagu Anak Anak - Bintang Kecil.mp3",
    ),
    Song(
      songName: "Kucingku Gemuk",
      artisName: "Ali Rozai",
      albumArtImagePath: "assets/images/cat.png",
      audioPath:
          "audio/Kucingku Tiga Gemuk - Lagu Kucingku Telu - Lagu Anak Anak Lucu.mp3",
    ),
    Song(
      songName: "Anak Indonesia",
      artisName: "Indonesia",
      albumArtImagePath: "assets/images/Anak Indonesia.jpg",
      audioPath: "audio/Lagu Anak Indonesia Tik Tik Bunyi Hujan.mp3",
    ),
    Song(
      songName: "Cicak Di dinding",
      artisName: "Firman Puji",
      albumArtImagePath: "assets/images/maxres.jpg",
      audioPath: "audio/cicak-cicak dinding - Lagu anak balita populer.mp3",
    ),
    Song(
      songName: "Abang Tukang Bakso",
      artisName: "Istiqom waziroh",
      albumArtImagePath: "assets/images/maxresdefault (4).jpg",
      audioPath:
          "audio/Abang Tukang Bakso - Lagu Anak - Lagu Anak Indonesia - Lagu Anak Populer.mp3",
    ),
    Song(
      songName: "Kasih Ibu",
      artisName: "Neni Arisanti",
      albumArtImagePath: "assets/images/maxresdefault (5).jpg",
      audioPath: "audio/Kasih Ibu Diva Bernyanyi Lagu Anak Channel.mp3",
    ),
    Song(
      songName: "Naik Delman",
      artisName: "Riris Alfiana",
      albumArtImagePath: "assets/images/maxresdefault (2).jpg",
      audioPath: "audio/Naik Delman Versi 2023 - Lagu Anak Indonesia 90an.mp3",
    ),
  ];

  // Current song playing index
  int? _currentSongIndex;

  // Audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  Duration _totalDuration = Duration.zero;
  Duration _currentDuration = Duration.zero;

  // Constructor
  PlaylistProvider() {
    listenToDuration();
  }

  // Listen to duration updates
  void listenToDuration() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    // Listen to current position updates
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    // Listen to player completion
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  // Initially not playing
  bool _isPlaying = false;

  // Play the song
  Future<void> play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  // Pause current song
  void pause() {
    _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // Stop current song
  void stop() {
    _audioPlayer.stop();
    _isPlaying = false;
    notifyListeners();
  }

  // Resume playing
  Future<void> resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // Pause or resume
  void pauseOrResume() {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  // Seek to a specific position in the current song
  Future<void> seek(Duration newPosition) async {
    await _audioPlayer.seek(newPosition);
  }

  // Play next song
  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        // Go to the next song if it's not the last song
        _currentSongIndex = _currentSongIndex! + 1;
      } else {
        // If it's the last song, loop back to the first song
        _currentSongIndex = 0;
      }
    }
  }

  // Play previous song
  void playPreviousSong() async {
    // If more than 2 seconds have passed, restart the current song
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
      await _audioPlayer.seek(Duration.zero);
      await _audioPlayer
          .play(AssetSource(_playlist[_currentSongIndex!].audioPath));
    } else {
      // If within the first 2 seconds of the song, go to the previous song
      if (_currentSongIndex! > 0) {
        _currentSongIndex = _currentSongIndex! - 1;
      } else {
        // If it's the first song, loop back to the last song
        _currentSongIndex = _playlist.length - 1;
      }
    }
    await play();
  }

  // Getters
  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  // Setters
  set currentSongIndex(int? newIndex) {
    // Update current song index
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      play(); // Play the song at the new index
    }

    // Update UI
    notifyListeners();
  }
}
