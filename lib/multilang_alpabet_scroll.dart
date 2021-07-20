library multilang_alpabet_scroll;

import 'package:flutter/material.dart';
import 'package:speech_bubble/speech_bubble.dart';

class AlphabetScroll extends StatefulWidget {
  final ScrollController _controller;
  final Widget listWidget;
  final List<String> strList;
  final itemHeight;
  var lang;
  bool hidden;
  AlphabetScroll(
      this._controller, this.listWidget, this.strList, this.itemHeight,
      {this.hidden = false,this.lang='en'});
  @override
  _AlphabetScrollState createState() => _AlphabetScrollState();
}

class _AlphabetScrollState extends State<AlphabetScroll> {
  late double _offsetContainer;
  var _text;
  var _oldtext;
  var _heightscroller;
  var _itemsizeheight = 46.0; //NOTE: size items
  var _marginRight = 50.0;
  var _sizeheightcontainer;
  var posSelected = 0;
  var diff = 0.0;
  var height = 0.0;
  var txtSliderPos = 0;
  bool showBuble = false;
  String message = "";

  List exampleList = [];

  late List<String> _alphabet ;

  @override
  void initState() {
// TODO: implement initState
    this.widget.lang == 'en'?_alphabet = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z'
    ] :_alphabet = [
      'أ',
      'ب',
      'ت',
      'ث',
      'ج',
      'ح',
      'خ',
      'د',
      'ذ',
      'ر',
      'ز',
      'س',
      'ش',
      'ص',
      'ض',
      'ط',
      'ظ',
      'ع',
      'غ',
      'ف',
      'ق',
      'ك',
      'ل',
      'م',
      'ن',
      'ه',
      'و',
      'ي'
    ];

    _text = _alphabet.first;
    _offsetContainer = 0.0;

    exampleList = this.widget.strList;
    _itemsizeheight = this.widget.itemHeight;

    this.widget._controller.addListener(_scrollListener);
    //sort the item list

    super.initState();
  }

  double getScrollViewDelta(
      double barDelta,
      double barMaxScrollExtent,
      double viewMaxScrollExtent,
      ) {
    //propotion
    return barDelta * viewMaxScrollExtent / barMaxScrollExtent;
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      showBuble = true;
      if ((_offsetContainer + details.delta.dy) >= 0 &&
          (_offsetContainer + details.delta.dy) <=
              (_sizeheightcontainer - _heightscroller)) {
        print(
            'VerticalDragUpdate...............................................');
        _offsetContainer += details.delta.dy;
        print(details.delta.dy);
        // double viewDelta = getScrollViewDelta(
        //     details.delta.dy,
        //     _alphabet.length * _itemsizeheight,
        //     this.widget._controller.position.maxScrollExtent);
        // double viewOffset = widget._controller.position.pixels + viewDelta;
        // if (viewOffset < widget._controller.position.minScrollExtent) {
        //   viewOffset = widget._controller.position.minScrollExtent;
        // }
        // if (viewOffset > this.widget._controller.position.maxScrollExtent) {
        //   viewOffset = this.widget._controller.position.maxScrollExtent;
        // }
        // widget._controller.jumpTo(viewOffset);

        posSelected =
            ((_offsetContainer / _heightscroller) % _alphabet.length).round();
        if (exampleList
            .where((element) =>
            element.toString().startsWith(_alphabet[posSelected]))
            .length >
            0) {
          _text = _alphabet[posSelected];

          var index2 = exampleList.indexWhere((element) =>
              element.toString().startsWith(_alphabet[posSelected]));
          print(index2);

          if (index2 != null) {
            this.widget._controller.jumpTo(
              index2 * _itemsizeheight,
            );
          }
        }
        // for (var i = 0; i < exampleList.length; i++) {
        //   if (_text
        //           .toString()
        //           .compareTo(exampleList[i].toString().toUpperCase()[0]) ==
        //       0) {
        //     this.widget._controller.jumpTo(i * _itemsizeheight);
        //     break;
        //   }
        // }
        // _oldtext = _text;

      }
    });
  }

  void _onVerticalDragStart(DragStartDetails details) {
//    var heightAfterToolbar = height - diff;
//    print("height1 $heightAfterToolbar");
//    var remavingHeight = heightAfterToolbar - (20.0 * 26);
//    print("height2 $remavingHeight");
//
//    var reducedheight = remavingHeight / 2;
//    print("height3 $reducedheight");
    _offsetContainer =
        ((_offsetContainer / _heightscroller / _alphabet.length) +
            posSelected) *
            _heightscroller;
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    setState(() {
      showBuble = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, contrainsts) {
        diff = height - contrainsts.biggest.height;
        _heightscroller = (contrainsts.biggest.height) / _alphabet.length;
        _sizeheightcontainer = (contrainsts.biggest.height); //NO
        print(_sizeheightcontainer);
        return new Stack(children: [
          this.widget.listWidget,
          Positioned(
            top: txtSliderPos.toDouble(),
            right: _marginRight,
            child: _getSpeechBubble(),
          ),
          !this.widget.hidden
              ? Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onVerticalDragUpdate: _onVerticalDragUpdate,
              onVerticalDragStart: _onVerticalDragStart,
              onVerticalDragEnd: _onVerticalDragEnd,
              child: Container(
                //height: 20.0 * 26,
                color: Colors.transparent,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: []..addAll(
                    new List.generate(_alphabet.length,
                            (index) => _getAlphabetItem(index)),
                  ),
                ),
              ),
            ),
          )
              : SizedBox(),
        ]);
      },
    );
  }

  _getSpeechBubble() {
    return FutureBuilder(
      builder: (context, s) {
        Future.delayed(Duration(seconds: 5), () {
          setState(() {
            showBuble = false;
          });
        });
        return showBuble
            ? new SpeechBubble(
          nipLocation: NipLocation.RIGHT,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 30,
                child: Center(
                  child: Text(
                    _text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
            : SizedBox();
      },
    );
  }


  _getAlphabetItem(int index) {
    return new Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            showBuble = true;
          });
          if (exampleList
              .where((element) =>
              element.toString().startsWith(_alphabet[index]))
              .length >
              0) {
            var index2 = exampleList.indexWhere(
                    (element) => element.toString().startsWith(_alphabet[index]));
            print(index2);
            if (index2 != null) {
              this.widget._controller.animateTo(
                index2 * _itemsizeheight,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              );
            }
          }
        },
        child: new Container(
          width: 40,
          height: 20,
          alignment: Alignment.center,
          child: new Text(
            _alphabet[index],
            style: (index == posSelected)
                ? new TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.red)
                : (exampleList
                .where((element) =>
                element.toString().startsWith(_alphabet[index]))
                .length >
                0
                ? new TextStyle(fontSize: 12, fontWeight: FontWeight.w400)
                : new TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey)),
          ),
        ),
      ),
    );
  }

  //scroll detector for reached top or bottom
  _scrollListener() {
    var indexFirst =
    ((this.widget._controller.offset / _itemsizeheight)).floor();
    var indexLast =
        ((((_heightscroller * _alphabet.length) / _itemsizeheight).floor() +
            indexFirst) -
            1) %
            widget.strList.length;
    print(exampleList[indexFirst]);
    setState(() {
      try {
        if (_alphabet
            .contains(exampleList[indexFirst].toString().toUpperCase()[0])) {
          posSelected = this
              ._alphabet
              .indexOf(exampleList[indexFirst].toString().toUpperCase()[0]);
        }
        if (posSelected != null) {
          _text = _alphabet[posSelected];
          txtSliderPos = posSelected == 0
              ? (posSelected * ((_heightscroller) % _alphabet.length)).toInt()
              : (posSelected * ((_heightscroller) % _alphabet.length) - 10).toInt();
        }
        print(_text);
      } on Exception catch (e) {
        // TODO
      }
    });

    if ((this.widget._controller.offset) >=
        (this.widget._controller.position.maxScrollExtent)) {
      print("reached bottom");
    }
    if (this.widget._controller.offset <=
        this.widget._controller.position.minScrollExtent &&
        !this.widget._controller.position.outOfRange) {
      print("reached top");
    }
  }
}

