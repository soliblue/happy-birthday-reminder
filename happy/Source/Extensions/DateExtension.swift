// File: DateHelpers.swift
import Foundation

extension Date {
    
    var longString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: self)
    }
    
    var shortString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy"
        return formatter.string(from: self)
    }
    
    var relativeString: String {
        let calendar = Calendar.current
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let dayDifference = calendar.dateComponents([.day], from: Date(), to: self).day ?? 0
        let adjustedDate = dayDifference > 0 ? calendar.date(byAdding: .day, value: 1, to: self) ?? self : self
        return formatter.localizedString(for: adjustedDate, relativeTo: Date())
    }
    
    var yearsSince: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: self, to: Date())
        return components.year ?? 0
    }
    
    var dayWithLeadingZero: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd" // "dd" will include the leading zero for days less than 10
        return formatter.string(from: self)
    }
    
    var month: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: self)
    }
    
    var year: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: self)
    }
    
    var isToday: Bool {
        let calendar = Calendar.current
        let nowComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        let selfComponents = calendar.dateComponents([.day, .month, .year], from: self)
        
        return nowComponents.day == selfComponents.day &&
        nowComponents.month == selfComponents.month &&
        nowComponents.year == selfComponents.year
    }
    
    var relevantBirthday: Date {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var components = calendar.dateComponents([.day, .month], from: self)
        components.year = calendar.component(.year, from: today)
        
        guard let thisYearsBirthday = calendar.date(from: components) else {
            fatalError("Unable to create a date from the components.")
        }
        
        if today <= thisYearsBirthday {
            return thisYearsBirthday
        }
        
        let threeMonthsAgo = calendar.date(byAdding: .month, value: -3, to: today)!
        if thisYearsBirthday > threeMonthsAgo {
            return thisYearsBirthday
        }
        
        return calendar.date(byAdding: .year, value: 1, to: thisYearsBirthday)!
    }
}
