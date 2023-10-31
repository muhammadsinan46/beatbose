import 'package:beatboseapp/databse/boxinstance.dart';
import 'package:hive/hive.dart';
import 'package:beatboseapp/model/playlist_model.dart';
import 'package:beatboseapp/model/songs_adapter.dart';
import 'package:flutter/material.dart';
import 'package:beatboseapp/widgets/playlist_song.dart';

class PlayListScreen extends StatefulWidget {
  const PlayListScreen({super.key});

  @override
  State<PlayListScreen> createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  PlaylistSong playlistdb = PlaylistSong();
  List<SongAdapter> playlistSongs = [];

  SongAdapter? currentSong;

  Box<List<SongAdapter>>? songbox;
  List<SongAdapter> playlist = [];

  final textcontroller = TextEditingController();
  bool isEmpty = false;

  updatePLaylistSong(List<SongAdapter> songs) {
    setState(() {
      playlistSongs = songs;
    });
  }

  Box<List<SongAdapter>> getplaylistIntance() {
    return songbox ??= Hive.box('musicbox');
  }

  void removeFromPlayList(SongAdapter songs) async {
    final box = getplaylistIntance();

    playlist.removeWhere((element) => element == songs);
    await box.put('playListSongs', playlist);
    setState(() {
      playlist = playlist;
    });
  }

  List playlistKey = [];

  final _box = InstanceBox.getInstance();

  getPlayList() {
    playlistKey = _box.keys.toList();
  }

  addPlayList(String playlistname) async {
    List playlistKey = [];
    List keys = _box.keys.toList();

    if (!keys.contains(playlistname)) {
      await _box.put(playlistname, playlistKey);
    }
  }

  renamePlayList(String oldName, String newName)async{
      final box = InstanceBox.getInstance();
      final playlistKey = box.get(oldName);
      await box.delete(oldName);

      await box.put(newName, playlistKey);
      setState(() {
          playlistKey.remove(oldName);
          playlistKey.add(newName);
        
      });
  }
  

  void deletePlaylist(String playlistname) async {
    setState(() {
      playlistKey.remove(playlistname);
    });

    await _box.delete(playlistname);
    
  }

  @override
  void initState() {
    getPlayList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("PlayList")),
        body: Column(
          children: [
            TextButton(
                onPressed: () {
                  setState(() {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Create new Playlist"),
                        content: SizedBox(
                          height: 150,
                          width: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text("Title:"),
                              TextField(
                                controller: textcontroller,
                                decoration: const InputDecoration(
                                    hintText: "Playlist name"),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Cancel")),
                                  ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          addPlayList(textcontroller.text);
                                          Navigator.of(context).pop();

                                          Navigator.pushReplacement(
                                              context,
                                              (MaterialPageRoute(
                                                  builder: (context) =>
                                                      const PlayListScreen())));
                                        });
                                      },
                                      child: const Text("Create")),
                                ],
                              )
                            ],
                          ),
                        ),
                        // actions: [],
                      ),
                    );
                  });
                },
                child: const Text("Create playlist")),
            Expanded(
              child: ListView.builder(
                  itemCount: playlistKey.length,
                  itemBuilder: (context, index) {
                    final playlistName = playlistKey[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 70,
                            child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PlayListSong(
                                              name: playlistName)));
                                },
                                leading: SizedBox(
                                  height: 70,
                                  width: 70,
                                  child: Image.asset(
                                    'assets/images/playlist.jpg',
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                  ),
                                ),
                                title: Text(
                                  playlistName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                trailing: PopupMenuButton(
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem(
                                          onTap: () {},
                                          child: const Text("Play ")),
                                       PopupMenuItem(
                                        onTap: (){
                                            setState(() {
                                              showDialog(context: context, builder: (context)=> AlertDialog(

                                                  title:const Text("Rename Playlist"),
                                                  content: TextField(
                                                    controller: textcontroller,
                                                    decoration: InputDecoration(
                                                      hintText: playlistName
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(onPressed: (){
                                                      Navigator.of(context).pop();
                                                    }
                                                    , child: const Text("Cancel")),
                                                    TextButton(onPressed: (){
                                                      String newPlaylistname = textcontroller.text;

                                                      if(newPlaylistname.isNotEmpty){
                                                        renamePlayList(playlistName, newPlaylistname);

                                                        Navigator.of(context).pop();
                                                           Navigator.pushReplacement(
                                              context,
                                              (MaterialPageRoute(
                                                  builder: (context) =>
                                                      const PlayListScreen())));
                                                      }

                                                    }, child: Text("Rename"))
                                                  ],


                                              ));
                                            });
                                        },
                                          child: Text("Rename")),
                                      PopupMenuItem(
                                          onTap: () {
                                            setState(() {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            "Cancel")),
                                                    TextButton(
                                                        onPressed: () {
                                                          deletePlaylist(
                                                              playlistName);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            "Delete")),
                                                  ],
                                                  title: const Text(
                                                      "Delete palylist"),
                                                  content: const Text(
                                                      "Are you sure?"),
                                                ),
                                              );
                                            });
                                          },
                                          child: const Text("Delete"))
                                    ];
                                  },
                                ))),
                      ),
                    );
                  }),
            ),
          ],
        ));
  }
}
