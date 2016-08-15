//
//  EarningsSummaryViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 8/9/16.
//  Copyright © 2016 YibbyPartner. All rights reserved.
//

import UIKit
import JTCalendar
import CocoaLumberjack
import BaasBoxSDK

public typealias FetchEarningsSuccessBlock = () -> Void

class EarningsSummaryViewController: UIViewController, JTCalendarDelegate {

    // MARK: Properties
    
    @IBOutlet weak var calendarMenuOutlet: JTCalendarMenuView!
    @IBOutlet weak var calendarOutlet: JTHorizontalCalendarView!
    @IBOutlet weak var summaryEarningsOutlet: UIView!
    
    var calendarManager: JTCalendarManager!
    var dateSelected: NSDate?
    var startOfTheWeek: NSDate?
    var endOfWeek: NSDate?
    
    // MARK: Actions
    
    @IBAction func viewDetailedEarningsAction(sender: AnyObject) {

        let earningsStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Earnings, bundle: nil)
        
        let weeklyEarningsViewController = earningsStoryboard.instantiateViewControllerWithIdentifier("WeeklyEarningsViewControllerIdentifier") as! WeeklyEarningsViewController
        
        weeklyEarningsViewController.startOfTheWeek = self.startOfTheWeek
        weeklyEarningsViewController.endOfWeek = self.endOfWeek

        self.navigationController!.pushViewController(weeklyEarningsViewController, animated: true)
    }
    
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
        self.calendarManager.setDate(NSDate())
        self.calendarManager.dateHelper.calendar().firstWeekday = 4 // Wednesday
        
        computeStartEndWeek(NSDate())
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
            
            // Selected week
            if (self.startOfTheWeek != nil && self.endOfWeek != nil &&
                calendarManager.dateHelper.date(dayView.date, isEqualOrAfter: self.startOfTheWeek!, andEqualOrBefore: self.endOfWeek!)) {
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
            // Today
            else if calendarManager.dateHelper.date(NSDate(), isTheSameDayThan: dayView.date) {
                dayView.circleView.hidden = false
                dayView.circleView.backgroundColor = UIColor.blueColor()
                dayView.dotView.backgroundColor = UIColor.whiteColor()
                dayView.textLabel.textColor = UIColor.whiteColor()
            }
            // Selected Day
            else if ((self.dateSelected != nil) &&
                        calendarManager.dateHelper.date(self.dateSelected, isTheSameDayThan: dayView.date)) {
                dayView.circleView.hidden = false
                dayView.circleView.backgroundColor = UIColor.redColor()
                dayView.dotView.backgroundColor = UIColor.whiteColor()
                dayView.textLabel.textColor = UIColor.whiteColor()
            }
            // Another day of the current month
            else {
                dayView.circleView.hidden = true
                dayView.dotView.backgroundColor = UIColor.redColor()
                dayView.textLabel.textColor = UIColor.blackColor()
            }
            
            // Your method to test if a date have an event for example
//            if self.haveEventForDay(dayView.date) {
//                dayView.dotView.hidden = false
//            }
//            else {
//                dayView.dotView.hidden = true
//            }
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
            
            computeStartEndWeek(dayView.date)
            
            // Animation for the circleView
            dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1)
            
            UIView.transitionWithView(dayView, duration: 0.3, options: [], animations: {() -> Void in
                dayView.circleView.transform = CGAffineTransformIdentity
                
                // Load the data for this week from the server
                self.fetchWeeklyEarnings(self.startOfTheWeek!, weekEnd: self.endOfWeek!, successBlock: {() -> Void in
                    self.calendarManager.reload()
                })
                
                }, completion: { _ in })
            
            // Don't change page in week mode because block the selection of days in first and last weeks of the month
//            if calendarManager.settings.weekModeEnabled {
//                return
//            }
            
            // Load the previous or next page if touch a day from another month
//            if !calendarManager.dateHelper.date(calendarOutlet.date, isTheSameMonthThan: dayView.date) {
//                if calendarOutlet.date.compare(dayView.date) == .OrderedDescending {
//                    calendarOutlet.loadNextPageWithAnimation()
//                }
//                else {
//                    calendarOutlet.loadPreviousPageWithAnimation()
//                }
//            }
        }
    }

    func calendarBuildDayView(calendar: JTCalendarManager!) -> UIView! {
        let view: JTCalendarDayView = JTCalendarDayView()
        
        view.textLabel.font = UIFont(name: "Avenir-Light", size: 13)
        view.circleRatio = 2
        view.dotRatio = 1.0 / 0.9
        
        return view
    }
    
    // MARK: Helpers
    
    
    func fetchWeeklyEarnings(weekStart: NSDate, weekEnd: NSDate, successBlock: FetchEarningsSuccessBlock) {
        WebInterface.makeWebRequestAndHandleError(
            self,
            webRequest: {(errorBlock: (BAAObjectResultBlock)) -> Void in
                
                // enable the loading activity indicator
                ActivityIndicatorUtil.enableActivityIndicator(self.view)
                
                let client: BAAClient = BAAClient.sharedClient()
                
                client.dummyCall( {(success, error) -> Void in
                    
                    // diable the loading activity indicator
                    ActivityIndicatorUtil.disableActivityIndicator(self.view)
                    //                    if (error == nil) {
                    successBlock()
                    //                    }
                    //                    else {
                    //                        errorBlock(success, error)
                    //                    }
                })
        })
    }
    
    func computeStartEndWeek(inDate: NSDate) {
        let calendar = calendarManager.dateHelper.calendar()
        var interval = NSTimeInterval(0)
        
        calendar.rangeOfUnit(.WeekOfMonth, startDate: &self.startOfTheWeek, interval: &interval, forDate: inDate)
        self.endOfWeek = self.startOfTheWeek!.dateByAddingTimeInterval(interval - 1)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
