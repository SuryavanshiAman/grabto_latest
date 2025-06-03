import 'package:flutter/material.dart';
import 'package:grabto/main.dart';

class CommentBottomSheet extends StatefulWidget {
  @override
  _CommentBottomSheetState createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final List<String> emojiList = ['❤️', '🙌', '🔥', '👏', '😢', '😍', '😶', '😂'];
  List<String> comments = ['🙌😢', '🙌👏👏', '❤️❤️❤️', 'Justice served well!'];
  List<String> userName = ['Rakesh', 'Salman', 'Sharukh Khan', 'Amir Khan'];

  void _insertEmoji(String emoji) {
    final text = _controller.text;
    final newText = text + emoji;
    _controller.text = newText;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Container(
                        height: 3,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text("Comments", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600,fontFamily: 'wix')),
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(
                  top: heights*0.05,
                  bottom: 120, // Space for emoji + input
                ),
                child: ListView.builder(
                  controller: controller,

                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[700],
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(
                        userName[index],
                        style: TextStyle(color: Colors.white,fontFamily: "wix",fontSize: 12,fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        comments[index],
                        style:  TextStyle(color: Colors.white,fontFamily: "wix",fontSize: 14,fontWeight: FontWeight.w500),
                      ),
                      trailing: Icon(Icons.favorite_border, color: Colors.grey,size: 20,),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedPadding(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.only(bottom: keyboardHeight),
                  child: Container(
                    color: Colors.black,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Divider(color: Colors.white24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: emojiList.map((emoji) {
                            return GestureDetector(
                              onTap: () => _insertEmoji(emoji),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  emoji,
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        Row(
                          children: [
                            SizedBox(width: 8),
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 16,
                              child: Icon(Icons.person, color: Colors.white, size: 16),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                focusNode: _focusNode,
                                decoration: InputDecoration(
                                  hintText: "What do you think of this?",
                                  hintStyle: TextStyle(color: Colors.white54,fontFamily: 'wix'),
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.send, color: Colors.blue),
                              onPressed: () {
                                if (_controller.text.trim().isNotEmpty) {
                                  setState(() {
                                    comments.add(_controller.text.trim());
                                    userName.add("aman");
                                    _controller.clear();
                                  });
                                }
                              },
                            )
                          ],
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
