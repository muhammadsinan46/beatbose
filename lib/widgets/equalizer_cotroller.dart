// import 'package:equalizer_flutter/equalizer_flutter.dart';
// import 'package:flutter/material.dart';

// class EqualizerController extends StatefulWidget {

//   final int freq;
//   final int bandId;
//   // final double min;
//   // final double max;
//  final bool isEnabled;
//   final  List <int> bandlevelRange;
//   const EqualizerController({
//     super.key,
//     required this.freq,
//     required this.bandId,
//     // required this.min,
//     // required this.max,
//     required this.isEnabled,
//     required this.bandlevelRange
//   });

//   @override
//   State<EqualizerController> createState() => _EqualizerControllerState();
// }

// class _EqualizerControllerState extends State<EqualizerController> {
//     late double min, max;

// @override
//   void initState() {
//    min =widget.bandlevelRange[0].toDouble();
//    max =widget.bandlevelRange[1].toDouble();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Column(
//         children: [
//           SizedBox(
//             height: 250,
//             child: FutureBuilder<int>(
//               future: EqualizerFlutter.getBandLevel(widget.bandId),
//               builder: (context, snapshot) {
//                 var data = snapshot.data?.toDouble() ?? 0.0;
//                 return RotatedBox(
//                   quarterTurns: 3,
//                   child: SliderTheme(
//                       data: SliderTheme.of(context).copyWith(trackHeight: 1),
//                       child: Center(
//                         child: Slider(
//                           max: widget.max,
//                           min: widget.min,
//                           value: data,
//                           onChanged: (value) {
//                             setState(() {
//                               EqualizerFlutter.setBandLevel(
//                                   widget.bandId, value.toInt());
//                             });
//                           },
//                         ),
//                       )),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(
//             height: 15,
            
//           ),
//           Text("${widget.freq ~/1000} hz")
//         ],
//       ),
//     );
//   }
// }


// class SliderCustom extends RoundRangeSliderThumbShape{
//   Rect getPrefferedRect({
//     required RenderBox parentBox,
//     Offset offset  = Offset.zero,
//     required SliderThemeData slidertheme,
//     bool isEnabled =false,
//     bool isDiscrete =false  ,
//   }){
//     final double? trackHeight =slidertheme.trackHeight;
//     final double trackLeft =offset.dx;
//     final double trackTop =(parentBox.size.height)/2;
//     final double trackweight =230;

//     return Rect.fromLTWH(trackLeft, trackTop, trackweight, trackHeight!);
    

//   }
// }