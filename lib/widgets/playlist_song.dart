import 'package:beatboseapp/databse/boxinstance.dart';
import 'package:beatboseapp/model/songs_adapter.dart';
import 'package:beatboseapp/screens/nowplaying_screen.dart';
import 'package:beatboseapp/widgets/add_playlist.dart';
import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';

class PlayListSong extends StatefulWidget {
  const PlayListSong({super.key, required this.name});
  final String name;
  @override
  State<PlayListSong> createState() => _PlayListSongState();
}

class _PlayListSongState extends State<PlayListSong> {
  List<SongAdapter> playlistSongs = [];
  final _box = InstanceBox.getInstance();
  List<SongAdapter> favList = [];

  getPlayList() {
    var playlist = _box.get(widget.name);

    if (playlist != null) {
      playlistSongs = playlist.toList().cast<SongAdapter>();
    } else {
      playlistSongs = [];
    }
  }

  addSongToPlayList(List<SongAdapter> newSongs) {
    playlistSongs.addAll(newSongs);
    _box.put(widget.name, playlistSongs);
  }

  @override
  void initState() {
    super.initState();
    getPlayList();
  }

  void deltePlaylist(String playlistSongs) {
    _box.delete(playlistSongs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {});
                },
                icon: const Icon(Icons.refresh))
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return SizedBox(
                    height: 400,
                    width: 400,
                    child: AddPlayListSong(onAddSong: (selectedSongs) {
                      addSongToPlayList(selectedSongs);
                    }),
                  );
                });
          },
          child: const Icon(Icons.add),
        ),
        body: playlistSongs.isEmpty
            ? const Center(
                child: Text(
                  'No Songs',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                itemCount: playlistSongs.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NowPlayingPanelScreen(
                                  songs: playlistSongs[index],
                                  allSongs: playlistSongs)));
                    },
                    child: Card(
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
                            "${playlistSongs[index].song}",
                            intervalSpaces: 10,
                            velocity:
                                const Velocity(pixelsPerSecond: Offset(20, 0)),
                            delayBefore: const Duration(milliseconds: 50),
                            style: const TextStyle(fontSize: 18),
                          ),
                          subtitle: TextScroll(
                            //mode:TextScrollMode.bouncing,
                            "${playlistSongs[index].artist}",
                            intervalSpaces: 10,
                            velocity:
                                const Velocity(pixelsPerSecond: Offset(20, 0)),
                            delayBefore: const Duration(milliseconds: 50),
                            style: const TextStyle(fontSize: 18),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text("confirm to delete"),
                                        content: const Text(
                                            "Are you sure you want to delete ?"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Cancel")),
                                          TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  playlistSongs.removeAt(index);
                                                  _box.put(widget.name,
                                                      playlistSongs);
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                              child: const Text("Delete"))
                                        ],
                                      ));
                            },
                          )),
                    ),
                  );
                }));
  }
}

// import 'dart:developer';

