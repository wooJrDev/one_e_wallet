import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one_e_sample/firebase/credentialDb.dart';
import 'package:one_e_sample/models/userModel.dart';
import 'package:one_e_sample/screen/budget_tracking/budgetTrackingPage.dart';
import 'package:one_e_sample/screen/e_wallets/ewalletsPage.dart';
import 'package:one_e_sample/screen/expenditure_report/expenditureReportPage.dart';
import 'package:one_e_sample/screen/history/trxPage.dart';
import 'package:one_e_sample/screen/home/homePage.dart';
import 'package:one_e_sample/screen/sales_and_promotions/salesAndPromoPage.dart';
import 'package:one_e_sample/screen/user_profile/userProfilePage.dart';
import 'package:one_e_sample/shared_objects/const_values.dart';
import 'package:provider/provider.dart';

class HomeNavigation extends StatefulWidget {
  @override
  _HomeNavigationState createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  int _currentIndex = 0;
  int _previousIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthService _authService = AuthService();

  final List<Widget> _children = [
    HomePage(),
    // TrxPage(),
    TrxPage(),
    EwalletsPage(),
  ];

  void _openEndDrawer() {
    print('Opening Drawer');
    _scaffoldKey.currentState!.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserModel>(context);

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: PageTransitionSwitcher(
          duration: const Duration(milliseconds: 500),
          reverse: _currentIndex >= _previousIndex ? false : true,
          transitionBuilder: (
            Widget child,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return SharedAxisTransition(
              child: child,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
            );
          },
          child: _children[_currentIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.history_rounded),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.account_balance_wallet),
            label: 'E-wallets',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
      endDrawer: SafeArea(
        child: Drawer(
          child: Container(
            color: Color(0xFFD6F5FF),
            child: Column(
              children: <Widget>[
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 10.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.orange[100],
                          backgroundImage: AssetImage(ImgLinks.profile_plainAvatar), // TODO: Change profile picture to system logo
                          radius: 40,
                        ),
                      ),
                      ListTile(
                        title: Text(userDetails.userName ?? "backupUsername", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        subtitle: Text(userDetails.userEmail ?? "backupusername@gmail.com", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                      )
                    ],
                  ),
                ),
                Card(
                  child: InkWell(
                    splashColor: ColourTheme.inkWellBlue,
                    // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SalesList())),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfilePage())),
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: 20),
                      leading: FaIcon(FontAwesomeIcons.userAlt, size: TextFontStyle.listTile_faIconSize, color: Colors.blue,),
                      title: Text('User Profile Settings', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
                Card(
                  child: InkWell(
                    splashColor: ColourTheme.fontBlue.withAlpha(40),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BudgetTrackingPage(),)),
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: 15),
                      leading: FaIcon(FontAwesomeIcons.piggyBank, size: TextFontStyle.listTile_faIconSize, color: Colors.blue,), //TODO: Use FontAwesomeIcon package and select an appropriate icon
                      title: Text('Manage Budget Tracking', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
                Card(
                  child: InkWell(
                    splashColor: ColourTheme.fontBlue.withAlpha(40),
                    onTap: () => Navigator.push( context, MaterialPageRoute( builder: (context) => ExpenditureReportPage() ) ),
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: 20),
                      leading: FaIcon(FontAwesomeIcons.chartArea, size: TextFontStyle.listTile_faIconSize, color: Colors.blue,),
                      title: Text('View Expenditure Report', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
                Card(
                  child: InkWell(
                    splashColor: ColourTheme.fontBlue.withAlpha(40),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SalesAndPromoPage())),
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: 20),
                      leading: FaIcon(FontAwesomeIcons.shoppingBag, size: TextFontStyle.listTile_faIconSize, color: Colors.blue),
                      title: Text('Sales and Promotion', style: TextStyle(fontSize: TextFontStyle.profile_listTileTitle, fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
                Card(
                  child: InkWell(
                    splashColor: ColourTheme.fontBlue.withAlpha(40),
                    onTap: () => _authService.signOut(),
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: 20),
                      leading: FaIcon(FontAwesomeIcons.signOutAlt, size: TextFontStyle.listTile_faIconSize, color: Colors.blue,),
                      title: Text('Log Out', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      if (index == 3) {
        _openEndDrawer();
      }else {
        _previousIndex = _currentIndex;
        _currentIndex = index;
      }
    });
  }

}

