import 'package:flutter/material.dart';

class MyClipper extends CustomClipper<Path> {
  // @override
  // Path getClip(Size size) {
  //   var path = Path();
  //   path.lineTo(0, 220);
  //   path.quadraticBezierTo(
  //       size.width / 4, 160 /*180*/, size.width / 2, 175);
  //   path.quadraticBezierTo(
  //       3 / 4 * size.width, 190, size.width, 130);
  //   path.lineTo(size.width, 0);
  //   path.close();
  //   return path;
  // }
  //
  // @override
  // bool shouldReclip(CustomClipper<Path> oldClipper) {
  //   return false;
  // }

  @override
  Path getClip(Size size) {
    Path path = new Path();
    final lowPoint = size.height - 600;
    final highPoint = size.height - 630;
    path.lineTo(0, 250);
    path.quadraticBezierTo(
        size.width / 4, highPoint, size.width / 2, lowPoint);
    path.quadraticBezierTo(
        3 / 4 * size.width, 260, size.width, lowPoint);
    path.lineTo(size.width, 0);
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}