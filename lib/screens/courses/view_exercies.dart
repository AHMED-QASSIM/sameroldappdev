import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../exercies/view_exrcies.dart';

class ViewExrciesUser extends StatefulWidget {
  final String name;
  final List exercises;
  const ViewExrciesUser({super.key,required this.name,required this.exercises});

  @override
  State<ViewExrciesUser> createState() => _ViewExrciesState();
}

class _ViewExrciesState extends State<ViewExrciesUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(widget.name,style:Theme.of(context).textTheme.bodyMedium,),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child:  Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
                                  children: widget.exercises.map((e){
                                    return e["exerciseSuper"]?.length > 0 ? Container(
                                      child: Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.green,width: 0.5),
                                        borderRadius: BorderRadius.circular(10)
                                      ),                              child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                         
                                          SizedBox(height: 10,),
                                           GestureDetector(
                                              onTap: (){
                                                Get.to(ViewExrcies(sets: e["sets"],name: e["name"],id: e["id"],));
                                              },
                                             child: Row(
                                                                                 
                                                                                   children: [
                                                                                     Expanded(child: Text(e["name"],style: TextStyle(fontSize: 12.sp),)),
                                                                                     Text(e["sets"],style: TextStyle(fontSize: 12.sp),),
                                               SizedBox(width: 10,),
                                                            Icon(CupertinoIcons.play_circle_fill,size: 12.sp,color: Theme.of(context).primaryColor,),
                                                                               
                                                                         SizedBox(width: 10,),
                                                                                   ],
                                                                                 ),
                                           ),
                                      SizedBox(height: 5,),
                                      ListView.builder(
                                        itemCount:  e["exerciseSuper"].length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context,pos){
                                        dynamic s = e["exerciseSuper"][pos];
                                        return  GestureDetector(
                                          onTap: (){
                                            Get.to(ViewExrcies(sets: s["sets"],name: s["name"],id: s["id"],));
                                          },
                                          child: Row(
                                                                              
                                          children: [
                                            Expanded(child: Text(s["name"],style: TextStyle(fontSize: 12.sp),)),
                                            Text(s["sets"],style: TextStyle(fontSize: 12.sp),),
                                                         SizedBox(width: 10,),
                                                         Icon(CupertinoIcons.play_circle_fill,size: 12.sp,color: Theme.of(context).primaryColor,),
                                                                            
                                                                      SizedBox(width: 10,),
                                          ],
                                                                              ),
                                        );
                                      })
              
                                        ],
                                      )
                                    ),
                                    ) : GestureDetector(
                                      onTap: (){
                             Get.to(ViewExrcies(sets: e["sets"],name: e["name"],id: e["id"],));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                          // border: Border.all(color: Colors.grey.shade300,width: 0.5),
                                          borderRadius: BorderRadius.circular(10)
                                        ),                              child: Row(
                                       
                                          children: [
                                            Expanded(child: Text(e["name"],style: TextStyle(fontSize: 12.sp),)),
                                            Text(e["sets"],style: TextStyle(fontSize: 12.sp),),
                                                   SizedBox(width: 10,),
                                                     Icon(CupertinoIcons.play_circle_fill,size: 14.sp,color: Theme.of(context).primaryColor,),
                                      
                                                                  SizedBox(width: 10,),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
        ),
      ),
    );
  }
}