// import 'package:flutter/material.dart';
// import 'package:flutter_app_testing/cubits/validation/validation_cubit.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class ExternalLoginTextfield extends StatelessWidget {
//   Key key;
//   ValidationCubit validationCubit;
//   BuildContext context;
//   String errorMessage;
//
//   ExternalLoginTextfield(
//       {required this.key,
//       required this.validationCubit,
//       required this.context,
//       required this.errorMessage});
//
//   @override
//   Widget build(BuildContext context) {
//     return     BlocBuilder(
//       bloc: validationCubit,
//       builder: (BuildContext context, state) {
//         print("im here $state");
//         if (state == true) {
//           return TextField(
//             key: key,
//             controller: _emailController,
//             onChanged: (email) {
//               _emailErrorMessage = _validationCubitEmail
//                   .vaildationEmail(email, true);
//             },
//             decoration: InputDecoration(
//                 icon: const Icon(
//                   Icons.email,
//                   color: Color(0xFFFF4891),
//                 ),
//                 focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(
//                         color: Colors.grey.shade100)),
//                 labelText: "Email",
//                 enabledBorder: InputBorder.none,
//                 labelStyle:
//                 const TextStyle(color: Colors.grey)),
//           );
//         } else {
//           return Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: <Widget>[
//                 TextField(
//                   key: k1,
//                   onChanged: (email) {
//                     _emailErrorMessage = _validationCubitEmail
//                         .vaildationEmail(email, true);
//                   },
//                   controller: _emailController,
//                   decoration: InputDecoration(
//                       icon: const Icon(
//                         Icons.email,
//                         color: Color(0xFFFF4891),
//                       ),
//                       focusedBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(
//                               color: Colors.grey.shade100)),
//                       labelText: "Email",
//                       enabledBorder: InputBorder.none,
//                       labelStyle: const TextStyle(
//                           color: Colors.grey)),
//                 ),
//                 Directionality(
//                   textDirection: TextDirection.ltr,
//                   child: Text(
//                     _emailErrorMessage,
//                     style: const TextStyle(
//                         fontStyle: FontStyle.italic,
//                         fontSize: 10,
//                         color: Colors.red),
//                     textAlign: TextAlign.right,
//                   ),
//                 ),
//               ]);
//         }
//       },
//     ),
//   }
// }
