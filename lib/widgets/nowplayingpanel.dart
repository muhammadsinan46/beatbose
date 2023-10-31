// import 'package:flutter/material.dart';

// class NowPlayingPanel extends StatefulWidget {
//   const NowPlayingPanel({super.key});

//   @override
//   State<NowPlayingPanel> createState() => _NowPlayingPanelState();
// }

// class _NowPlayingPanelState extends State<NowPlayingPanel> {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//                   child: Row(
//                     children: [
//                       SizedBox(
//                         height: 50,
//                         width: 60,
//                         child: Image.asset(
//                           'assets/images/images2.jpg',
//                           fit: BoxFit.cover,
//                           alignment: Alignment.center,
//                         ),
//                       ),
//                       const Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: SizedBox(
//                           height: 50,
//                           width: 270,
//                           child: Column(
//                             children: [
//                               Text("Music name"),
//                               Text("Artist name"),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const Row(
//                         children: [
//                           Icon(Icons.favorite, size: 32),
//                           Icon(
//                             Icons.play_arrow,
//                             size: 40,
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                 );
//   }
// }