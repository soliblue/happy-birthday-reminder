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
    
    func difference(to date: Date) -> (days: Int, hours: Int, minutes: Int, seconds: Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .hour, .minute, .second], from: self, to: date)
        
        let days = components.day ?? 0
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        let seconds = components.second ?? 0
        
        return (days, hours, minutes, seconds)
    }
    
}
