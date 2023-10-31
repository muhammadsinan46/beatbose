import 'package:beatboseapp/databse/boxinstance.dart';
import 'package:beatboseapp/model/songs_adapter.dart';

class MostlyPlayed {
    Future<List<SongAdapter>> getMostlyPlayed() async {
    final mostlyplayedBox = await InstanceBox.getInstance();

    

    final List<SongAdapter> mostlysongs = mostlyplayedBox.values
        .where((item) => item != null && item is SongAdapter)
        .map((item) => item as SongAdapter)
        .toList();

    mostlysongs.sort((a, b) {
      final aplayCount = a.playCount ?? 0;
      final bplayCount = b.playCount ?? 0;
      return bplayCount.compareTo(aplayCount);
    });

    print("mostly played songs :${mostlysongs}");

    return mostlysongs.take(10).toList();
  }
  void addToMostlyPlayed(SongAdapter songs) async {
        final mostlyplayedBox = await InstanceBox.getInstance();
    if (songs.playCount != null) {
      songs.playCount = (songs.playCount ?? 0) + 1;
      await mostlyplayedBox.put(songs.key, songs);
      
    }

    print("this is count: ${songs.playCount}");
  }


  

}


