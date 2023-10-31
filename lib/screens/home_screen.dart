import 'package:beatboseapp/databse/boxinstance.dart';
import 'package:beatboseapp/model/songs_adapter.dart';

import 'package:beatboseapp/screens/recently_played.dart';

import 'package:beatboseapp/widgets/track_tab.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, });

  

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final OnAudioQuery _audioQuery = OnAudioQuery();
  bool isGrid = false;
  bool fetchingSongs = false;
  bool permissionStatus = false;

  final songbox = InstanceBox.getInstance();
  List<SongModel> localSongs = [];
  List<SongAdapter> dbSongs = [];
  List<SongAdapter> hivesongs = [];

  playSong(String? song) {
    try {
      _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(song!)));
      _audioPlayer.play();
    } on Exception {
      print("Error parsing song");
    }
  }

  checedPermission({bool retry = false}) async {
    permissionStatus = await _audioQuery.checkAndRequest(retryRequest: retry);

    if (permissionStatus) {
      fetchSongs();
    }
  }

  fetchSongs() async {
    fetchingSongs = true;

    localSongs = await _audioQuery.querySongs(sortType: SongSortType.TITLE);

    dbSongs = localSongs
        .map((e) => SongAdapter(
            id: e.id,
            song: e.title,
            artist: e.artist,
            duration: e.duration,
            uri: e.uri,
      
            ))
        .toList();

    await songbox.put('all songs', dbSongs);
    setState(() {
      hivesongs = songbox.get('all songs');
    });
    fetchingSongs = false;
  }

  @override
  void initState() {
    super.initState();
    checedPermission();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(50, 50),
          child: Container(
            // color: Colors.white,
            child: const TabBar(
             // indicatorColor: Colors.red,
              labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              // labelColor: Color.fromARGB(255, 9, 34, 77),
              tabs: [
     
              Tab(
                text: "RECENTLY PLAYED",
              ),
              Tab(
                text: "TRACKS",
              ),
            ]),
          ),
        ),
        body: TabBarView(children: [
           PlayNowScreen(allSongs: hivesongs,),
          TrackScreenTab(
            hivesongs: hivesongs,
          )
        ]),
      ),
    );
  }

  
}
