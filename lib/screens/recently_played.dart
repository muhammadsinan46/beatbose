import 'package:beatboseapp/databse/boxinstance.dart';
// import 'package:beatboseapp/model/mostly_played_model.dart';
import 'package:beatboseapp/model/recently_played_model.dart';
import 'package:beatboseapp/model/songs_adapter.dart';
import 'package:beatboseapp/screens/nowplaying_screen.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:text_scroll/text_scroll.dart';

class PlayNowScreen extends StatefulWidget {
  const PlayNowScreen({super.key, required this.allSongs});
  final List<SongAdapter> allSongs;
  @override
  State<PlayNowScreen> createState() => _PlayNowScreenState();
}

class _PlayNowScreenState extends State<PlayNowScreen> {
  final ValueNotifier<List<SongAdapter>> refreshPage = ValueNotifier([]);
  final RecentlyPlayed _recentlyPlayed = RecentlyPlayed();
  // final MostlyPlayed _mostlyPlayed = MostlyPlayed();
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<SongAdapter> recentlyPlayedSongs = [];

  List playListKey = [];

  final _box = InstanceBox.getInstance();

  getPlayList() {
    playListKey = _box.keys.toList();
  }

  playSong(SongAdapter? song) async {
    try {
      _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(song!.uri!)));
      _audioPlayer.play();
      _recentlyPlayed.addToRecentlyPlayed(song);
      recentlyPlayedSongs.remove(song);
      recentlyPlayedSongs.insert(0, song);

      if (recentlyPlayedSongs.length > RecentlyPlayed.maxrecentSongs) {
        recentlyPlayedSongs.removeRange(
            RecentlyPlayed.maxrecentSongs, recentlyPlayedSongs.length);
      }

      setState(() async {
        recentlyPlayedSongs = recentlyPlayedSongs;

        await _recentlyPlayed.updateRecentlyPlayed(recentlyPlayedSongs);
        await loadRecentlyPlayedSongs();
      });
    } on Exception {
      print("Error parsing song");
    }
  }

  // Future<void> loadMostlyPlayedSongs() async {
  //   final songs = await _mostlyPlayed.getMostlyPlayed();
  //   setState(() {
  //     mostlyPlayedSongs = songs;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    loadRecentlyPlayedSongs();
    getPlayList();
  }

  loadRecentlyPlayedSongs() async {
    final songs = await _recentlyPlayed.getRecentlyPlayed();

    setState(() {
      recentlyPlayedSongs = songs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
            maxHeight: MediaQuery.of(context).size.height,
          ),
          child: FutureBuilder<List<SongAdapter>>(
            future: _recentlyPlayed.getRecentlyPlayed(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("");
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return ValueListenableBuilder(
                    valueListenable: refreshPage,
                    builder: ((context, List<SongAdapter>? recentlyPlayedSongs,
                        child) {
                      List<SongAdapter>? recentlyPlayedSongs = snapshot.data;
                      return ListView(
                        scrollDirection: Axis.vertical,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: double.infinity,
                                child: recentlyPlayedSongs!.isEmpty
                                    ? const Center(
                                        child:
                                            Text("No Recent Songs available"),
                                      )
                                    : ListView.separated(
                                        separatorBuilder: (context, index) =>
                                            const Divider(),
                                        itemCount: recentlyPlayedSongs.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {});
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      NowPlayingPanelScreen(
                                                    songs: recentlyPlayedSongs[
                                                        index], // Use recentlyPlayedSongs
                                                    allSongs:
                                                        recentlyPlayedSongs, // Pass recentlyPlayedSongs for allSongs
                                                  ),
                                                ),
                                              );
                                            },
                                            child: ListTile(
                                              leading: SizedBox(
                                                height: 50,
                                                width: 50,
                                                child: Image.asset(
                                                  'assets/images/images2.jpg',
                                                  fit: BoxFit.cover,
                                                  alignment: Alignment.center,
                                                ),
                                              ),
                                              title: TextScroll(
                                                // mode:TextScrollMode.bouncing,
                                                recentlyPlayedSongs[index]
                                                        .song ??
                                                    'Track $index',
                                                intervalSpaces: 10,
                                                velocity: const Velocity(
                                                    pixelsPerSecond:
                                                        Offset(50, 0)),
                                                //  delayBefore:const  Duration(milliseconds: 50),
                                                style: const TextStyle(
                                                    fontSize: 18),
                                              ),
                                              subtitle: Text(
                                                recentlyPlayedSongs[index]
                                                        .artist ??
                                                    'No artist',
                                              ),
                                              trailing: PopupMenuButton(
                                                itemBuilder:
                                                    (BuildContext context) {
                                                  return [
                                                    PopupMenuItem(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                NowPlayingPanelScreen(
                                                              songs:
                                                                  recentlyPlayedSongs[
                                                                      index],
                                                              allSongs:
                                                                  recentlyPlayedSongs,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: const Text("Play"),
                                                    ),
                                                    PopupMenuItem(
                                                      onTap: () {
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    AlertDialog(
                                                                      title: const Text(
                                                                          "Select Playlist"),
                                                                      content: SizedBox(
                                                                          height: 100,
                                                                          width: double.maxFinite,
                                                                          child: ListView.separated(
                                                                              separatorBuilder: (context, index) => const Divider(),
                                                                              itemCount: playListKey.length,
                                                                              itemBuilder: (context, index) {
                                                                                return InkWell(
                                                                                    onTap: () {},
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: Text(
                                                                                        playListKey[index],
                                                                                        style: const TextStyle(fontSize: 15),
                                                                                      ),
                                                                                    ));
                                                                              })),
                                                                    ));
                                                      },
                                                      child: const Text(
                                                          "Add to Playlist"),
                                                    ),
                                                    const PopupMenuItem(
                                                      value: '/data',
                                                      child: Text("Delete"),
                                                    ),
                                                    const PopupMenuItem(
                                                      value: '/data',
                                                      child: Text("Share"),
                                                    ),
                                                  ];
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }));
              }
            },
          ),
        ),
      ],
    );
  }
}
