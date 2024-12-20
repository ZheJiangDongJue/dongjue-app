// //方形按钮
// import 'package:flutter/material.dart';

// class SquareButton extends StatelessWidget {
//   final String text;
//   final Function? onPressed;
//   final double? width;
//   final double? height;
//   final Color color;
//   final Color textColor;
//   final double fontSize;
//   final double radius;
//   final double borderWidth;
//   final Color borderColor;
//   final double elevation;

//   const SquareButton({
//     super.key,
//     this.text,
//     this.onPressed, this.width, this.height, this.color, this.textColor,
//     this.fontSize, this.radius, this.borderWidth, this.borderColor, this.elevation,
//   });
  
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: width,
//       height: height,
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(radius),
//         border: Border.all
//           (
//           color: borderColor,
//           width: borderWidth,
//         ),
//       ),
//       child: FlatButton(
//         onPressed: onPressed,
//         child: Text(
//           text,
//           style: TextStyle(
//             color: textColor,
//             fontSize: fontSize,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class RoundButton extends StatelessWidget {
//   final String text;
//   final Function onPressed;
//   final double width;
//   final double height;
//   final Color color;
//   final Color textColor;
//   final double fontSize;
//   final double radius;
//   final double borderWidth;
//   final Color borderColor;
//   final double elevation;

//   const RoundButton(
//     {
//     this.text,
//     this.onPressed,
//     this.width,
//     this.height,
//     this.color,
//     this.textColor,
//     this.fontSize,
//     this.radius,
//     this.borderWidth,
//     this.borderColor,
//     this.elevation,
//   }) : super(key: key);
  
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: width,
//       height: height,
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(radius),
//         border: Border.all
//           (color: borderColor, width: borderWidth),
//       ),
//       child: ElevatedButton(
//         style: ButtonStyle(
//           elevation: MaterialStateProperty.all(elevation),
//         ),
//         onPressed: onPressed,
//         child: Text(
//           text,
//           style: TextStyle(
//             color: textColor,
//             fontSize: fontSize,
//           ),
//         ),
//       ),
//     );
//   }
// }