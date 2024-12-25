import 'package:dongjue_application/globals.dart';
import 'package:flutter/material.dart';

class UserCenter extends StatelessWidget {
  const UserCenter({super.key});

  final String _userAvatar = "https://via.placeholder.com/150"; // Placeholder avatar URL

  @override
  Widget build(BuildContext context) {
    GlobalData globalData = GlobalData();
    return Scaffold(
      appBar: AppBar(
        title: const Text('个人中心'),
      ),
      body: SingleChildScrollView(
        // Enables scrolling if content overflows
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(_userAvatar),
            ),
            const SizedBox(height: 16),
            Text(
              globalData.user_info.UserName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            // ProfileTile(
            //     icon: Icons.person,
            //     title: '个人信息',
            //     onTap: () {
            //       // Navigate to edit profile page
            //       // Navigator.pushNamed(context, '/editProfile');
            //     }),
            ProfileTile(
                icon: Icons.lock,
                title: '修改密码',
                onTap: () {
                  // 修改密码
                  Navigator.pushNamed(context, '/changepassword');
                }),
            ProfileTile(
                icon: Icons.library_books,
                title: '当前账套',
                trailing: Text(globalData.db_config.DbName),
                onTap: () {
                  // Navigate to settings page
                }),
            ProfileTile(
                icon: Icons.logout,
                title: '退出登录',
                titleTextStyle: const TextStyle(color: Colors.red),
                onTap: () {
                  // 退出登录
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                }),
          ],
        ),
      ),
    );
  }

  Widget buildGroupSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          child: Column(
            children: children,
          ),
        ),
        const SizedBox(height: 16.0), // 组之间的间距
      ],
    );
  }
}

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;
  final TextStyle? titleTextStyle;

  const ProfileTile({super.key, required this.icon, required this.title, this.onTap, this.trailing, this.titleTextStyle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: titleTextStyle),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
