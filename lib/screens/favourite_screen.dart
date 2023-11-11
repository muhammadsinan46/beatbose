// ignore_for_file: use_build_context_synchronously

import 'package:just_audio/just_audio.dart';
import 'package:beatboseapp/databse/boxinstance.dart';
import 'package:beatboseapp/model/fav_model.dart';
import 'package:beatboseapp/model/songs_adapter.dart';
import 'package:beatboseapp/screens/nowplaying_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// import 'package:on_audio_query/on_audio_query.dart';
import 'package:hive/hive.dart';
import 'package:text_scroll/text_scroll.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen(
      {super.key, required this.favouriteList, required this.name});
  final List<SongAdapter> favouriteList;
  final String name;

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final favplayer = AudioPlayer();
  bool _isPlaying = false;
  SongAdapter? favplay;
  List<SongAdapter> favouriteList = [];
  bool isFav = false;
  Box<List<SongAdapter>>? songbox;
  Box<List<SongAdapter>> getInstanceSong() {
    return songbox ??= Hive.box('musicbox');
  }

  List<SongAdapter> favList = [];
  final favouritedb = FavouriteList();
  final _box = InstanceBox.getInstance();

  List<AudioPlayer> favPlayList = [];

  int currentIndex = 0;

  setFavUrl(SongAdapter songs) async {
    for (var songs in widget.favouriteList) {
      await favplayer.setUrl(songs.uri!);
      favPlayList.add(favplayer);
    }
    favplay = songs;

    favPlaySong();
  }

  favPlaySong() {
    favplayer.play();
    setState(() {
      _isPlaying = true;
    });
  }

  favPauseSong() {
    setState(() {
      _isPlaying = false;
    });
    favplayer.pause();
  }

  SongAdapter? getplaySong() {
    return favplay;
  }

  getFavSongs() {
    favList = favouritedb.getFavSong();
  }

  updateFavSong(List<SongAdapter> songs) {
    setState(() {
      favouriteList = songs;
    });
  }

  // toggleFav(SongAdapter song) async {
  //   final box = InstanceBox.getInstance();
  //   final List<SongAdapter> likedSongs =
  //       box.get('likedSongs').toList().cast<SongAdapter>();
  //   if (likedSongs.contains(song)) {
  //     likedSongs.remove(song);
  //     favList.remove(song);

  //     print("song removed $song");
  //   }
  //   //  else {
  //   //   likedSongs.add(song);
  //   // }
  //   await box.put('likedSongs', likedSongs);
  //   getFavSongs();
  // }

  deleteFavList() {
    _box.delete('likedSongs');
  }

  deleteSong(SongAdapter song) async {

      setState(() {
        favList.remove(song);
        
      });
    // await toggleFav(song);

  
    // Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => FavouriteScreen(
    //               favouriteList: const [],
    //               name: widget.name,
    //             )));
  }

  


  @override
  void initState() {
    super.initState();
    getFavSongs();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: 70,
          width: MediaQuery.of(context).size.width,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NowPlayingPanelScreen(
                                    songs: favList[currentIndex],
                                    allSongs: favList)));
                      },
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 35,
                      )),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            favList.shuffle();
                          },
                          icon: const Icon(Icons.shuffle)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 700,
          child: favList.isEmpty
              ? const Center(
                  child: Text("No favourites available"),
                )
              : ListView.builder(
                  itemCount: favList.length,
                  itemBuilder: ((context, index) {
                    return Slidable(
                      startActionPane: ActionPane(
                        motion: const StretchMotion(),
                        children: [
                          SlidableAction(
                            label: "Remove",
                            backgroundColor: Colors.red,
                            onPressed: (context) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Confirm to delete"),
                                      content: const Text(
                                          "Are you sure you want to delete?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("cancel")),
                                        TextButton(
                                            onPressed: () async {
                                              setState(() {
                                                favList.removeAt(index);
                                                Navigator.of(context).pop();
                                              });

                                              if (index >= 0 &&
                                                  index < favList.length) {
                                                final song = favList[index];

                                                deleteSong(song);
                                              }
                                            },
                                            child: const Text("Delete"))
                                      ],
                                    );
                                  });
                            },
                          )
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NowPlayingPanelScreen(
                                      songs: favList[index],
                                      allSongs: favList)));
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
                              title:
                                 TextScroll(
                            //mode:TextScrollMode.bouncing,
                            "${favList[index].song}"
                        ,
                            intervalSpaces: 10,
                            velocity:
                                const Velocity(pixelsPerSecond: Offset(20, 0)),
                            delayBefore: const Duration(milliseconds: 50),
                            style: const TextStyle(fontSize: 18),
                          ),
                              
                              subtitle:   TextScroll(
                            //mode:TextScrollMode.bouncing,
                            "${favList[index].artist}"
                        ,
                            intervalSpaces: 10,
                            velocity:
                                const Velocity(pixelsPerSecond: Offset(20, 0)),
                            delayBefore: const Duration(milliseconds: 50),
                            style: const TextStyle(fontSize: 18),
                          ),
                          
                              trailing: IconButton(
                                onPressed: () {

                                    showDialog(context: context, builder: (context){
                                       return AlertDialog(
                                        title:const Text("Select playlist"),

                                        content:const SizedBox(
                                                        height: 50,
                                                        child: Column(
                                                          children: [
                                                            Text("playlist1"),
                                                            Text("playlist2"),
                                                          ],
                                                        ),
                                                      ),
                                        actions: [
                                        TextButton(onPressed: (){
                                          Navigator.of(context).pop();
                                        }, child: const Text("Cancel")),
                                         TextButton(onPressed: (){
                                          Navigator.of(context).pop();
                                        }, child: const Text("Ok")),
                                        ],
                                      );


                                    });
                                        
                                     
                                    
                                },
                                icon: const Icon(Icons.playlist_add),
                              )),
                        ),
                      ),
                    );
                  })),
        ),
      ],
    );
  }
}


