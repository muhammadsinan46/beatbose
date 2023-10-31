import 'package:hive/hive.dart';

part 'songs_adapter.g.dart';

@HiveType(typeId:1)

class SongAdapter extends HiveObject{

@HiveField(0)

 int ? id;
@HiveField(1)
 String? song;
 @HiveField(2)
 String? artist;
 
@HiveField(3)
 int? duration;

 @HiveField(4)
 String? uri;

 @HiveField(5)
 int? playCount;


  SongAdapter({
    required this.id,
    required this.song,
    required this.artist,
    required this.duration,
    required this.uri,
    this.playCount= 0,
  });
}