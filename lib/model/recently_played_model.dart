import 'package:beatboseapp/databse/boxinstance.dart';
import 'package:beatboseapp/model/songs_adapter.dart';

class RecentlyPlayed {
  static const int maxrecentSongs = 20;
  Future<List<SongAdapter>> getRecentlyPlayed() async {
    try {
      final recentlyplayedBox = InstanceBox.getInstance();
      final List<SongAdapter> recentSong = recentlyplayedBox
              .get("recently played")
              ?.toList()
              .cast<SongAdapter>() ??
          [];

      print("Recently Played Songs: $recentSong");
      return recentSong;
    } catch (e) {
     print("Error retrieving recently played songs: $e");
      return [];
    }
  }

  addToRecentlyPlayed(SongAdapter songs) async {
    final recentlyplayedBox = InstanceBox.getInstance();
    List<SongAdapter> recentSong = recentlyplayedBox
            .get('recently played')
            ?.toList()
            .cast<SongAdapter>() ??
        [];

    print("add Played Songs: $recentSong");

    recentSong.removeWhere((song) => song.id == songs.id);

    recentSong.insert(0, songs);

    if (recentSong.length > maxrecentSongs) {
      recentSong.removeRange(maxrecentSongs, recentSong.length);
    }

    await recentlyplayedBox.put('recently played', recentSong);

    print("recent playlsit successfully added");
  }

  updateRecentlyPlayed(List<SongAdapter> updateList) async {
    try {
      final recentlyplayedBox = InstanceBox.getInstance();
      await recentlyplayedBox.put('recently played', updateList);
      print("songs removed from the list");
    } catch (e) {
      print("error on recentlynplayed songs: $e");
    }
  }
}
