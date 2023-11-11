import 'dart:convert';

import 'package:beatboseapp/databse/boxinstance.dart';
import 'package:beatboseapp/model/songs_adapter.dart';

import 'package:beatboseapp/screens/recently_played.dart';

import 'package:beatboseapp/widgets/track_tab.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
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
      pickMusicFiles()async{
    if(kIsWeb){
      final localSongs = await FilePicker.platform.pickFiles(type: FileType.audio,
      allowMultiple: true
      );
      if(localSongs != null){
      
      
          dbSongs =localSongs.files.map((file) {
            final  bytes = file.bytes??Uint8List(0);

            final uri = 'data:audio/mpeg;base64,${base64Encode(bytes)}';
            return SongAdapter(id:null, song: file.name, artist: "unknown", duration: 0, uri: uri);
          }
          ).toList();
          
        await songbox.put('all Songs', dbSongs);
        setState(() {
          hivesongs =songbox.get('all Songs');
        });
      
      }

    }
  }
 
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(50, 50),
          child: TabBar(
           // indicatorColor: Colors.red,
            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // labelColor: Color.fromARGB(255, 9, 34, 77),
            tabs: [
     
            Tab(
              text: "RECENTLY PLAYED",
            ),
            Tab(
             // icon: IconButton(onPressed: (){}, icon: Icon(Icons.file_download)),
              text: "TRACKS",
            ),
          ]),
        ),
        body: Stack(
          children: [
            TabBarView(children: [
               PlayNowScreen(allSongs: hivesongs,),
              TrackScreenTab(
                hivesongs: hivesongs,
              )
            ]),

            if(kIsWeb)
            Positioned(
              top: 500,
              left: 750,
              child: FloatingActionButton(
                        shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
                child: const Icon(Icons.download),
                onPressed: (){
                  pickMusicFiles();
                }, ),
            )
          ],
        ),
      ),
    );
  }

  
}
