import 'dart:async';

import 'package:beatboseapp/theme/theme_provider.dart';
import 'package:beatboseapp/widgets/about_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
     {
 
  final Uri _privacyuri = Uri.parse('https://doc-hosting.flycricket.io/beatbose-privacy-policy/cc3f85cf-957a-40b7-8bc6-722d2b80cdef/privacy');
  final Uri _termsuri = Uri.parse('https://doc-hosting.flycricket.io/beatbose-terms-of-use/d2116b44-5621-475c-baf2-8b23624d7c8f/terms');



  Future<void> _privacyurl()async{
    if(!await launchUrl(_privacyuri)){
      throw Exception('Could not launch $_privacyuri');
    }

  }

  Future <void> _termsUrl()async{
    if(!await launchUrl( _termsuri )){

throw Exception('could not launch$_privacyuri');
    }
  }
 

  @override
  void dispose() {
  
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange =Provider.of<DarkThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        //backgroundColor: Colors.white,
        
        title: Text("Settings",),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            height: 40,
            child: ListTile(
              leading: const Text(
                "Equalizer",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {},
              ),
            ),
          ),
          const Divider(),
          SizedBox(
            height: 40,
            child: ListTile(
              leading: const Text(
                "Dark mode ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
              trailing: Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  activeColor:  Colors.tealAccent.shade400,
                  value: themeChange.darkTheme,
                  onChanged: (bool value) => 
                  themeChange.darkTheme =value
                  
                ),
              ),
            ),
          ),
          const Divider(),

 
          SizedBox(
            height: 40,
            child: ListTile(
              onTap: _termsUrl,
              leading: const Text(
                "Terms of Service",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  setState(() {});
                },
              ),
            ),
          ),
          const Divider(),
          SizedBox(
            height: 40,
            child: ListTile(
              onTap: _privacyurl,
              leading: const Text(
                "Privacy Policy",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {},
              ),
            ),
          ),
          const Divider(),
          SizedBox(
            height: 40,
            child: ListTile(
              leading: const Text(
                "Help and Support",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {},
              ),
            ),
          ),
          const Divider(),
          SizedBox(
            height: 40,
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return const AboutPageScreen();
                }));
              },
              leading: const Text(
                "About",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {},
              ),
            ),
          ),
          const Divider(),
          const SizedBox(
            height: 50,
          ),
          Column(
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: Image.asset('assets/images/logo.png'),
              ),
              const Text(
                "Version 1.0",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    // color: Colors.grey
                    ),
              )
            ],
          )
        ],
      ),
    );
  }
}
