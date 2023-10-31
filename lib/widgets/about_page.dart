import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutPageScreen extends StatefulWidget {
  const AboutPageScreen({super.key});

  @override
  State<AboutPageScreen> createState() => _AboutPageScreenState();
}

class _AboutPageScreenState extends State<AboutPageScreen> {

  _showAboutUsDialog(){

    showModalBottomSheet(context: context, builder: (BuildContext context){

      return Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
           
              onPressed: (){}, icon:const  FaIcon(FontAwesomeIcons.google, ), label: const Text("Gmail")),
            ElevatedButton.icon(onPressed: (){}, icon: const  FaIcon(FontAwesomeIcons.instagram), label:const  Text("Insagram")),
            ElevatedButton.icon(onPressed: (){}, icon:const  FaIcon(FontAwesomeIcons.x), label:const  Text("Twitter")),
          ],
        ),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About"),),
      body:ListView(children: [
       const  SizedBox(
          height: 50,
        ),
         Center(
           child: Column(
            
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image.asset('assets/images/logo.png'),
                ),


                const Text("BEATBOSE", style:TextStyle(fontSize: 35),),
                
                const Padding(
                  padding:  EdgeInsets.only(top:8.0),
                  child:  Text(
                    "Version 1.0",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        // color: Colors.grey
                        ),
                  ),
                ),

               const Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      
                      children:  [
                        Padding(
                          padding:  EdgeInsets.only(left:70.0),
                          child: ListTile(
                                              
                            leading: FaIcon(FontAwesomeIcons.instagram),
                            title: Text("BeatBose on Instagram"),
                          ),
                        ),
                           Padding(
                             padding:  EdgeInsets.only(left:70.0),
                             child: ListTile(
                                                     leading: FaIcon(FontAwesomeIcons.reddit),
                                                     title: Text("BeatBose on Reddit"),
                                                   ),
                           ),
                           Padding(
                            padding:  EdgeInsets.only(left:70.0),
                             child: ListTile(
                                                     leading: FaIcon(FontAwesomeIcons.snapchat),
                                                     title: Text("BeatBose on Snapchat"),
                                                   ),
                           ),
                        
                      ],
                    ),
                  ),
                ),
                TextButton(onPressed: (){
                  _showAboutUsDialog();
                }, child: const Text("Contact Us")),
              ],
            ),
         )
      ],) ,
    );
  }
}