//
//  WeeklyEarningsViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 8/14/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit
import JTCalendar
import CocoaLumberjack
import BaasBoxSDK

class WeeklyEarningsViewController: UIViewController, JTCalendarDelegate {

    // MARK: Properties
    
    @IBOutlet weak var calendarMenuOutlet: JTCalendarMenuView!
    @IBOutlet weak var calendarOutlet: JTHorizontalCalendarView!
    
    var calendarManager: JTCalendarManager!
    var dateSelected: NSDate?
    
    var startOfTheWeek: NSDate!
    var endOfWeek: NSDate!

    // MARK: Actions
    
    
    // MARK: Setup functions
    
    
    func setupUI() {
        
    }
    
    func initProperties() {
        
    }

    func setupCalendar() {
        self.calendarManager = JTCalendarManager()
        self.calendarManager.delegate = self
        self.calendarManager.menuView = calendarMenuOutlet
        self.calendarManager.contentView = calendarOutlet
        self.calendarManager.dateHelper.calendar().firstWeekday = 4 // Wednesday
        self.calendarManager.setDate(startOfTheWeek)
        self.calendarManager.settings.weekModeEnabled = true

        self.calendarManager.reload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initProperties()
        setupUI()
        setupCalendar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: JTCalendarDelegate
    
    func calendar(calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
        
        dayView.hidden = false
        
        if let dayView = dayView as? JTCalendarDayView {
            // Test if the dayView is from another month than the page
            // Use only in month mode for indicate the day of the previous or next month
            
            // Selected Day
            // Today
            if calendarManager.dateHelper.date(NSDate(), isTheSameDayThan: dayView.date) {
                dayView.circleView.hidden = false
                dayView.circleView.backgroundColor = UIColor.blueColor()
                dayView.dotView.backgroundColor = UIColor.whiteColor()
                dayView.textLabel.textColor = UIColor.whiteColor()
            }
            else if ((self.dateSelected != nil) &&
                calendarManager.dateHelper.date(self.dateSelected, isTheSameDayThan: dayView.date)) {
                dayView.circleView.hidden = false
                dayView.circleView.backgroundColor = UIColor.redColor()
                dayView.dotView.backgroundColor = UIColor.whiteColor()
                dayView.textLabel.textColor = UIColor.whiteColor()
            }
            // Other month
            else if dayView.isFromAnotherMonth {
                dayView.circleView.hidden = true
                dayView.dotView.backgroundColor = UIColor.redColor()
                dayView.textLabel.textColor = UIColor.lightGrayColor()
            }
            // Another day of the current month
            else {
                dayView.circleView.hidden = true
                dayView.dotView.backgroundColor = UIColor.redColor()
                dayView.textLabel.textColor = UIColor.blackColor()
            }
        }
    }
    
    func calendar(calendar: JTCalendarManager!, prepareMenuItemView menuItemView: UIView!, date: NSDate!) {
        
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        
        dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        dateFormatter.locale = calendarManager.dateHelper.calendar().locale
        dateFormatter.timeZone = calendarManager.dateHelper.calendar().timeZone
        
        (menuItemView as? UILabel)!.text = dateFormatter.stringFromDate(date)
    }
    
    func calendar(calendar: JTCalendarManager, didTouchDayView dayView: UIView!) {
        
        if let dayView = dayView as? JTCalendarDayView {
            
            self.dateSelected = dayView.date
            
            // Animation for the circleView
            dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1)
            
            UIView.transitionWithView(dayView, duration: 0.3,
                                      options: [],
                                      animations: {() -> Void in
                
                    dayView.circleView.transform = CGAffineTransformIdentity
                    self.calendarManager.reload()
                
                }, completion: { _ in
                    
                    let earningsStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Earnings, bundle: nil)
                    
                    let dailyEarningsViewController = earningsStoryboard.instantiateViewControllerWithIdentifier("DailyEarningsViewControllerIdentifier") as! DailyEarningsViewController
                    
                    dailyEarningsViewController.selectedDate = self.dateSelected
                    
                    self.navigationController!.pushViewController(dailyEarningsViewController, animated: true)
                }
            )
        }
    }
    
//    func calendarBuildDayView(calendar: JTCalendarManager!) -> UIView! {
//        let view: JTCalendarDayView = JTCalendarDayView()
//        
//        view.textLabel.font = UIFont(name: "Avenir-Light", size: 13)
//        view.circleRatio = 2
//        view.dotRatio = 1.0 / 0.9
//        
//        return view
//    }
    
    // MARK: Helper functions

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}