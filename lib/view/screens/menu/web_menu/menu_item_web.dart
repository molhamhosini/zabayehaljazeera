
import 'package:flutter/material.dart';
import 'package:zabayeh_aljazeera/helper/route_helper.dart';
import 'package:zabayeh_aljazeera/localization/language_constrants.dart';
import 'package:zabayeh_aljazeera/provider/auth_provider.dart';
import 'package:zabayeh_aljazeera/provider/profile_provider.dart';
import 'package:zabayeh_aljazeera/utill/dimensions.dart';
import 'package:zabayeh_aljazeera/utill/styles.dart';
import 'package:zabayeh_aljazeera/view/screens/menu/web_menu/menu_screen_web.dart';
import 'package:zabayeh_aljazeera/view/screens/menu/widget/sign_out_confirmation_dialog.dart';
import 'package:provider/provider.dart';

class MenuItemWeb extends StatelessWidget {
  final MenuModel menu;
  const MenuItemWeb({Key key, @required this.menu}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    bool _isLogin = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    return InkWell(
      borderRadius: BorderRadius.circular(32.0),
      onTap: () {
        if(menu.route == 'version') {

        }else if (menu.title == getTranslated('profile', context)){
          if(_isLogin){
            Navigator.pushNamed(context, RouteHelper.getProfileEditRoute(Provider.of<ProfileProvider>(context, listen: false).userInfoModel));
          }else {
            Navigator.pushNamed(context, RouteHelper.getLoginRoute());
          }
        }else if(menu.route == 'auth'){
          _isLogin ? showDialog(
            context: context, barrierDismissible: false, builder: (context) => SignOutConfirmationDialog(),
          ) : Navigator.pushNamed(context, RouteHelper.getLoginRoute());
        }else{
          Navigator.pushNamed(context, menu.route);
        }
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.04), borderRadius: BorderRadius.circular(32.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            menu.icon == null || menu.iconWidget != null ? menu.iconWidget
                : Image.asset(menu.icon, width: 50, height: 50, color: Theme.of(context).textTheme.bodyLarge.color),
            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

            Text(menu.title, style: poppinsRegular),
          ],
        ),
      ),
    );
  }
}
