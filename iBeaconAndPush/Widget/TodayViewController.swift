//
//  TodayViewController.swift
//  Widget
//
//  Created by Enkhjargal Gansukh on 12/25/15.
//  Copyright © 2015 Enkhjargal Gansukh. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var widgetImage: UIImageView!
    @IBOutlet weak var widgetLabel: UILabel!
    
    var timer:NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        widgetLabel.text = "finding iBeacon"
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
//        dispatch_async(dispatch_get_main_queue(),{
//            self.widgetLabel.text = ""
//            
//            //2
//            let defaults:NSUserDefaults = NSUserDefaults(suiteName: "group.beaconwidget")!
//            self.widgetLabel.text = defaults.objectForKey("widgetData") as? String
//        });
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateData:", name: NSUserDefaultsDidChangeNotification, object: nil)
        completionHandler(NCUpdateResult.NewData)
    }
    
    @IBAction func refreshData(sender: AnyObject) {
        updateLabel()
    }
    
    func updateData(notif:NSNotification){
        let sharedDefaults = NSUserDefaults.init(suiteName: "group.beaconwidget")
        let data: String = sharedDefaults!.objectForKey("widgetData") as! String
        widgetLabel.text = data
    }
//
    func updateLabel(){
        let sharedDefaults = NSUserDefaults.init(suiteName: "group.beaconwidget")
        let data: String = sharedDefaults!.objectForKey("widgetData") as! String
        widgetLabel.text = data
    }
    
}
