import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  final int index;
  final String message;
  final bool isMe;
  final String username;
  final String url;
  final Key key;
  
  ChatBubble(this.index,this.message, this.isMe, this.username, this.url,{this.key});

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  final GlobalKey _containerKey = GlobalKey();
  Offset containerOffset;
  Size containerSize;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getOffset();
    });
  }

  getOffset() {
    RenderBox containerBox = _containerKey.currentContext.findRenderObject();
    if(_containerKey.currentContext==null) print("kjkjkjkj");
    setState(() {
      containerSize = containerBox.size;
      containerOffset = containerBox.localToGlobal(Offset.zero);
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Row(
      key: widget.key,
      mainAxisAlignment:
          widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: widget.isMe
                  ? Colors.grey[300]
                  : Theme.of(context).accentColor,
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.only(
              top: widget.index==0?14:7,
              bottom: 7,
              right: 14,
              left: 8,
            ),
            child: Stack(
              overflow: Overflow.visible,
                          children:<Widget>[ Container(
                            key: _containerKey,
                
               
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.username,
                        style: TextStyle(
                            color: widget.isMe
                                ? Theme.of(context).accentColor
                                : Colors.grey[300],
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Column(children: <Widget>[
                        Text(widget.message,
                            style: TextStyle(
                              fontSize: 18,
                              color: widget.isMe ? Colors.black : Colors.white,
                            )),
                      ])
                    ]),
              ),
               Positioned(
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(widget.url),
                        
                      ),
                      left: containerOffset==null?0:(containerSize.width-12+12),//12 is radius and 12 is padding
                      bottom: containerSize==null?0:(containerSize.height-12+12),
                    )
                          ]
            ))
      ],
    );
    
  }
}
