import 'package:flutter/material.dart';
import 'package:detector/MongoDb/mongo_work.dart';
import 'package:detector/main.dart';
import 'package:detector/pages/util/various_assets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{
  late Future<List<Widget>> children;

  Widget _makePost(){
    return Container(
      decoration: const BoxDecoration(
          color: Color(0x44ffffff),
          shape: BoxShape.circle
      ),
      child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/posts');
          },
          child: const Icon(Icons.add, size: 50,)
      ),
    );
  }

  Widget _viewPost(Post p, Account a){
    return Container(
      decoration: const BoxDecoration(
          color: Color(0x44ffffff),
          shape: BoxShape.circle
      ),
      child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/see_post', arguments: (p,a));
          },
          child: const Icon(Icons.info, size: 20,)
      ),
    );
  }

  Future<List<Widget>> _getPosts() async{
    List<Widget> foo = [];
    Widget tempWidget;
    try{
      List<Post> samplePosts = await Post.retreivePostList();
      Account temp;
      for(Post x in samplePosts){
        if(x.accountId != null) {
          temp = await Account.retreiveAccountoi(x.accountId!);
        }
        else{
          temp = Account();
        }
        tempWidget = TextAndWidget(
          name: temp.userName,
          pic: temp.profileImage,
          data: x.ptitle,
          extra: _viewPost(x, temp)
        );
        foo.add(tempWidget);
      }
      return foo;
    }catch(e){
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    children = _getPosts();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
        
            Consumer<OnDeviceStorage>(builder: (context, userFile, _) =>
                TextAndWidget(
                    name: userFile.userAcc.userName,
                    pic: userFile.userAcc.profileImage,
                    data: "Make a Post",
                    extra: _makePost()
                )
            ),

            const SizedBox(height: 20),

            FutureBuilder<List<Widget>>
              (future: children, builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot){
              List<Widget> columnChildren = [];
              if(snapshot.hasData){
                columnChildren = snapshot.data!;
              }
              else if(snapshot.hasError){
                columnChildren.add(Text(snapshot.error.toString()));
              }
              else{
                columnChildren.add(const CircularProgressIndicator());
              }
              return Column(children: columnChildren);
            })

          ],
        ),
    );
  }

}