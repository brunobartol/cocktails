import Foundation

// MARK: - Date Helper

struct DateHelper {
    static func formatLastModifiedDate(_ date: Date) -> String {
        let calendar = Calendar.current
        
        let isCurrentYear = calendar.isDate(date, equalTo: .now, toGranularity: .year)
        let isInThisMonth = calendar.isDate(date, equalTo: .now, toGranularity: .month)
        let isInThisWeek = calendar.isDate(date, equalTo: .now, toGranularity: .weekOfYear)
        let isToday = calendar.isDate(date, equalTo: .now, toGranularity: .day)
        
        if isToday { return Constants.todayString }
        if isInThisWeek { return Constants.thisWeekString }
        if isInThisMonth { return Constants.thisMonthString }
        if isCurrentYear { return Constants.thisYearString }
        
        let yearsAgo = calendar.component(.year, from: .now) - calendar.component(.year, from: date)
        return "\(yearsAgo) years ago"
    }
}

// MARK: - Constants

fileprivate struct Constants {
    private init() {}
    
    static let todayString: String = "Today"
    static let thisWeekString: String = "This week"
    static let thisMonthString: String = "This month"
    static let thisYearString: String = "This year"
}
