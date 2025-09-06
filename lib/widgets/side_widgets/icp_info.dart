
import 'package:bello_front/js_interop.dart';
import 'package:flutter/material.dart';



class IcpInfo extends StatelessWidget {
  const IcpInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme=Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: GestureDetector(
        onTap: (){
          open('https://beian.miit.gov.cn/', '_blank');
        },
        child: Text('ICP备案信息:\n陇ICP备2024014002号-1'),
      )
    );
  }
}
