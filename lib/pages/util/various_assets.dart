
import 'package:flutter/material.dart';

Future displayError(BuildContext context, Object e, [Object? details]){
  ThemeData theme = Theme.of(context);
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title:  Text(e.toString(),style: theme.textTheme.titleMedium),
        actions:[
          TextButton(
            onPressed: () {Navigator.of(context).pop() ;},
            child: const Text("OK")
          )
        ],
        content: (details != null) ? Text(details.toString(),style: theme.textTheme.bodyMedium) :  null,
      );
    }
  );
}

Widget designedButton(BuildContext context, String text, VoidCallback onPressed){
  ThemeData theme = Theme.of(context);
  return Padding(
    padding: const EdgeInsets.only(left: 10, right: 10, top:20),
    child: SizedBox(
      height: 45,
      width: 130,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states){
            if(states.contains(WidgetState.pressed)){
              return theme.colorScheme.tertiary;
            }
            return theme.colorScheme.inversePrimary;
          }),
          foregroundColor:const WidgetStatePropertyAll(Color(0xff000000)),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: theme.textTheme.titleLarge
        ),
      ),
    ),
  );
}

class DesignedTextController extends StatefulWidget{
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;

  const DesignedTextController({super.key, required this.hintText, required this.controller, this.isPassword = false});

  @override
  State<DesignedTextController> createState() => _DesignedTextControllerState();
}

class _DesignedTextControllerState extends State<DesignedTextController>{
  late bool obscure;

  @override
  void initState() {
    super.initState();
    obscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      child: TextField(
        controller: widget.controller,
        style: theme.textTheme.bodyLarge,
        obscureText: obscure,
        decoration: InputDecoration(
          hintStyle:  theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w200),
          hintText: widget.hintText,
          suffixIcon: widget.isPassword ?  GestureDetector(onTap:() => setState(() => obscure = !obscure),
              child: const Icon(Icons.visibility_off)
          ):  null,
        )
      ),
    );
  }
}

class TextAndWidget extends StatelessWidget{
  final String name;
  final Widget? pic;
  final String? data;
  final Widget? extra;

  const TextAndWidget({super.key, required this.name, this.pic, this.data, this.extra});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if(pic != null) pic!,

                const SizedBox(width: 15),

                Text(name, style: textTheme.titleLarge),
              ],
            ),

            if(extra != null || data != null) const SizedBox(height: 10,),

            Row(
              children: [
                if(extra != null) extra!,

                const SizedBox(width: 15),

                if(data!= null) Text(data!, style: textTheme.bodyLarge),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
