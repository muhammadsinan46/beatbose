

import 'package:beatboseapp/databse/boxinstance.dart';
import 'package:beatboseapp/model/songs_adapter.dart';

class FavouriteList{

List<SongAdapter> getFavSong(){
  final songbox = InstanceBox.getInstance();
  final List <SongAdapter>likedSongs =songbox.get('likedSongs')?.toList().cast<SongAdapter>() ??[];
  return likedSongs ;
}


addToFav(SongAdapter songs)async{
  final songbox = InstanceBox.getInstance();
   final List <SongAdapter>likedSongs =songbox.get('likedSongs').toList().cast<SongAdapter>();

   final keys = songbox.keys.toList();
   print("this is: $keys");

   if(likedSongs.contains(songs)){
    likedSongs.remove(songs);
    await songbox.put('likedSongs', likedSongs);

   }else{
    likedSongs.add(songs);
    await songbox.put('likedSongs', likedSongs);
    print("successfully added");
   }
}



}