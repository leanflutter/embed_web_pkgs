import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:preference_list/preference_list.dart';
import 'package:window_manager/window_manager.dart';

const _kSizes = [
  Size(400, 400),
  Size(600, 600),
  Size(800, 800),
];

const _kMinSizes = [
  Size(400, 400),
  Size(600, 600),
];

const _kMaxSizes = [
  Size(600, 600),
  Size(800, 800),
];

final windowManager = WindowManager.instance;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WindowListener {
  Size _size = _kSizes.first;
  Size? _minSize;
  Size? _maxSize;
  bool _isFullScreen = false;
  bool _isAlwaysOnTop = false;

  @override
  void initState() {
    windowManager.addListener(this);
    _init();
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  void _init() {}

  Widget _buildBody(BuildContext context) {
    return PreferenceList(
      children: <Widget>[
        PreferenceListSection(
          title: Text('METHODS'),
          children: [
            PreferenceListItem(
              title: Text('show / hide'),
              onTap: () async {
                windowManager.hide();
                await Future.delayed(Duration(seconds: 2));
                windowManager.show();
              },
            ),
            PreferenceListItem(
              title: Text('isVisible'),
              onTap: () async {
                bool isVisible = await windowManager.isVisible();
                BotToast.showText(
                  text: 'isVisible: $isVisible',
                );

                await Future.delayed(Duration(seconds: 2));
                windowManager.hide();
                isVisible = await windowManager.isVisible();
                print('isVisible: $isVisible');
                await Future.delayed(Duration(seconds: 2));
                windowManager.show();
              },
            ),
            PreferenceListItem(
              title: Text('isMaximized'),
              onTap: () async {
                bool isMaximized = await windowManager.isMaximized();
                BotToast.showText(
                  text: 'isMaximized: $isMaximized',
                );
              },
            ),
            PreferenceListItem(
              title: Text('maximize / unmaximize'),
              onTap: () async {
                windowManager.maximize();
                await Future.delayed(Duration(seconds: 2));
                windowManager.unmaximize();
              },
            ),
            PreferenceListItem(
              title: Text('isMinimized'),
              onTap: () async {
                bool isMinimized = await windowManager.isMinimized();
                BotToast.showText(
                  text: 'isMinimized: $isMinimized',
                );

                await Future.delayed(Duration(seconds: 2));
                windowManager.minimize();
                await Future.delayed(Duration(seconds: 2));
                isMinimized = await windowManager.isMinimized();
                print('isMinimized: $isMinimized');
                windowManager.restore();
              },
            ),
            PreferenceListItem(
              title: Text('minimize / restore'),
              onTap: () async {
                windowManager.minimize();
                await Future.delayed(Duration(seconds: 2));
                windowManager.restore();
              },
            ),
            PreferenceListSwitchItem(
              title: Text('isFullScreen / setFullScreen'),
              onTap: () async {
                bool isFullScreen = await windowManager.isFullScreen();
                BotToast.showText(text: 'isFullScreen: $isFullScreen');
              },
              value: _isFullScreen,
              onChanged: (newValue) {
                _isFullScreen = newValue;
                windowManager.setFullScreen(_isFullScreen);
                setState(() {});
              },
            ),
            PreferenceListItem(
              title: Text('setBounds / setBounds'),
              accessoryView: ToggleButtons(
                children: <Widget>[
                  for (var size in _kSizes)
                    Text(' ${size.width.toInt()}x${size.height.toInt()} '),
                ],
                onPressed: (int index) async {
                  _size = _kSizes[index];
                  Rect bounds = await windowManager.getBounds();
                  windowManager.setBounds(
                    Rect.fromLTWH(
                      bounds.left,
                      bounds.top,
                      _size.width,
                      _size.height,
                    ),
                  );
                  setState(() {});
                },
                isSelected: _kSizes.map((e) => e == _size).toList(),
              ),
              onTap: () async {
                Rect bounds = await windowManager.getBounds();
                Size size = bounds.size;
                Offset origin = bounds.topLeft;
                BotToast.showText(
                  text: '${size.toString()}\n${origin.toString()}',
                );
              },
            ),
            PreferenceListItem(
              title: Text('getPosition / setPosition'),
              accessoryView: Row(
                children: [
                  CupertinoButton(
                    child: Text('xy>zero'),
                    onPressed: () async {
                      windowManager.setPosition(Offset(0, 0));
                      setState(() {});
                    },
                  ),
                  CupertinoButton(
                    child: Text('x+20'),
                    onPressed: () async {
                      Offset p = await windowManager.getPosition();
                      windowManager.setPosition(Offset(p.dx + 20, p.dy));
                      setState(() {});
                    },
                  ),
                  CupertinoButton(
                    child: Text('x-20'),
                    onPressed: () async {
                      Offset p = await windowManager.getPosition();
                      windowManager.setPosition(Offset(p.dx - 20, p.dy));
                      setState(() {});
                    },
                  ),
                  CupertinoButton(
                    child: Text('y+20'),
                    onPressed: () async {
                      Offset p = await windowManager.getPosition();
                      windowManager.setPosition(Offset(p.dx, p.dy + 20));
                      setState(() {});
                    },
                  ),
                  CupertinoButton(
                    child: Text('y-20'),
                    onPressed: () async {
                      Offset p = await windowManager.getPosition();
                      windowManager.setPosition(Offset(p.dx, p.dy - 20));
                      setState(() {});
                    },
                  ),
                ],
              ),
              onTap: () async {
                Offset position = await windowManager.getPosition();
                BotToast.showText(
                  text: '${position.toString()}',
                );
              },
            ),
            PreferenceListItem(
              title: Text('getSize / setSize'),
              accessoryView: CupertinoButton(
                child: Text('Set'),
                onPressed: () async {
                  Size size = await windowManager.getSize();
                  windowManager.setSize(
                    Size(size.width + 100, size.height + 100),
                  );
                  setState(() {});
                },
              ),
              onTap: () async {
                Offset position = await windowManager.getPosition();
                BotToast.showText(
                  text: '${position.toString()}',
                );
              },
            ),
            PreferenceListSwitchItem(
              title: Text('isAlwaysOnTop / setAlwaysOnTop'),
              onTap: () async {
                bool isAlwaysOnTop = await windowManager.isAlwaysOnTop();
                BotToast.showText(text: 'isAlwaysOnTop: $isAlwaysOnTop');
              },
              value: _isAlwaysOnTop,
              onChanged: (newValue) {
                _isAlwaysOnTop = newValue;
                windowManager.setAlwaysOnTop(_isAlwaysOnTop);
                setState(() {});
              },
            ),
            PreferenceListItem(
              title: Text('getTitle / setTitle'),
              onTap: () async {
                String title = await windowManager.getTitle();
                BotToast.showText(
                  text: '${title.toString()}',
                );
                title =
                    'window_manager_web_example - ${DateTime.now().millisecondsSinceEpoch}';
                await windowManager.setTitle(title);
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: Offset(1.0, 1.0),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Scaffold(
            appBar: AppBar(
              title: const Text("window_manager_web"),
            ),
            body: _buildBody(context),
          ),
        ),
      ],
    );
  }

  @override
  void onWindowEvent(String eventName) {
    print('[WindowManager] onWindowEvent: $eventName');
  }
}
