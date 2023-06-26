import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color(0xFF040404),
        title: Text('About Us'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Our Home Automation System',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Our home automation system consists of a robot and a mobile app to control it. It provides a range of functionalities to effectively manage your home and save time. Some of its key features include:',
                style: TextStyle(fontSize: 16,color: Colors.white,),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: ClipRect(child: Icon(Icons.security,color: Colors.yellow,)),
                    title: Text('Home Surveillance',style: TextStyle(color: Colors.white),),
                    subtitle: Text('Ensure the security of your home',style: TextStyle(color: Colors.white),),
                  ),

                  ListTile(
                    leading: Icon(Icons.lightbulb,color:Colors.yellow),
                    title: Text('Automatic Lighting',style: TextStyle(color: Colors.white),),
                    subtitle: Text('Effortless control of lighting in your home',style: TextStyle(color: Colors.white),),
                  ),
                  ListTile(
                    leading: Icon(Icons.lock,color: Colors.yellow),
                    title: Text('RFID-Enabled Locker',style: TextStyle(color: Colors.white),),
                    subtitle: Text('Secure storage with RFID technology',style: TextStyle(color: Colors.white),),
                  ),
                  ListTile(
                    leading: Icon(Icons.warning,color:Colors.red),
                    title: Text('Gas Leakage Detection and Alarm System',style: TextStyle(color: Colors.white),),
                    subtitle: Text('Ensures safety by detecting gas leakage',style: TextStyle(color: Colors.white),),
                  ),
                  ListTile(
                    leading: Icon(Icons.lightbulb_outline,color: Colors.red,),
                    title: Text('Emergency Light',style: TextStyle(color: Colors.white),),
                    subtitle: Text('Automatic emergency lighting during power outages',style: TextStyle(color: Colors.white10),),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'As the world becomes more technology-oriented, the need for an affordable home care robot will soon become a prerequisite for comfort at home.',
                style: TextStyle(fontSize: 16,color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Team Members:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  TeamMemberCard(

                    name: 'Muhammed R',
                    role: '',
                  ),
                  TeamMemberCard(
                    name: 'Darshan Jaikishore',
                    role: '',
                  ),
                  TeamMemberCard(
                    name: 'Anshu Kumar',
                    role: '',
                  ),
                  TeamMemberCard(
                    name: 'Johana Mariam Varghese',
                    role: '',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TeamMemberCard extends StatelessWidget {
  final String name;
  final String role;

  const TeamMemberCard({
    required this.name,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      elevation: 2,
      child: ListTile(

        leading: CircleAvatar(
          child: Text(name[0],style: TextStyle(color: Colors.white),),
        ),
        title: Text(name,style: TextStyle(color: Colors.white),),
      //  subtitle: Text(role),
      ),
    );
  }
}
