import 'package:flutter/material.dart';

class BuildingPage extends StatelessWidget {
  const BuildingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width-80,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.build_rounded,size: 96,color: Theme.of(context).colorScheme.onPrimaryContainer,),
          Text('网站仍在继续建造...',style:TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer,fontSize: 24)),
          Text('真的要耐得住寂寞才能走下去...请鼓励我～',style:TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer,fontSize: 24))
        ],
      ),
    );
  }
}
