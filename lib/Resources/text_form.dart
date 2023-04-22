import 'package:flutter/material.dart';


Widget ParameterWidget(_controller, _validator, var variable1,  {var variable2='0', var obscure=false, var textCap=false}) {
  return Container(
    child: Column(
      children: [
        Row(
          children: [
            Text(variable1,
              style: TextStyle(
                  color: Colors.grey[700],
                  letterSpacing: 2.0,
                  fontSize: 15.0
              ),),
          ],),
        (variable2 != '0') ? Row(children: [
          Text(variable2, style: TextStyle( color: Colors.grey[700],  letterSpacing: 2.0,  fontSize: 15.0  ),)],) :

        const SizedBox(height: 7.0),

        TextFormField(
          obscureText: obscure,
          controller: _controller,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(12)
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF4c405c)),
              borderRadius: BorderRadius.circular(12),
            ),
            fillColor: Colors.grey[200],
            filled: true,
          ),
          validator: _validator,
          textCapitalization: (textCap) ? TextCapitalization.sentences : TextCapitalization.none,
        )
      ],),
  );
}
