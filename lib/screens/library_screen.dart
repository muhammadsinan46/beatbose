import 'package:beatboseapp/screens/playlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(
              Icons.queue_music,
              // color: Colors.white,
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              // color: Colors.grey,
            ),
            title: const Text(
              'Playlists',
              // style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Handle tap on Playlists
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => const PlayListScreen()));
            },
          ),
          const Divider(),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.whatsapp,),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              // color: Colors.grey,
            ),
            title: const Text(
              'Whatsapp Audio',
              // style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Handle tap on Albums
            },
          ),
          const Divider(),
    
          ListTile(
            leading: const Icon(
              Icons.library_music,
              // color: Colors.white,
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              // color: Colors.grey,
            ),
            title: const Text(
              'All Songs',
              // style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Handle tap on Artists
            },
          ),
          
          
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.music_video,
              // color: Colors.white,
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              // color: Colors.grey,
            ),
            title: const Text(
              'Mostly played',
              // style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Handle tap on Folders
            },
          ),
          const Divider(),
    
        ],
      ),
    );
  }
}