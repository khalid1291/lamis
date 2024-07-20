import UIKit
import Flutter
import FirebaseCore
import Firebase
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    UNUserNotificationCenter.current().delegate = self
        GMSServices.provideAPIKey("AIzaSyA8ZlmtftOOcArnSdQj6tIKerJQS_B0kLk")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let firebaseAuth = Auth.auth()

        firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.unknown)
    }

    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let firebaseAuth = Auth.auth()
        if (firebaseAuth.canHandleNotification(userInfo)){
            completionHandler(.noData)
            print(userInfo)
            return
        }
    }
}
