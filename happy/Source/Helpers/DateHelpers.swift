// File: DateHelpers.swift
import Foundation

extension Date {
    
    var longString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: self)
    }
    
    var relativeString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    var birthdayString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
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
}
