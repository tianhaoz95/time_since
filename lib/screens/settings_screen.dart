import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_since/screens/upgrade_screen.dart';
import 'package:time_since/l10n/app_localizations.dart';
import 'package:time_since/main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoading = false;
  String? _selectedLanguage;
  AppLocalizations? l10n;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    l10n = AppLocalizations.of(context);
    _selectedLanguage = Localizations.localeOf(context).languageCode == 'zh' ? 'Chinese' : 'English';
  }

  Future<void> _signOut() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/signIn');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n!.errorSigningOut(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteAccount() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n!.noUserLoggedIn)),
        );
      }
      return;
    }

    // First confirmation dialog
    bool? confirmDeletion = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n!.deleteAccountWarningTitle),
          content: Text(l10n!.deleteAccountWarningContent),
          actions: <Widget>[
            TextButton(
              child: Text(l10n!.cancelButton),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text(l10n!.deleteButton),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmDeletion == true) {
      TextEditingController confirmController = TextEditingController();
      bool? finalConfirmation = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(l10n!.confirmDeletionTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n!.confirmDeletionPrompt),
                TextField(
                  controller: confirmController,
                  decoration: const InputDecoration(hintText: 'DELETE'),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(l10n!.cancelButton),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text(l10n!.deleteButton),
                onPressed: () {
                  if (confirmController.text == 'DELETE') {
                    Navigator.of(context).pop(true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n!.incorrectConfirmation)),
                    );
                  }
                },
              ),
            ],
          );
        },
      );

      if (finalConfirmation == true) {
        setState(() {
          _isLoading = true;
        });
        try {
          // Delete user's Firestore data
          final userItemsCollection = FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .collection('items');
          final snapshot = await userItemsCollection.get();
          for (final doc in snapshot.docs) {
            await doc.reference.delete();
          }
          await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).delete();

          // Delete user from Firebase Authentication
          await currentUser.delete();

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n!.accountDeletedSuccess)),
            );
            Navigator.of(context).pushReplacementNamed('/signIn');
          }
        } on FirebaseAuthException catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n!.errorDeletingAccount(e.message ?? 'Unknown error'))),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n!.unexpectedError(e.toString()))),
            );
          }
        } finally {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentLanguageCode = Localizations.localeOf(context).languageCode;
    if (_selectedLanguage == null) {
      _selectedLanguage = currentLanguageCode == 'zh' ? 'Chinese' : 'English';
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n!.settingsTitle)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
              child: Text(
                l10n!.loggedInAs(FirebaseAuth.instance.currentUser?.email ?? 'N/A'),
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Language:',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedLanguage,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLanguage = newValue;
                    });
                    if (newValue == 'English') {
                      MainApp.of(context)!.setLocale(const Locale('en'));
                    } else if (newValue == 'Chinese') {
                      MainApp.of(context)!.setLocale(const Locale('zh'));
                    } else {
                      MainApp.of(context)!.setLocale(const Locale('en')); // Default to English for system if not Chinese
                    }                  },
                  items: <String>['English', 'Chinese', 'System Default']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signOut,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n!.signOutButton),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UpgradeScreen()));
                  },
                  child: Text(l10n!.upgradeButton),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _deleteAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white,),
                        )
                      : Text(l10n!.deleteAccountButton, style: const TextStyle(color: Colors.white),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
