import 'package:bello_front/control/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 这是一个用于显示 404 Not Found 错误的页面。
/// It's designed to be used with onGenerateRoute when a named route is not found.
class UnknownPage extends StatelessWidget {
  const UnknownPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme=Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.do_disturb_on,size: 60,color: colorScheme.primary,),
            SizedBox(height: 20,),
            // Row for the 404 and Not Found text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '404',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                // Vertical line separator
                SizedBox(width: 16),
                SizedBox(
                  height: 48,
                  child: VerticalDivider(
                    color: colorScheme.onSurface,
                    thickness: 2,
                  ),
                ),
                SizedBox(width: 16),
                Text(
                  'Not Found',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('你踏入了未知之境',style: TextStyle(fontSize: 18),),
            const SizedBox(height: 20,),
            // Button to go back to the previous page
            SizedBox(
              height: 45,
              width: 110,
              child: CustomButton(
                  onPressed: (){
                    if(context.canPop()){
                      context.pop();
                    }else{
                      context.go('/');
                    }
                  },
                  text: '返回首页'
              ),
            )
          ],
        ),
      ),
    );
  }
}
