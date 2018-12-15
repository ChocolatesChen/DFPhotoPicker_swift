//
//  Date+Extension.swift
//  DFPhotoPicker_swift
//
//  Created by cg on 2018/12/14.
//  Copyright © 2018 df. All rights reserved.
//

import Foundation
extension Date {
    
    /**
     *  Convenient accessor of the date's `Calendar` components.
     *
     *  - parameter component: The calendar component to access from the date
     *
     *  - returns: The value of the component
     *
     */
    public func component(_ component: Calendar.Component) -> Int {
        let calendar = Calendar.autoupdatingCurrent
        return calendar.component(component, from: self)
    }
    
    // MARK: - Components
    
    /**
     *  Convenience getter for the date's `era` component
     */
    public var era: Int {
        return component(.era)
    }
    
    /**
     *  Convenience getter for the date's `year` component
     */
    public var year: Int {
        return component(.year)
    }
    
    /**
     *  Convenience getter for the date's `month` component
     */
    public var month: Int {
        return component(.month)
    }
    
    /**
     *  Convenience getter for the date's `week` component
     */
    public var week: Int {
        return component(.weekday)
    }
    
    /**
     *  Convenience getter for the date's `day` component
     */
    public var day: Int {
        return component(.day)
    }
    
    /**
     *  Convenience getter for the date's `hour` component
     */
    public var hour: Int {
        return component(.hour)
    }
    
    /**
     *  Convenience getter for the date's `minute` component
     */
    public var minute: Int {
        return component(.minute)
    }
    
    /**
     *  Convenience getter for the date's `second` component
     */
    public var second: Int {
        return component(.second)
    }
    
    /**
     *  Convenience getter for the date's `weekday` component
     */
    public var weekday: Int {
        return component(.weekday)
    }
    
    /**
     *  Convenience getter for the date's `weekdayOrdinal` component
     */
    public var weekdayOrdinal: Int {
        return component(.weekdayOrdinal)
    }
    
    /**
     *  Convenience getter for the date's `quarter` component
     */
    public var quarter: Int {
        return component(.quarter)
    }
    
    /**
     *  Convenience getter for the date's `weekOfYear` component
     */
    public var weekOfMonth: Int {
        return component(.weekOfMonth)
    }
    
    /**
     *  Convenience getter for the date's `weekOfYear` component
     */
    public var weekOfYear: Int {
        return component(.weekOfYear)
    }
    
    /**
     *  Convenience getter for the date's `yearForWeekOfYear` component
     */
    public var yearForWeekOfYear: Int {
        return component(.yearForWeekOfYear)
    }
    
    /**
     *  Convenience getter for the date's `daysInMonth` component
     */
    public var daysInMonth: Int {
        let calendar = Calendar.autoupdatingCurrent
        let days = calendar.range(of: .day, in: .month, for: self)
        return days!.count
    }
    
    
    /**
     *  Determine if date is within the current day
     */
    public var isToday: Bool {
        let calendar = Calendar.autoupdatingCurrent
        return calendar.isDateInToday(self)
    }
    /**
     *  Determine if date is within the day tomorrow
     */
    public var isTomorrow: Bool {
        let calendar = Calendar.autoupdatingCurrent
        return calendar.isDateInTomorrow(self)
    }
    /**
     *  Determine if date is within yesterday
     */
    public var isYesterday: Bool {
        let calendar = Calendar.autoupdatingCurrent
        return calendar.isDateInYesterday(self)
    }
    /**
     *  Determine if date is in a weekend
     */
    public var isWeekend: Bool {
        if weekday == 7 || weekday == 1 {
            return true
        }
        return false
    }
    /**
     *  Determine if date is in a leap year
     */
    public var isInLeapYear: Bool {
        let yearComponent = component(.year)
        
        if yearComponent % 400 == 0 {
            return true
        }
        if yearComponent % 100 == 0 {
            return false
        }
        if yearComponent % 4 == 0 {
            return true
        }
        return false
    }
    /**
     *  Determine if date is in a year
     */
    public var isThisYear: Bool {
        let calendar = Calendar.current as NSCalendar
        let unit: NSCalendar.Unit = [.year]
        // 1.获得当前时间的年月日
        let nowCmps: DateComponents = calendar.components(unit, from: Date())
        
        // 2.获得self的年月日
        let selfCmps: DateComponents = calendar.components(unit, from: self)
        
        return nowCmps.year == selfCmps.year
    }
    /**
     *  Determine if date is Within the same week
     */
    public var isSameWeek: Bool {
        let calendar = Calendar.current as NSCalendar
        let unit: NSCalendar.Unit = [.weekday, .month, .year]
        
        //1.获得当前时间的 年月日
        let nowCmps: DateComponents = calendar.components(unit, from: Date())
        
        //2.获得self
        let selfCmps: DateComponents = calendar.components(unit, from: self)
        
        return (selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps.month) && (selfCmps.day == nowCmps.day)
    }

    func getNowWeekday() -> String? {
        let dateday = DateFormatter()
        let language = NSLocale.preferredLanguages.first
        
        if language?.hasPrefix("en") ?? false {
            // 英文
            dateday.dateFormat = "MMM dd"
            dateday.dateFormat = "EEE"
        } else if language?.hasPrefix("zh") ?? false {
            // 中文
            dateday.dateFormat = "MM月dd日"
            dateday.dateFormat = "EEEE"
        } else {
            // 英文
            dateday.dateFormat = "MMM dd"
            dateday.dateFormat = "EEE"
        }
        return dateday.string(from: self)
    }
    func dateString(withFormat format: String?) -> String? {
        let formater = DateFormatter()
        formater.dateFormat = format ?? ""
        return formater.string(from: self)
    }
}
