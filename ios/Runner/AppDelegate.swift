import UIKit
import Flutter
import Intents

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        INPreferences.requestSiriAuthorization { (status) in
            switch status {
            case .authorized:
                let mealIntent = FetchMealIntent()
                mealIntent.suggestedInvocationPhrase = "Tell me today's lunch"
                let interaction = INInteraction(intent: mealIntent, response: nil)
                interaction.donate { (error) in
                    if error != nil {
                        if let error = error as NSError? {
                            print("Interaction donation failed: \(error.description)")
                        } else {
                            print("Successfully donated interaction")
                        }
                    }
                }
            default:
                break
            }
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
