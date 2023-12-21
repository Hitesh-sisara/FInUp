import 'package:finup/apis/auth_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authAPIProvider).getCurrentUser();

    Widget _buildUserProperty(String label, String value) {
      print('$label: $value'); // Print to console

      return ListTile(
        title: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(value),
      );
    }

    List<Widget> _buildUserDetails() {
      final List<Widget> userDetails = [];

      userDetails.add(_buildUserProperty('ID', user!.id));
      userDetails
          .add(_buildUserProperty('App Metadata', user.appMetadata.toString()));
      userDetails.add(_buildUserProperty(
          'User Metadata', user.userMetadata?.toString() ?? 'N/A'));
      userDetails.add(_buildUserProperty('Aud', user.aud));
      userDetails.add(_buildUserProperty(
          'Confirmation Sent At', user.confirmationSentAt ?? 'N/A'));
      userDetails.add(
          _buildUserProperty('Recovery Sent At', user.recoverySentAt ?? 'N/A'));
      userDetails.add(_buildUserProperty(
          'Email Change Sent At', user.emailChangeSentAt ?? 'N/A'));
      userDetails.add(_buildUserProperty('New Email', user.newEmail ?? 'N/A'));
      userDetails
          .add(_buildUserProperty('Invited At', user.invitedAt ?? 'N/A'));
      userDetails
          .add(_buildUserProperty('Action Link', user.actionLink ?? 'N/A'));
      userDetails.add(_buildUserProperty('Email', user.email ?? 'N/A'));
      userDetails.add(_buildUserProperty('Phone', user.phone ?? 'N/A'));
      userDetails.add(_buildUserProperty('Created At', user.createdAt));
      userDetails
          .add(_buildUserProperty('Confirmed At', user.confirmedAt ?? 'N/A'));
      userDetails.add(_buildUserProperty(
          'Email Confirmed At', user.emailConfirmedAt ?? 'N/A'));
      userDetails.add(_buildUserProperty(
          'Phone Confirmed At', user.phoneConfirmedAt ?? 'N/A'));
      userDetails.add(
          _buildUserProperty('Last Sign In At', user.lastSignInAt ?? 'N/A'));
      userDetails.add(_buildUserProperty('Role', user.role ?? 'N/A'));
      userDetails
          .add(_buildUserProperty('Updated At', user.updatedAt ?? 'N/A'));

      if (user.identities != null) {
        for (var identity in user.identities!) {
          userDetails.add(_buildUserProperty('Identity', identity.toString()));
        }
      }

      if (user.factors != null) {
        for (var factor in user.factors!) {
          userDetails.add(_buildUserProperty('Factor', factor.toString()));
        }
      }

      return userDetails;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                  onPressed: () {
                    ref.read(authAPIProvider).signOut();

                    while (context.canPop == true) {
                      context.pop();
                    }

                    context.pushReplacement("/");
                  },
                  child: Text("logout")),
              Column(
                children: user == null ? [] : _buildUserDetails(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
