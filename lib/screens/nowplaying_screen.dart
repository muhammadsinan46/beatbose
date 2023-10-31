import 'dart:async';
import 'package:beatboseapp/model/fav_model.dart';
import 'package:beatboseapp/model/recently_played_model.dart';
import 'package:beatboseapp/model/songs_adapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:linear_timer/linear_timer.dart';

class NowPlayingPanelScreen extends StatefulWidget {
  const NowPlayingPanelScreen(
      {Key? key, required this.songs, required this.allSongs})
      : super(key: key);
  final SongAdapter songs;
  final List<SongAdapter> allSongs;
  @override
  State<NowPlayingPanelScreen> createState() => _NowPlayingPanelScreenState();
}

class _NowPlayingPanelScreenState extends State<NowPlayingPanelScreen>
    with TickerProviderStateMixin {
  late LinearTimerController timercontroller = LinearTimerController(this);
  bool timeRuuning = false;
  bool isDark = false;
  bool isSleep = false;
  bool isExpanded = false;

  static const maxMinutes = 30;
  int minutes = maxMinutes;
  Timer? sleepRemainer;

  final audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  SongAdapter? playsong;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isColor = false;
  bool favsong = false;

  List<SongAdapter> favList = [];
  bool isLiked = false;
  final favouriteList = FavouriteList();

  final recentlyplayedList = RecentlyPlayed();

  String timeFormat(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
  }

  void startTimer() {
    sleepRemainer = Timer.periodic(const Duration(minutes: 1), (_) {
      setState(() => minutes--);
    });
  }

  @override
  void initState() {
    super.initState();
    setUrl(widget.songs);
    checkFavSongs(widget.songs);

    _init();
  }

  void _init() {
    audioPlayer.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          this.position = position;

          final currentSong = getplaySong();
          recentlyplayedList.addToRecentlyPlayed(currentSong!);
        });
      }
    });
    audioPlayer.durationStream.listen((duration) {
      if (mounted) {
        if (duration != null) {
          setState(() {
            this.duration = duration;
          });
        }
      }
    });
  }

  Future<bool> onWillpop() async {
    Navigator.of(context).pop(favList);
    return false;
  }

  void setUrl(SongAdapter songs) async {
    playsong = songs;
    await audioPlayer.setUrl(songs.uri!);
    playSong();
  }

  playSong() {
    audioPlayer.play();
    setState(() {
      _isPlaying = true;
    });
  }

  pauseSong() {
    setState(() {
      _isPlaying = false;
    });
    audioPlayer.pause();
  }

  SongAdapter? getplaySong() {
    return playsong;
  }

  playNext(SongAdapter songs) {
    int currentTrackIndex = widget.allSongs.indexOf(songs);
    audioPlayer.stop();

    if (widget.allSongs.last == songs) {
      setUrl(widget.allSongs.first);
    } else {
      SongAdapter nextSong = widget.allSongs[currentTrackIndex + 1];
      setUrl(nextSong);
    }
  }

  playPrev(SongAdapter songs) {
    int currentTrackIndex = widget.allSongs.indexOf(songs);
    audioPlayer.stop();

    if (widget.allSongs.first == songs) {
      setUrl(widget.allSongs.last);
    } else {
      SongAdapter preSong = widget.allSongs[currentTrackIndex - 1];
      setUrl(preSong);
    }
  }

  checkFavSongs(SongAdapter song) {
    List<SongAdapter> songs = favouriteList.getFavSong();
    if (songs.contains(song)) {
      setState(() {
        isLiked = true;
      });
    } else {
    
        isLiked = false;
      
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    timercontroller.dispose();
    super.dispose();
  }

  Widget _sleeperTimer(bool isDarkTheme, bool isSleep) {
    return Dialog(
      alignment: Alignment.topLeft,
      child: ExpansionTile(
        title: const Text(
          "Sleep timer",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("sleep timer: "),
              Transform.scale(
                scale: 0.5,
                child: CupertinoSwitch(
                  activeColor: Colors.tealAccent.shade400,
                  value: isSleep,
                  onChanged: (bool value) => setState(() {
                    isSleep = value;
                    if (isSleep) {
                      startTimer();
                      timercontroller.start();
                    } else {
                      timercontroller.reset();
                    }
                  }),
                ),
              ),
            ],
          ),
          Text("Time Remaining: $minutes"),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () {
                    timercontroller.start();
                  },
                  icon: Icon(
                    Icons.play_arrow,
                    color: isDarkTheme
                        ? const Color.fromARGB(89, 29, 233, 182)
                        : const Color.fromARGB(255, 36, 34, 167),
                  )),
              IconButton(
                  onPressed: () {
                    timercontroller.stop();
                  },
                  icon: Icon(
                    Icons.stop,
                    color: isDarkTheme
                        ? const Color.fromARGB(89, 29, 233, 182)
                        : const Color.fromARGB(255, 36, 34, 167),
                  )),
              IconButton(
                  onPressed: () {
                    timercontroller.reset();
                  },
                  icon: Icon(
                    Icons.restart_alt,
                    color: isDarkTheme
                        ? const Color.fromARGB(89, 29, 233, 182)
                        : const Color.fromARGB(255, 36, 34, 167),
                  ))
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             const  Padding(
                padding:  EdgeInsets.all(8.0),
                child: Text("0 min",
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 5,
                  width: 140,
                  child: GestureDetector(
                    onTap: () {
                      timercontroller.stop();
                    },
                    child: LinearTimer(
                      color: isDarkTheme
                          ? const Color.fromARGB(89, 29, 233, 182)
                          : const Color.fromARGB(255, 36, 34, 167),
                      backgroundColor: isDarkTheme
                          ? const Color.fromARGB(255, 112, 186, 167)
                          : const Color.fromARGB(255, 36, 34, 167),
                      forward: false,
                      duration: const Duration(minutes: 60),
                      controller: timercontroller,
                      onTimerEnd: () {
                        setState(() {
                          timeRuuning = false;
                        });
                      },
                    ),
                  ),
                ),
              ),
             const  Padding(
                padding:  EdgeInsets.all(8.0),
                child:  Text(
                  "30 min",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    checkFavSongs(playsong!);
    return Scaffold(
      // backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: const BackButton(
            // color: Colors.black,
            ),
        // backgroundColor: Colors.white,
        title: const Text(
          "NowPlaying",
          // style: TextStyle(color: Colors.black),
        ),
        // actionsIconTheme: const IconThemeData(color: Colors.black),
        actions: [
          PopupMenuButton(itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return _sleeperTimer(isDarkTheme, isSleep);
                      });
                },
                child: const Text("Sleep timer"),
              ),
              const PopupMenuItem(
                value: '/data',
                child: Text("Add to Playlist"),
              ),
              const PopupMenuItem(
                value: '/data',
                child: Text("Delete"),
              ),
              const PopupMenuItem(
                value: '/data',
                child: Text("Share"),
              )
            ];
          })
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 4/5,
                child: Center(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 18,
                                 color:isDarkTheme
              ? Color.fromARGB(108, 84, 141, 127)
              : Color.fromARGB(255, 166, 165, 247),
                                offset: Offset(4, 8))
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/images2.jpg',
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            favouriteList
                                .addToFav(playsong!)
                                .then((_) => checkFavSongs(playsong!));
                          },
                          icon: Icon(
                            Icons.favorite,
                            color: isLiked ? Colors.red : Colors.white,
                            size: 40,
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Column(
                children: [
                     Text(
                playsong!.song.toString(),
                style: const TextStyle(
                    fontSize: 17,
                    // color: Color.fromARGB(255, 9, 34, 77),
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "${playsong!.artist}",
                style: const TextStyle(
                  fontSize: 10,
                ),
              ),
                ],
              ),
             
              const SizedBox(height: 12),
              Card(
                // shadowColor:const Color.fromARGB(255, 9, 34, 77) ,
                elevation: 1,
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        // activeTrackColor: const Color.fromARGB(255, 9, 34, 77),
                        inactiveTrackColor:
                            const Color.fromARGB(255, 224, 224, 224),
                        trackShape: const RectangularSliderTrackShape(),
                        // thumbColor: const Color.fromARGB(255, 9, 34, 77),
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 0),
                      ),
                      child: Slider(
                          min: 0,
                          max: duration.inSeconds.toDouble(),
                          value: position.inSeconds.toDouble(),
                          onChanged: (value) {
                            final position = Duration(seconds: value.toInt());
                            audioPlayer.seek(position);
                          }),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(timeFormat(position.inSeconds)),
                          Text(timeFormat((duration - position).inSeconds)),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.shuffle,
                            // color: Color.fromARGB(255, 9, 34, 77),
                          ),
                          iconSize: 20,
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.skip_previous,
                            // color: Color.fromARGB(255, 9, 34, 77),
                          ),
                          iconSize: 48,
                          onPressed: () {
                            playPrev(playsong!);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            // color: Color.fromARGB(255, 9, 34, 77),
                          ),
                          iconSize: 64,
                          onPressed: () {
                            setState(() {
                              if (_isPlaying) {
                                audioPlayer.pause();
                              } else {
                                audioPlayer.play();
                              }
                              _isPlaying = !_isPlaying;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.skip_next,
                            //color: Color.fromARGB(255, 9, 34, 77)
                          ),
                          iconSize: 48,
                          onPressed: () {
                            playNext(playsong!);
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.repeat,
                            //color: Color.fromARGB(255, 9, 34, 77),
                          ),
                          iconSize: 25,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
