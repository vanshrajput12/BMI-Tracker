import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_pages/login_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});
  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  static const Color _backgroundColor = Color(0xFF111111);
  static const Color _cardColor = Color(0xFF1C1C1C);
  static const Color _accentColor = Color(0xFFFF8A00);
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(CupertinoIcons.back),
        ),
        title: Column(
          children: [
            Text(
              'SETTING',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(width: 110, child: Divider(color: Colors.white)),
          ],
        ),
        actionsPadding: EdgeInsets.only(right: 24, bottom: 10),
      ),
      backgroundColor: _backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _bodyDataCard(),
            SizedBox(height: 30),
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: _accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.person, color: _accentColor),
                ),

                const SizedBox(width: 11),
                Text(
                  "Account",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(34),
                ),
                child: TextButton(
                  onPressed: _logout,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 4),
                      Text(
                        "Log Out",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight(600),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: _cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            'Logout',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: GoogleFonts.poppins(color: Colors.grey.shade400),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: Colors.grey.shade400),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'Logout',
                style: GoogleFonts.poppins(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;
    await _auth.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  Widget _bodyDataCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ListTile(
              leading: Icon(CupertinoIcons.folder_solid, color: Colors.grey),
              title: Text(
                "Preferences",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight(400),
                ),
              ),
              trailing: Icon(
                CupertinoIcons.forward,
                color: Colors.grey,
                size: 20,
              ),
            ),
          ),
          Divider(),
          SizedBox(
            width: double.infinity,
            child: ListTile(
              leading: Icon(Icons.lock, color: Colors.grey),
              title: Text(
                "Privacy",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              trailing: Icon(CupertinoIcons.forward, color: Colors.grey),
            ),
          ),
          Divider(),
          SizedBox(
            width: double.infinity,
            child: ListTile(
              leading: Icon(Icons.safety_check_rounded, color: Colors.grey),
              title: Text(
                "Support",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: Icon(CupertinoIcons.forward, color: Colors.grey),
            ),
          ),
          Divider(),
          SizedBox(
            width: double.infinity,
            child: ListTile(
              leading: Icon(
                CupertinoIcons.collections_solid,
                color: Colors.grey,
              ),
              title: Text(
                "Legal",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: Icon(CupertinoIcons.forward, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _accountCard() {
  //   return Container(
  //     height: 100,
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: _cardColor,
  //       borderRadius: BorderRadius.circular(24),
  //       border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
  //     ),
  //     child: InkWell(
  //       onTap: _logout,
  //       borderRadius: BorderRadius.circular(16),
  //       child: Container(
  //         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
  //         decoration: BoxDecoration(
  //           color: Colors.redAccent.withValues(alpha: 0.08),
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //         child: Row(
  //           children: [
  //             Container(
  //               width: 42,
  //               height: 42,
  //               decoration: BoxDecoration(
  //                 color: Colors.redAccent.withValues(alpha: 0.12),
  //                 borderRadius: BorderRadius.circular(13),
  //               ),
  //               child: const Icon(
  //                 Icons.logout_rounded,
  //                 color: Colors.redAccent,
  //                 size: 20,
  //               ),
  //             ),
  //             const SizedBox(width: 13),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     'Logout',
  //                     style: GoogleFonts.poppins(
  //                       color: Colors.white,
  //                       fontSize: 14,
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 2),
  //                   Text(
  //                     'Sign out from your account',
  //                     style: GoogleFonts.poppins(
  //                       color: Colors.grey.shade600,
  //                       fontSize: 11,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Icon(
  //               Icons.arrow_forward_ios_rounded,
  //               color: Colors.grey.shade600,
  //               size: 15,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
