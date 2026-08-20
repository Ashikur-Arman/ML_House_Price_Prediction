// import 'package:flutter/material.dart';
//
// import '../theme/app_theme.dart';
//
// class InfoCard extends StatelessWidget {
//   const InfoCard({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding:
//       const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color:
//         AppTheme.primary.withOpacity(
//           0.06,
//         ),
//         borderRadius:
//         BorderRadius.circular(20),
//         border: Border.all(
//           color:
//           AppTheme.primary.withOpacity(
//             0.10,
//           ),
//         ),
//       ),
//       child: const Column(
//         crossAxisAlignment:
//         CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 Icons.lightbulb_outline,
//                 color:
//                 AppTheme.primary,
//               ),
//               SizedBox(width: 9),
//               Text(
//                 'What will this app predict?',
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight:
//                   FontWeight.w700,
//                   color:
//                   AppTheme.darkText,
//                 ),
//               ),
//             ],
//           ),
//
//           SizedBox(height: 10),
//
//           Text(
//             'The app estimates the price of a house in lakh BDT by comparing your property with similar properties in the training dataset.',
//             style: TextStyle(
//               fontSize: 12,
//               height: 1.55,
//               color:
//               AppTheme.greyText,
//             ),
//           ),
//
//           SizedBox(height: 10),
//
//           Text(
//             'The prediction depends on five factors: property area, bedrooms, bathrooms, house age and distance from the city.',
//             style: TextStyle(
//               fontSize: 12,
//               height: 1.55,
//               color:
//               AppTheme.greyText,
//             ),
//           ),
//
//           SizedBox(height: 10),
//
//           Text(
//             'Important: The result is an ML-based estimate, not a guaranteed market price.',
//             style: TextStyle(
//               fontSize: 12,
//               height: 1.55,
//               fontWeight:
//               FontWeight.w600,
//               color:
//               AppTheme.darkText,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }