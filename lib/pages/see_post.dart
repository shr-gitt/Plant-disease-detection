
import 'package:detector/MongoDb/mongo_work.dart';
import 'package:detector/pages/util/various_assets.dart';
import 'package:flutter/material.dart';

class SeePost extends StatefulWidget{
  
  const SeePost({super.key});

  @override
  State<SeePost> createState() => _SeePostState();
}

class _SeePostState extends State<SeePost> {
  late Future<List<Widget>> children;

  Future<List<Widget>> _getComments() async {
    List<Widget> children = [];
    final (Post p, Account a) = ModalRoute
        .of(context)!
        .settings
        .arguments as (Post, Account);
    try {
      if(a.accountId == null || p.postId == null) throw "Null Error";
      var x = await Comment.retreiveCommentap(a.accountId!, p.postId!);
      for(var y in x){
        children.add(TextAndWidget(name: y.cdescription??""));
      }
      return children;
    } catch (e) {
      rethrow;
    }
  }

  Widget _makeComment(){
    final x = ModalRoute.of(context)!.settings.arguments as (Post, Account);
    return Container(
      decoration: const BoxDecoration(
          color: Color(0x44ffffff),
          shape: BoxShape.circle
      ),
      child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/make_comment', arguments: x);
          },
          child: const Icon(Icons.comment, size: 50,)
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    children = _getComments();
  }

  @override
  Widget build(BuildContext context) {
    final (Post p, Account a) = ModalRoute.of(context)!.settings.arguments as (Post, Account);
    return Scaffold(
      appBar: AppBar(
        title: const Text("See Posts"),
      ),
      body: SafeArea(child: SingleChildScrollView(
        child: Column(
          children: [
            TextAndWidget(
              name: a.userName,
              pic: a.profileImage,
              data: p.ptitle,
              extra: _makeComment(),
            ),

            if(p.postImage != null) p.postImage!,

            if(p.pdescription != null) Text(p.pdescription!),

            const SizedBox(height: 30,),

            FutureBuilder<List<Widget>>
              (future: children, builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot){
                List<Widget> x = [];
                if(snapshot.hasData){
                  x = snapshot.data!;
                }
                else if(snapshot.hasError){
                  x.add(TextAndWidget(name: snapshot.error.toString()));
                }
                else{
                  x.add(const CircularProgressIndicator());
                }

                return Column(children: x);
            })
          ],
        ),
      )),
    );

  }
}