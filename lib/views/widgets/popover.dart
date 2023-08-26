

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Popover extends StatelessWidget{

  final Widget? child;
  Popover({
    Key? key,
    this.child
}):super(key: key);
  
  @override
  Widget build(BuildContext context) {
   
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.all(16.0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.all(Radius.circular(16.0))
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_buildHandle(context),child!=null?child! :SizedBox() ],
      ),
    );
  }
  Widget _buildHandle(BuildContext context){
    final theme = Theme.of(context);
    return FractionallySizedBox(
      widthFactor: 0.25,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12),
        child: Container(
          decoration: BoxDecoration(
            color: theme.dividerColor,
            borderRadius: BorderRadius.all(Radius.circular(2.5))
          ),
        ),
      ),
    );
  }
}