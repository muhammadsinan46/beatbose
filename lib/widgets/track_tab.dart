import 'package:beatboseapp/databse/boxinstance.dart';
import 'package:beatboseapp/model/mostly_played_model.dart';
import 'package:beatboseapp/model/recently_played_model.dart';
import 'package:beatboseapp/model/songs_adapter.dart';
import 'package:beatboseapp/screens/nowplaying_screen.dart';

import 'package:just_audio/just_audio.dart';

import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';

class TrackScreenTab extends StatefulWidget {
  const TrackScreenTab({super.key, required this.hivesongs});
  final List<SongAdapter> hivesongs;

  @override
  State<TrackScreenTab> createState() => _TrackScreenTabState();
}

class _TrackScreenTabState extends State<TrackScreenTab> {
  bool isGrid = false;

  final AudioPlayer _audioPlayer = AudioPlayer();
  final RecentlyPlayed _recentlyPlayed = RecentlyPlayed();
  final MostlyPlayed _mostlyPlayed = MostlyPlayed();
  List<SongAdapter> mostlyPlayedSongs = [];
  bool isDescending = false;

  playSong(SongAdapter? song) {
    try {
      _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(song!.uri!)));
      _audioPlayer.play();
      _recentlyPlayed.addToRecentlyPlayed(song);
      _mostlyPlayed.addToMostlyPlayed(song);
    } on Exception {
      print("Error parsing song");
    }
  }

  Future<void> loadMostlyPlayedSongs() async {
    final songs = await _mostlyPlayed.getMostlyPlayed();
    mostlyPlayedSongs = songs;
  }

  List playlistey = [];
  final _box = InstanceBox.getInstance();

  getPlayList() {
    playlistey = _box.keys.toList();
  }

  @override
  void initState() {
    super.initState();
    loadMostlyPlayedSongs();
    getPlayList();
  }

  @override
  Widget build(BuildContext context) {
    List<SongAdapter> hivesongs = widget.hivesongs;
    return ListView(
      children: [
        SizedBox(
          height: 70,
          width: MediaQuery.of(context).size.width,
          child: Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        hivesongs.shuffle();
                      });
                    },
                    icon: const Icon(Icons.shuffle)),
                Row(
                  children: [
                    IconButton(
                      icon: isGrid == true
                          ? const Icon(Icons.grid_view)
                          : const Icon(Icons.list),
                      onPressed: () {
                        setState(() {
                          if (isGrid == true) {
                            isGrid = false;
                          } else {
                            isGrid = true;
                          }
                        });
                      },
                    ),
                    IconButton(
                        onPressed: () {
                          print("descenting");
                          setState(() => isDescending = !isDescending);
                        },
                        icon: const Icon(Icons.sort_by_alpha))
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
            height: 650,
            child: isGrid
                ? GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 4 / 3.5,
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8),
                    itemCount: hivesongs.length,
                    itemBuilder: (context, index) {
                      final sortedItems = isDescending
                          ? hivesongs.reversed.toList()
                          : hivesongs;
                      final song = sortedItems[index];
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NowPlayingPanelScreen(
                                    songs: hivesongs[index],
                                    allSongs: hivesongs,
                                  )));
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 12.0, right: 12.0),
                          child: Card(
                              child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                  width: 250,
                                  height: 100,
                                  child: Image.asset(
                                    'assets/images/images2.jpg',
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                  )),
                              ListTile(
                                title: Center(
                                    child: TextScroll(
                                  //mode:TextScrollMode.bouncing,
                                  song.song ?? 'Track $index',
                                  intervalSpaces: 10,
                                  velocity: const Velocity(
                                      pixelsPerSecond: Offset(20, 0)),
                                  delayBefore: const Duration(milliseconds: 50),
                                  style: const TextStyle(fontSize: 18),
                                )),
                                subtitle: Center(
                                    child: TextScroll(
                                  song.artist ?? 'No artist',
                                  style: const TextStyle(fontSize: 18),
                                  intervalSpaces: 10,
                                  velocity: const Velocity(
                                      pixelsPerSecond: Offset(50, 0)),
                                  delayBefore: const Duration(milliseconds: 50),
                                )),
                                trailing: PopupMenuButton(
                                    itemBuilder: (BuildContext context) {
                                  return [
                                    PopupMenuItem(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    NowPlayingPanelScreen(
                                                        songs: hivesongs[index],
                                                        allSongs: hivesongs)));
                                      },
                                      child: const Text("Play"),
                                    ),
                                    PopupMenuItem(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: const Text(
                                                      "Select Playlist"),
                                                  content: SizedBox(
                                                      height: 100,
                                                      width: double.maxFinite,
                                                      child: ListView.separated(
                                                          separatorBuilder:
                                                              (context,
                                                                      index) =>
                                                                  Divider(),
                                                          itemCount:
                                                              playlistey.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return InkWell(
                                                                onTap: () {},
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child: Text(
                                                                    playlistey[
                                                                        index],
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            15),
                                                                  ),
                                                                ));
                                                          })),
                                                ));
                                      },
                                      child: const Text("Add to Playlist"),
                                    ),
                                    const PopupMenuItem(
                                      value: '/data',
                                      child: Text("Delete"),
                                    ),
                                    const PopupMenuItem(
                                      value: '/data',
                                      child: Text("Share"),
                                    )
                                  ];
                                }),
                              )
                            ],
                          )),
                        ),
                      );
                    },
                  )
                : ListView.separated(
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: hivesongs.length,
                    itemBuilder: ((context, index) {
                      final sortedItems = isDescending
                          ? hivesongs.reversed.toList()
                          : hivesongs;
                      final song = sortedItems[index];
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NowPlayingPanelScreen(
                                    songs: hivesongs[index],
                                    allSongs: hivesongs,
                                  )));
                          // playSong(item.data![index].uri);
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
                            //mode:TextScrollMode.bouncing,
                            song.song ?? 'Track $index',
                            intervalSpaces: 10,
                            velocity:
                                const Velocity(pixelsPerSecond: Offset(20, 0)),
                            delayBefore: const Duration(milliseconds: 50),
                            style: const TextStyle(fontSize: 18),
                          ),
                          subtitle: TextScroll(
                            //mode:TextScrollMode.bouncing,
                            song.artist ?? 'No artist',
                            intervalSpaces: 10,
                            velocity:
                                const Velocity(pixelsPerSecond: Offset(20, 0)),
                            delayBefore: const Duration(milliseconds: 50),
                            style: const TextStyle(fontSize: 18),
                          ),
                          trailing: PopupMenuButton(
                              itemBuilder: (BuildContext context) {
                            return [
                              PopupMenuItem(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NowPlayingPanelScreen(
                                                  songs: hivesongs[index],
                                                  allSongs: hivesongs)));
                                },
                                child:const  Text("Play"),
                              ),
                              PopupMenuItem(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title:
                                                const Text("Select Playlist"),
                                            content: SizedBox(
                                                height: 100,
                                                width: double.maxFinite,
                                                child: ListView.separated(
                                                    separatorBuilder:
                                                        (context, index) =>
                                                          const   Divider(),
                                                    itemCount:
                                                        playlistey.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return InkWell(
                                                          onTap: () {},
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              playlistey[index],
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          15),
                                                            ),
                                                          ));
                                                    })),
                                          ));
                                },
                                child: Text("Add to Playlist"),
                              ),
                              PopupMenuItem(
                                value: '/data',
                                child: Text("Delete"),
                              ),
                              PopupMenuItem(
                                value: '/data',
                                child: Text("Share"),
                              )
                            ];
                          }),
                        ),
                      );
                    }))),
      ],
    );
  }
}
