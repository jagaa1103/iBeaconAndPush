//
//  AppDelegate.swift
//  iBeaconAndPush
//
//  Created by Enkhjargal Gansukh on 12/24/15.
//  Copyright © 2015 Enkhjargal Gansukh. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager: CLLocationManager?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
        let uuidString = "01122334-4556-6778-899a-abbccddeeff0"
        let beaconIdentifier = "ibeacon"
        let beaconUUID:NSUUID = NSUUID(UUIDString: uuidString)!
        let beaconRegion:CLBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID,
            identifier: beaconIdentifier)
        
        locationManager = CLLocationManager()
        if(locationManager!.respondsToSelector("requestAlwaysAuthorization")) {
            locationManager!.requestAlwaysAuthorization()
        }
        
        locationManager!.delegate = self
        locationManager!.pausesLocationUpdatesAutomatically = false
        
        locationManager!.startMonitoringForRegion(beaconRegion)
        locationManager!.startRangingBeaconsInRegion(beaconRegion)
        locationManager!.startUpdatingLocation()
        
        if(application.respondsToSelector("registerUserNotificationSettings:")) {
            application.registerUserNotificationSettings(
                UIUserNotificationSettings(
                    forTypes: [.Alert , .Sound],
                    categories: nil
                )
            )
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("App is running in Background")
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

extension AppDelegate: CLLocationManagerDelegate {
    func sendLocalNotificationWithMessage(message: String!) {
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = message
        notification.soundName = "tos_beep.caf";
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        var message:String
        if(beacons.count > 0){
            let nearestBeacon = beacons[0]
            if(beacons.count > 0) {
                let nearestBeacon:CLBeacon = beacons[0] 
//                switch nearestBeacon.proximity {
//                    case CLProximity.Far:
//                        message = "You are far away from the beacon"
//                    case CLProximity.Near:
//                        message = "You are near the beacon"
//                    case CLProximity.Immediate:
//                        message = "You are in the immediate proximity of the beacon"
//                    case CLProximity.Unknown:
//                    return
//                }
                if(nearestBeacon.rssi > -65 && nearestBeacon.rssi < 0){
                    message = "You are very close to iBeacon"
                    sendToWidget("\(nearestBeacon.rssi)")
                    sendLocalNotificationWithMessage(message)
                }

            } else {
                message = "No beacons are nearby"
            }
            print(nearestBeacon)
        }
    }
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("You are in iBeaconRegion")
        let message = "You are in iBeaconRegion"
        sendLocalNotificationWithMessage(message)
    }
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("You exited from iBeaconRegion")
        let message = "You exited from iBeaconRegion"
        sendLocalNotificationWithMessage(message)
    }
    func sendToWidget(rssi: String){
        let sharedDefaults = NSUserDefaults.init(suiteName: "group.beaconwidget")
        sharedDefaults?.setObject(rssi, forKey: "widgetData")
        sharedDefaults?.synchronize()
    }
}

