// import 'package:beatboseapp/Modules/EqualizerCotroller.dart';
// import 'package:equalizer_flutter/equalizer_flutter.dart';
// import 'package:flutter/material.dart';

// class EqualizerScreen extends StatefulWidget {
//   final bool isEnabled;
//   final  List <int> bandlevelRange;
//   const EqualizerScreen({super.key, required this.isEnabled, required this.bandlevelRange});

//   @override
//   State<EqualizerScreen> createState() => _EqualizerScreenState();
// }

// class _EqualizerScreenState extends State<EqualizerScreen> {
//   late double min, max;
//   String? _selectedvalue;
//   late Future<List<String >> fethPresets;


//   @override
//   void initState() {
//     EqualizerFlutter.init(0);
//    min =widget.bandlevelRange[0].toDouble();
//    max =widget.bandlevelRange[1].toDouble();
//    fethPresets =EqualizerFlutter.getPresetNames();
//     super.initState();
//   }

//   @override
//   void dispose() {

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {

//     int bandId =0;
//     return SizedBox(
//       height: MediaQuery.of(context).size.height,
//       width: MediaQuery.of(context).size.width,
//       child: Column(
//         children: [
//           Container(
//             decoration: BoxDecoration(color: Colors.grey),
//             height: 400,
//             width: 400,
//               child: FutureBuilder <List<int>> (
//                 future: EqualizerFlutter.getCenterBandFreqs(),
//                 builder:(context, snapshot) {
//                   return snapshot .connectionState ==ConnectionState.done?
//                   Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: 
//                         snapshot.data!.map(
//                           (item) => EqualizerController(
//                           freq: item, 
//                           bandId: bandId++, 
//                           min: min,
//                            max: max
//                            )).toList(),
//                       ),
//                       Padding(padding: EdgeInsets.all(10),
//                       child:_buildPresets(),
//                       )
//                     ],
//                   ):const CircularProgressIndicator();
                  
//                 }, ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPresets(){
//     return FutureBuilder<List<String>>(
//       future: fethPresets,
//        builder:(context, snapshot) {
//       if(snapshot.hasData){
//         final presets = snapshot.data;
//         if(presets!.isEmpty) return const Text("No Fx Available");
//         return DropdownButtonFormField(
//             decoration: InputDecoration(
//               labelText: "Fx Booster",
//               border: OutlineInputBorder()
//             ),
//             value: _selectedvalue,
//           items: presets.map((String value){
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Text(value));
//           }).toList(),
//            onChanged: widget.isEnabled?
//            (String ? value){
//             EqualizerFlutter.setPreset(value!);
//             setState(() {
//               _selectedvalue =value;
//             });
//            }
//        :null );
//       }else if(snapshot.hasError){
// return Text(snapshot.error.toString());
//       }else{
//         return const CircularProgressIndicator();
//       }
      
//     }
//     );
//   }
// }