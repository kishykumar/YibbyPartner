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

class WeeklyEarningsViewController: BaseYibbyViewController, JTCalendarDelegate {

    // MARK: Properties
    
    @IBOutlet weak var calendarMenuOutlet: JTCalendarMenuView!
    @IBOutlet weak var calendarOutlet: JTHorizontalCalendarView!
    
    var calendarManager: JTCalendarManager!
    var dateSelected: Date?
    
    var startOfTheWeek: Date!
    var endOfWeek: Date!

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
        
        var calendar = self.calendarManager.dateHelper.calendar()
        calendar?.firstWeekday = 4 // Wednesday
        
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
    
    func calendar(_ calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
        
        dayView.isHidden = false
        
        if let dayView = dayView as? JTCalendarDayView {
            // Test if the dayView is from another month than the page
            // Use only in month mode for indicate the day of the previous or next month
            
            // Selected Day
            // Today
            if calendarManager.dateHelper.date(Date(), isTheSameDayThan: dayView.date) {
                dayView.circleView.isHidden = false
                dayView.circleView.backgroundColor = UIColor.blue
                dayView.dotView.backgroundColor = UIColor.white
                dayView.textLabel.textColor = UIColor.white
            }
            else if ((self.dateSelected != nil) &&
                calendarManager.dateHelper.date(self.dateSelected, isTheSameDayThan: dayView.date)) {
                dayView.circleView.isHidden = false
                dayView.circleView.backgroundColor = UIColor.red
                dayView.dotView.backgroundColor = UIColor.white
                dayView.textLabel.textColor = UIColor.white
            }
            // Other month
            else if dayView.isFromAnotherMonth {
                dayView.circleView.isHidden = true
                dayView.dotView.backgroundColor = UIColor.red
                dayView.textLabel.textColor = UIColor.lightGray
            }
            // Another day of the current month
            else {
                dayView.circleView.isHidden = true
                dayView.dotView.backgroundColor = UIColor.red
                dayView.textLabel.textColor = UIColor.black
            }
        }
    }
    
    func calendar(_ calendar: JTCalendarManager!, prepareMenuItemView menuItemView: UIView!, date: Date!) {
        
        var dateFormatter: DateFormatter = DateFormatter()
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        dateFormatter.locale = calendarManager.dateHelper.calendar().locale
        dateFormatter.timeZone = calendarManager.dateHelper.calendar().timeZone
        
        (menuItemView as? UILabel)!.text = dateFormatter.string(from: date)
    }
    
    func calendar(_ calendar: JTCalendarManager, didTouchDayView dayView: UIView!) {
        
        if let dayView = dayView as? JTCalendarDayView {
            
            self.dateSelected = dayView.date
            
            // Animation for the circleView
            dayView.circleView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
            
            UIView.transition(with: dayView, duration: 0.3,
                                      options: [],
                                      animations: {() -> Void in
                
                    dayView.circleView.transform = CGAffineTransform.identity
                    self.calendarManager.reload()
                
                }, completion: { _ in
                    
                    let earningsStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Earnings, bundle: nil)
                    
                    let dailyEarningsViewController = earningsStoryboard.instantiateViewController(withIdentifier: "DailyEarningsViewControllerIdentifier") as! DailyEarningsViewController
                    
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
