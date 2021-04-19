// import 'package:flutter/material.dart';

// class Newhome extends StatefulWidget {
//   @override
//   _NewhomeState createState() => _NewhomeState();
// }

// class _NewhomeState extends State<Newhome> {
//   String _email, _password;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Column(
//         children: <Widget>[
//           Container(
//             child: Stack(
//               children: <Widget>[
//                 Container(
//                   padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
//                   child: Text(
//                     'Nikhoj',
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 80.0,
//                         fontFamily: "Signatra",
//                         fontWeight: FontWeight.bold),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Container(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: InputDecoration(
//                     //hintText: 'Password'
//                     labelText: "Email",
//                     labelStyle: TextStyle(
//                       color: Colors.black,
//                       fontSize: 22.0,
//                     ),
//                     focusedBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(color: Colors.grey))),
//                 onChanged: (value) {
//                   setState(() {
//                     _email = value.trim();
//                   });
//                 },
//               ),
//             ),
//           ),
//           Container(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 obscureText: true,
//                 decoration: InputDecoration(
//                     //hintText: 'Password'
//                     labelText: "Password",
//                     labelStyle: TextStyle(
//                       color: Colors.black,
//                       fontSize: 22.0,
//                     ),
//                     focusedBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(color: Colors.grey))),
//                 onChanged: (value) {
//                   setState(() {
//                     _password = value.trim();
//                   });
//                 },
//               ),
//             ),
//           ),
  


//         ],
//       ),
//       backgroundColor: Theme.of(context).accentColor,
//     );
//   }
// }
