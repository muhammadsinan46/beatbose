import 'package:beatboseapp/databse/boxinstance.dart';
import 'package:beatboseapp/model/songs_adapter.dart';


class PlaylistSong {
  List<SongAdapter> getPlaylistsong() {
    final box = InstanceBox.getInstance();
    final List<SongAdapter> playlistSongs =
        box.get('playlist')?.toList().cast<SongAdapter>() ?? [];

    return playlistSongs;
  }

  addToPlaylistSong(SongAdapter songs) async {
    final box = InstanceBox.getInstance();
    final List<SongAdapter> playlistSongs =
        box.get('playlist')?.toList().cast<SongAdapter>();

    final keys = box.keys.toList();
    print(keys);

    if (playlistSongs.contains(songs)) {
      playlistSongs.remove(songs);
      await box.put('playlist', playlistSongs);
    } else {
      playlistSongs.add(songs);
      await box.put('playlist', playlistSongs);
    }
  }
}
