import 'package:bordered_text/bordered_text.dart';
import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class StoriesPage extends StatelessWidget {
  // final StoryController controller = StoryController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          // Add the app bar to the CustomScrollView.
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black,
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: BorderedText(
                  strokeWidth: 2.0,
                  child: Text(
                    'Hello;',
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      decorationColor: Colors.pink,
                    ),
                  ),
                ),
                // Text("Hello;",
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 16.0,
                //     )),
                background: Image.asset(
                  "assets/images/in57.png",
                  fit: BoxFit.cover,
                )),
            actions: [
              IconButton(
                icon: Icon(Icons.local_florist),
                onPressed: () {},
              ),
            ],
          ),
          // Next, create a SliverList
          SliverList(
            // Use a delegate to build items as they're scrolled on screen.
            delegate: SliverChildBuilderDelegate(
              // The builder function returns a ListTile with a title that
              // displays the index of the current item.
              (context, index) => SingleCard(controller: StoryController()),
              // Builds 1000 ListTiles
              childCount: 10,
            ),
          ),
        ],
      ),

      //   body: Container(
      //     margin: EdgeInsets.all(
      //       8,
      //     ),
      //     child: ListView(
      //       children: [
      //         SingleCard(controller: StoryController()),
      //         SingleCard(controller: StoryController()),
      //         SingleCard(controller: StoryController()),
      //         SingleCard(controller: StoryController()),
      //         SingleCard(controller: StoryController()),
      //       ],
      //     ),
      //   ),
    );
  }
}

class SingleCard extends StatelessWidget {
  const SingleCard({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final StoryController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 300,
            child: StoryView(
              controller: controller,
              storyItems: [
                StoryItem.text(
                  title:
                      "Hello world!\nHave a look at some great Ghanaian delicacies. I'm sorry if your mouth waters. \n\nTap!",
                  backgroundColor: Colors.orange,
                  roundedTop: true,
                ),
                // StoryItem.inlineImage(
                //   NetworkImage(
                //       "https://image.ibb.co/gCZFbx/Banku-and-tilapia.jpg"),
                //   caption: Text(
                //     "Banku & Tilapia. The food to keep you charged whole day.\n#1 Local food.",
                //     style: TextStyle(
                //       color: Colors.white,
                //       backgroundColor: Colors.black54,
                //       fontSize: 17,
                //     ),
                //   ),
                // ),
                StoryItem.inlineImage(
                  url:
                      "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
                  controller: controller,
                  caption: Text(
                    "Omotuo & Nkatekwan; You will love this meal if taken as supper.",
                    style: TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.black54,
                      fontSize: 17,
                    ),
                  ),
                ),
                StoryItem.inlineImage(
                  url: "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
                  controller: controller,
                  caption: Text(
                    "Hektas, sektas and skatad",
                    style: TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.black54,
                      fontSize: 17,
                    ),
                  ),
                )
              ],
              onStoryShow: (s) {
                print("Showing a story");
              },
              onComplete: () {
                print("Completed a cycle");
              },
              progressPosition: ProgressPosition.bottom,
              repeat: false,
              inline: true,
            ),
          ),
          Material(
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MoreStories()));
              },
              child: FDottedLine(
                color: Colors.black,
                height: 70.0,
                width: 70.0,
                strokeWidth: 2.0,
                dottedLength: 10.0,
                space: 2.0,

                /// Set corner
                // corner: FDottedLineCorner.all(50),

                child: Container(
                  decoration: BoxDecoration(
                      // color: Colors.black54,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(8))),
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "View more stories",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MoreStories extends StatefulWidget {
  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories> {
  final storyController = StoryController();

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("More"),
      ),
      body: StoryView(
        storyItems: [
          StoryItem.text(
            title: "I guess you'd love to see more of our food. That's great.",
            backgroundColor: Colors.blue,
          ),
          StoryItem.text(
            title: "Nice!\n\nTap to continue.",
            backgroundColor: Colors.red,
            textStyle: TextStyle(
              fontFamily: 'Dancing',
              fontSize: 40,
            ),
          ),
          StoryItem.pageImage(
            url:
                "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
            caption: "Still sampling",
            controller: storyController,
          ),
          StoryItem.pageImage(
              url: "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
              caption: "Working with gifs",
              controller: storyController),
          StoryItem.pageImage(
            url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
            caption: "Hello, from the other side",
            controller: storyController,
          ),
          StoryItem.pageImage(
            url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
            caption: "Hello, from the other side2",
            controller: storyController,
          ),
        ],
        onStoryShow: (s) {
          print("Showing a story");
        },
        onComplete: () {
          print("Completed a cycle");
        },
        progressPosition: ProgressPosition.top,
        repeat: false,
        controller: storyController,
      ),
    );
  }
}
