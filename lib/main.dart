import 'package:beatboseapp/databse/boxinstance.dart';
import 'package:beatboseapp/model/songs_adapter.dart';
import 'package:beatboseapp/splash_screen.dart';
import 'package:beatboseapp/theme/theme.dart';
import 'package:beatboseapp/theme/theme_provider.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';


const hiveMusic = 'songlibrary_box';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SongAdapterAdapter());

  await Hive.openBox(hiveMusic);

  final _box = InstanceBox.getInstance();

  List<String> keys = _box.keys.cast<String>().toList();

 

  if(!keys.contains("likedSongs")){
    List<SongAdapter> favourites =[];
    await _box.put('likedSongs', favourites);
  }

    List<String> recentKey =_box.keys.cast<String>().toList(); 

    if(!recentKey.contains('recently played')){
      List<SongAdapter> recentsongs =[];
      await _box.put('recently played', recentsongs);
    }

    List<String> mostlyKey = _box.keys.cast<String>().toList();

    if(!mostlyKey.contains('mostly played')){
      List<SongAdapter> mostlysongs =[];

      await _box.put('mostly played', mostlysongs);
    }

  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  final Future<FirebaseApp> _initialization =Firebase.initializeApp();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return themeChangeProvider;
          },
        )
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget ) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Style.themeData(themeChangeProvider.darkTheme, context),
            home: FutureBuilder(
              future: _initialization,
              builder: (context, snapshot){
                if(snapshot.hasError){
                  print("error");
                }

                if(snapshot.connectionState ==ConnectionState.done){
                  return SplashScreen();
                }
                return CircularProgressIndicator();
              },
              
              
              ),
           
          );
        },
      ),
    );
  }
}