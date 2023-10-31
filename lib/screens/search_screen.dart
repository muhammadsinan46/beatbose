import 'package:beatboseapp/databse/boxinstance.dart';
import 'package:beatboseapp/model/fav_model.dart';
import 'package:beatboseapp/model/songs_adapter.dart';
import 'package:beatboseapp/screens/nowplaying_screen.dart';
import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';

class SearchScreen extends StatefulWidget {
const  SearchScreen({Key? key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchcontroller = TextEditingController();

  bool fetchingSongs = false;
  List<SongAdapter> allSongs = [];
  bool isFav = false;
  bool isLiked = false;
  List<SongAdapter> favList = [];
  SongAdapter? searchSong;

  String selectedPlayList ="";

  final favdb = FavouriteList();

  addToPlayList(String playListName){
    setState(() {
      selectedPlayList =playListName;
    });

  }

  void _showPlaylist(){

   
  }

  checkLikedSong(SongAdapter song) {
    List<SongAdapter> songs = favdb.getFavSong();

    if (songs.contains(song)) {
      setState(() {
        isLiked = true;
      });
    } else {
      isLiked = false;
    }
  }

  void toggleFavourite() {
    setState(() {
      isFav = !isFav;
    });
  }

  final box = InstanceBox.getInstance();

  getSongs() {
    allSongs = box.get('all songs') ?? [];
  }

  String searchText = "";
  List<SongAdapter>? result = [];

  clearSearch() {
    box.delete('all songs');
  }

  @override
  void initState() {
    super.initState();
    getSongs();
    getPlayList();

   if (searchSong != null) {
  checkLikedSong(searchSong!);
}
  }
  
  List playlistey =[];
  final _box = InstanceBox.getInstance();

  getPlayList (){
    playlistey = _box.keys.toList();
  }

  @override
  Widget build(BuildContext context) {

    if (searchText.isEmpty) {
      result = allSongs;
    }
     if (searchSong != null) {
  checkLikedSong(searchSong!);
}



    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              child: TextField(
                controller: _searchcontroller,
                onChanged: (value) {
                  searchText = value;
                  print(searchText);
                  result = allSongs
                      .where((element) =>
                          (element.song ?? "").toLowerCase().contains(searchText.toLowerCase()))
                      .toList();
                  setState(() {
                    print('result = ${result!.length}');
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => _searchcontroller.clear(),
                  ),
                  hintText: 'What you want to listen to?',
                ),
              ),
            ),
          ),
          if (fetchingSongs)
            const CircularProgressIndicator()
          else if (allSongs.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  'No Songs Found',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Recent Searches",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          const Divider(
            height: 25,
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: result!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NowPlayingPanelScreen(
                          songs: result![index],
                          allSongs: result!,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
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
                      title:TextScroll(
                            //mode:TextScrollMode.bouncing,
                            result![index].song ?? "Track$index",
                            intervalSpaces: 10,
                            velocity:
                                const Velocity(pixelsPerSecond: Offset(20, 0)),
                            delayBefore: const Duration(milliseconds: 50),
                            style: const TextStyle(fontSize: 18),
                          ),
                      
                      
                      subtitle:
                      TextScroll(
                            //mode:TextScrollMode.bouncing,
                            result![index].artist ?? "No artist",
                            intervalSpaces: 10,
                            velocity:
                                const Velocity(pixelsPerSecond: Offset(20, 0)),
                            delayBefore: const Duration(milliseconds: 50),
                            style: const TextStyle(fontSize: 18),
                          ),
                   
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PopupMenuButton(
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(
                                  onTap: (){
                                      showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title:
                                                     const  Text("Select Playlist"),
                                                  content:  SizedBox(
                                               height: 100,
                                                    width:double.maxFinite ,
                                                    child:ListView.separated(
                                                      separatorBuilder: (context, index) => Divider(),
                                                      itemCount: playlistey.length,
                                                      itemBuilder: (context, index){
    
                                                        return InkWell(
                                                        onTap: () {
                                                          
                                                        },                                                          
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text(playlistey[index], style: const TextStyle(fontSize: 15),),
                                                          )
                                                          );})
                                                      
                                                        
                                                  ),
                                               
                                                ));
    
                                  },
                                  child: Text("Add to Playlist"),
                                ),
                                PopupMenuItem(
                                  onTap: () {
                                    toggleFavourite();
                                    favdb.addToFav(searchSong!);
                                    checkLikedSong(searchSong!);
                                  },
                                  child: Text(isLiked
                                      ? 'Remove from Favourite'
                                      : "Add to Favourite"),
                                ),
                               const  PopupMenuItem(
                                  value: '/data',
                                  child: Text("Share"),
                                ),
                              ];
                            },
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                result!.removeAt(index);
    
                              });
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
