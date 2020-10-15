import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'favoritesPage.dart';
import 'inputPage.dart';

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

              var _schemeUrl = 'mailto:?subject=My%20Favorite%20Page&body=$url';

              if (await canLaunch(_schemeUrl)) {
                await launch(_schemeUrl);
              } else {
                throw 'Could not launch $_schemeUrl';
              }

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
          itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
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
