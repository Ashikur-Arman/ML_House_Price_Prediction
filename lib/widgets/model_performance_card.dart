// import 'package:flutter/material.dart';
//
// import '../models/knn_prediction_result.dart';
// import '../theme/app_theme.dart';
// import 'section_title.dart';
//
// class ModelPerformanceCard extends StatelessWidget {
//   final KnnPredictionResult result;
//   final int trainingDataCount;
//
//   const ModelPerformanceCard({
//     super.key,
//     required this.result,
//     required this.trainingDataCount,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 0,
//       color: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius:
//         BorderRadius.circular(24),
//         side: const BorderSide(
//           color: AppTheme.border,
//         ),
//       ),
//       child: Padding(
//         padding:
//         const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment:
//           CrossAxisAlignment.start,
//           children: [
//             const SectionTitle(
//               icon:
//               Icons.analytics_outlined,
//               title: 'Model Information',
//               subtitle:
//               'Technical information about the machine learning model used for this prediction.',
//             ),
//
//             const SizedBox(height: 20),
//
//             GridView.count(
//               crossAxisCount: 2,
//               shrinkWrap: true,
//               physics:
//               const NeverScrollableScrollPhysics(),
//               mainAxisSpacing: 10,
//               crossAxisSpacing: 10,
//               childAspectRatio: 1.65,
//               children: [
//                 _MetricTile(
//                   icon:
//                   Icons.psychology_outlined,
//                   label: 'Algorithm',
//                   value: 'KNN Regression',
//                 ),
//                 _MetricTile(
//                   icon:
//                   Icons.groups_outlined,
//                   label: 'Neighbors',
//                   value:
//                   'K = ${result.k}',
//                 ),
//                 _MetricTile(
//                   icon:
//                   Icons.straighten_outlined,
//                   label: 'Distance',
//                   value: 'Euclidean',
//                 ),
//                 _MetricTile(
//                   icon:
//                   Icons.balance_outlined,
//                   label: 'Weighting',
//                   value: 'Distance',
//                 ),
//                 _MetricTile(
//                   icon:
//                   Icons.storage_outlined,
//                   label: 'Training Data',
//                   value:
//                   '$trainingDataCount records',
//                 ),
//                 _MetricTile(
//                   icon:
//                   Icons.phone_android_outlined,
//                   label: 'Execution',
//                   value: 'On-device',
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 18),
//
//             Container(
//               width: double.infinity,
//               padding:
//               const EdgeInsets.all(15),
//               decoration: BoxDecoration(
//                 color: AppTheme.secondary
//                     .withOpacity(0.08),
//                 borderRadius:
//                 BorderRadius.circular(17),
//               ),
//               child: const Row(
//                 crossAxisAlignment:
//                 CrossAxisAlignment.start,
//                 children: [
//                   Icon(
//                     Icons.wifi_off_outlined,
//                     color:
//                     AppTheme.secondary,
//                     size: 20,
//                   ),
//                   SizedBox(width: 10),
//                   Expanded(
//                     child: Text(
//                       'The model runs completely on the device. No server or internet connection is required for prediction.',
//                       style: TextStyle(
//                         fontSize: 12,
//                         height: 1.5,
//                         color:
//                         AppTheme.darkText,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             Container(
//               width: double.infinity,
//               padding:
//               const EdgeInsets.all(15),
//               decoration: BoxDecoration(
//                 color:
//                 AppTheme.background,
//                 borderRadius:
//                 BorderRadius.circular(17),
//               ),
//               child: const Column(
//                 crossAxisAlignment:
//                 CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'About model performance',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight:
//                       FontWeight.w700,
//                     ),
//                   ),
//                   SizedBox(height: 7),
//                   Text(
//                     'Accuracy metrics such as MAE, RMSE and R² should be calculated on a separate test dataset during model evaluation. They should not be guessed or generated from a single prediction.',
//                     style: TextStyle(
//                       fontSize: 12,
//                       height: 1.5,
//                       color:
//                       AppTheme.greyText,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _MetricTile extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;
//
//   const _MetricTile({
//     required this.icon,
//     required this.label,
//     required this.value,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding:
//       const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: AppTheme.background,
//         borderRadius:
//         BorderRadius.circular(16),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding:
//             const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: AppTheme.primary
//                   .withOpacity(0.09),
//               borderRadius:
//               BorderRadius.circular(10),
//             ),
//             child: Icon(
//               icon,
//               size: 18,
//               color:
//               AppTheme.primary,
//             ),
//           ),
//
//           const SizedBox(width: 9),
//
//           Expanded(
//             child: Column(
//               crossAxisAlignment:
//               CrossAxisAlignment.start,
//               mainAxisAlignment:
//               MainAxisAlignment.center,
//               children: [
//                 Text(
//                   label,
//                   style:
//                   const TextStyle(
//                     fontSize: 9,
//                     color:
//                     AppTheme.greyText,
//                   ),
//                 ),
//                 const SizedBox(height: 3),
//                 Text(
//                   value,
//                   maxLines: 2,
//                   overflow:
//                   TextOverflow.ellipsis,
//                   style:
//                   const TextStyle(
//                     fontSize: 11,
//                     fontWeight:
//                     FontWeight.w700,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }