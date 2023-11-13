import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class ContactSupport extends StatefulWidget {
  const ContactSupport({super.key});

  @override
  State<ContactSupport> createState() => _ContactSupportState();
}

final _key = GlobalKey<FormState>();

TextEditingController subjectcontroller = TextEditingController();
TextEditingController bodycontroller = TextEditingController();

  Future<void> launchEmail() async {

    final subject=subjectcontroller.text.trim();
    final body=bodycontroller.text.trim();

    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'beatbose.support@gmail.com', // Add your recipient email address here
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    await launchUrl(_emailLaunchUri);
  }

class _ContactSupportState extends State<ContactSupport> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text("Help and Support")),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _key,
          child: Column(
            children: [
             
               TextFormField(
                controller: subjectcontroller,
                decoration:const  InputDecoration(
                  hintText: "subject",
                  border: OutlineInputBorder()
                ),
              ),
              Divider(),
               TextFormField(
      
                maxLines: 10,
                            controller: bodycontroller,
                decoration:const  InputDecoration(
                  hintText: "message.......",
                  border: OutlineInputBorder()
                ),
              ),
      
              ElevatedButton(
                onPressed: (){
                  _key.currentState!.save();
                 print("sent");
                 launchEmail();
                },
                 child: const Text("sent"))
            ],
          ),
        ),
      ),
    );
  }
}