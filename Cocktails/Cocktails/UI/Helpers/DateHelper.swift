import Foundation

// MARK: - Date Helper

struct DateHelper {
    private static var parseDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.parseDateFormat
        return formatter
    }
    
    private static var displayDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.displayDateFormat
        return formatter
    }
    
    static func formatLastModifiedDate(_ dateString: String?) -> String? {
        guard
            let dateStr = dateString,
            let date = parseDateFormatter.date(from: dateStr) else {
            return nil
        }
        
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

fileprivate enum Constants {
    static let todayString: String = "Today"
    static let thisWeekString: String = "This week"
    static let thisMonthString: String = "This month"
    static let thisYearString: String = "This year"
    static let parseDateFormat: String = "yyyy-MM-dd HH:mm:ss"
    static let displayDateFormat: String = "dd-MM-yyyy"
}
