import 'package:beatboseapp/databse/boxinstance.dart';
import 'package:beatboseapp/model/songs_adapter.dart';
import 'package:flutter/material.dart';

class AddPlayListSong extends StatefulWidget {
  const AddPlayListSong({
    Key? key,
    required this.onAddSong,
  }) : super(key: key);

  final Function(List<SongAdapter>) onAddSong;

  @override
  State<AddPlayListSong> createState() => _AddPlayListSongState();
}

class _AddPlayListSongState extends State<AddPlayListSong> {
  SongAdapter? searchSong;
  List<SongAdapter> allSongs = [];
  bool fetchingSongs = false;

  final TextEditingController _playlsitcontroller = TextEditingController();

  final box = InstanceBox.getInstance();

  getAllSongs() {
    allSongs = box.get('all songs') ?? [];
  }

  String searchText = "";
  List<SongAdapter>? result = [];

  @override
  void initState() {
    super.initState();
    getAllSongs();
  }

  selectSong(SongAdapter song) {
    widget.onAddSong([song]); // Call the callback to add the selected song(s)
  }

  @override
  Widget build(BuildContext context) {
    if (searchText.isEmpty) {
      result = allSongs;
    }
    return Card(
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 5,
                child: TextField(
                  controller: _playlsitcontroller,
                  onChanged: (value) {
                    searchText = value;
                    result = allSongs
                        .where((element) =>
                            (element.song ?? "")
                                .toLowerCase()
                                .contains(searchText.toLowerCase()))
                        .toList();
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => _playlsitcontroller.clear(),
                    ),
                    hintText: 'search here..',
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
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount: result!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectSong(result![index]);
                          Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Color.fromARGB(255, 3, 30, 52),
                          content: Text("song added successfully")));
                        });
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
                          title: Text(result![index].song ?? "Track$index"),
                          subtitle: Text(result![index].artist ?? "No artist"),
                          trailing: const Icon(Icons.remove),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}