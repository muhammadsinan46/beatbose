import 'package:beatboseapp/screens/favourite_screen.dart';
import 'package:beatboseapp/screens/home_screen.dart';
import 'package:beatboseapp/screens/library_screen.dart';
import 'package:beatboseapp/screens/search_screen.dart';
import 'package:beatboseapp/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final _screens = [
     const HomeScreen(),
    const SearchScreen(),
    const LibraryScreen(),
    const FavouriteScreen(
      favouriteList: [],
      name: "",
    ),
  ];

  final List <String> _titles =['HOME','SEARCH', 'LIBRARY', 'FAVOURITE'];
    String title = "BEATBOSE";
    void screenTitle(String newtitle){
      setState(() {
        
        title = newtitle;
      });

    }

  Widget _appBar() {
    return Card(
      child: SafeArea(
          child: SizedBox(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SettingsScreen()));
                      },
                      icon: const Icon(Icons.settings),
                    )
                  ],
                ),
              ))),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(
            MediaQuery.of(context).size.width,
            70,
          ),
          child: _appBar()),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        iconSize: 32,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_music), label: 'Library'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favourite'),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            title = _titles[index];
          });
        },
      ),
    );
  }
}
