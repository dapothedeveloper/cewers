import 'dart:async';
//import OneSignal
import 'package:onesignal_flutter/onesignal_flutter.dart';

class PushNotification {
  // String _debugLabelString;
  // String _emailAddress;
  // String _externalUserId;
  // bool _enableConsentButton = true;

  // CHANGE THIS parameter to true if you want to test GDPR privacy consent
  bool _requireConsent = true;
  final String oneSignalAppId;

  PushNotification(this.oneSignalAppId) {
    initPlatformState(this.oneSignalAppId);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState(String onsignalAppId) async {
    // if (!mounted) return;

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setRequiresUserPrivacyConsent(_requireConsent);

    var settings = {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };

    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {
      // this.setState(() {
      // _debugLabelString =
      //     "Received notification: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      // });
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // this.setState(() {
      // _debugLabelString =÷ \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      // });
    });

    OneSignal.shared
        .setInAppMessageClickedHandler((OSInAppMessageAction action) {
      // this.setState(() {
      // _debugLabelString =
      //     "In App Message Clicked: \n${action.jsonRepresentation().replaceAll("\\n", "\n")}";
    });
    // });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges changes) {
      print("EMAIL SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
    });

    // NOTE: Replace with your own app ID from https://www.onesignal.com
    await OneSignal.shared.init(onsignalAppId, iOSSettings: settings);

    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    // bool requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();

    // this.setState(() {
    //   _enableConsentButton = requiresConsent;
    // });

    // Some examples of how to use In App Messaging public methods with OneSignal SDK
    _oneSignalInAppMessagingTriggerExamples();

    // Some examples of how to use Outcome Events public methods with OneSignal SDK
    _oneSignalOutcomeEventsExamples();
  }

  _oneSignalInAppMessagingTriggerExamples() async {
    /// Example addTrigger call for IAM
    /// This will add 1 trigger so if there are any IAM satisfying it, it
    /// will be shown to the user
    OneSignal.shared.addTrigger("trigger_1", "one");

    /// Example addTriggers call for IAM
    /// This will add 2 triggers so if there are any IAM satisfying these, they
    /// will be shown to the user
    Map<String, Object> triggers = new Map<String, Object>();
    triggers["trigger_2"] = "two";
    triggers["trigger_3"] = "three";
    OneSignal.shared.addTriggers(triggers);

    // Removes a trigger by its key so if any future IAM are pulled with
    // these triggers they will not be shown until the trigger is added back
    OneSignal.shared.removeTriggerForKey("trigger_2");

    // Get the value for a trigger by its key
    Object triggerValue =
        await OneSignal.shared.getTriggerValueForKey("trigger_3");
    print("'trigger_3' key trigger value: " + triggerValue);

    // Create a list and bulk remove triggers based on keys supplied
    List<String> keys = new List<String>();
    keys.add("trigger_1");
    keys.add("trigger_3");
    OneSignal.shared.removeTriggersForKeys(keys);

    // Toggle pausing (displaying or not) of IAMs
    OneSignal.shared.pauseInAppMessages(false);
  }

  _oneSignalOutcomeEventsExamples() async {
    // Await example for sending outcomes
    _outcomeAwaitExample();

    // Send a normal outcome and get a reply with the name of the outcome
    OneSignal.shared.sendOutcome("normal_1");
    OneSignal.shared.sendOutcome("normal_2").then((outcomeEvent) {
      print(outcomeEvent.jsonRepresentation());
    });

    // Send a unique outcome and get a reply with the name of the outcome
    OneSignal.shared.sendUniqueOutcome("unique_1");
    OneSignal.shared.sendUniqueOutcome("unique_2").then((outcomeEvent) {
      print(outcomeEvent.jsonRepresentation());
    });

    // Send an outcome with a value and get a reply with the name of the outcome
    OneSignal.shared.sendOutcomeWithValue("value_1", 3.2);
    OneSignal.shared.sendOutcomeWithValue("value_2", 3.9).then((outcomeEvent) {
      print(outcomeEvent.jsonRepresentation());
    });
  }

  Future<void> _outcomeAwaitExample() async {
    var outcomeEvent = await OneSignal.shared.sendOutcome("await_normal_1");
    print(outcomeEvent.jsonRepresentation());
  }

  void _handleNotificationReceived(OSNotification notification) {
    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {
      print(notification);
    });
  }
}
