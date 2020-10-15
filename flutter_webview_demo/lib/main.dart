import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'navigationControls.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: WikiExplorer(),
    );
  }
}

class WikiExplorer extends StatefulWidget {
  @override
  _WikiExplorerState createState() => _WikiExplorerState();
}

class _WikiExplorerState extends State<WikiExplorer> {
  Completer<WebViewController> _controller = new Completer<WebViewController>();
  Set<String> _favorites = new Set<String>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wikipedia Explorer"),
        actions: <Widget>[
          NavigationControls(_controller.future),
          Menu(_controller.future, () => _favorites),
        ],
      ),
      body: WebView(
        initialUrl: 'https://en.wikipedia.org/wiki/Kraken',
        javaScriptMode: JavaScriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
      floatingActionButton: _bookmarkButton(),
    );
  }

  Widget _bookmarkButton() {
    return FutureBuilder<WebViewController>(
      future: _controller.future,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        if (controller.hasData) {
          return FloatingActionButton(
            onPressed: () async {
              var url = await controller.data.currentUrl();
              _favorites.add(url);
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Save $url for later reading.'),
                ),
              );
            },
            child: Icon(Icons.favorite),
          );
        }
        return Container();
      },
    );
  }
}

class Menu extends StatelessWidget {
  Menu(this._webViewControllerFuture, this.favoritesAccessor);

  final Future<WebViewController> _webViewControllerFuture;
  final Function favoritesAccessor;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        if (!controller.hasData) return Container();

        return PopupMenuButton<String>(
          onSelected: (String value) async {
            String newUrl;
            if (value == 'Email link') {
              var url = await controller.data.currentUrl();
              await launch(
                  'mailto:?subject=Check out this cool Wikipedia page&body=$url');
              return;
            } else if (value == 'See Favorites') {
              newUrl = await Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return FavoritesPage(favoritesAccessor());
                  }));
            } else {
              newUrl = await Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return InputPage();
                  }));
            }

            Scaffold.of(context).removeCurrentSnackBar();
            if (newUrl != null) {
              controller.data.loadUrl(newUrl);
            }
          },
          itemBuilder: (BuildContext context) =>
          <PopupMenuItem<String>>[
            const PopupMenuItem<String>(
              value: 'Email link',
              child: Text('Email link'),
            ),
            const PopupMenuItem<String>(
              value: 'See Favorites',
              child: Text('See favorites'),
            ),
            const PopupMenuItem<String>(
                value: 'Input Address', child: Text('Input Address'))
          ],
        );
      },
    );
  }
}

class FavoritesPage extends StatelessWidget {
  FavoritesPage(this.favorites);

  final Set<String> favorites;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite pages'),
      ),
      body: ListView(
          children: favorites
              .map((url) =>
              ListTile(
                  title: Text(url), onTap: () => Navigator.pop(context, url)))
              .toList()),
    );
  }
}

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Please input url'),),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
            ),
          ),

          RaisedButton(
            child: Icon(Icons.done),
            onPressed: () => Navigator.pop(context, _controller.text),
          )
        ],
      ),
    );
  }
}

