import Foundation

struct Human: Identifiable {
    var id = UUID()
    var name: String
    var nickname: String?
    var birthdate: Date
    var phoneNumber: String?
    var email: String?
    var imageData: Data?
    
    var age: Int {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: birthdate, to: now)
        return ageComponents.year ?? 0
    }
    
    var birthdayPassed: Bool {
        let calendar = Calendar.current
        let now = Date()
        var nextBirthdayComponents = calendar.dateComponents([.day, .month], from: birthdate)
        nextBirthdayComponents.year = calendar.component(.year, from: now)
        
        let nextBirthdayThisYear = calendar.date(from: nextBirthdayComponents) ?? now
        
        return nextBirthdayThisYear < now
    }
    
    var nextBirthday: Date {
        let calendar = Calendar.current
        let now = Date()
        var nextBirthdayComponents = calendar.dateComponents([.day, .month], from: birthdate)
        nextBirthdayComponents.year = calendar.component(.year, from: now)
        
        var nextBirthday = calendar.date(from: nextBirthdayComponents) ?? now
        
        if nextBirthday < now {
            // If the birthday has already occurred this year, calculate next year's birthday
            nextBirthdayComponents.year! += 1
            nextBirthday = calendar.date(from: nextBirthdayComponents) ?? now
        }
        
        return nextBirthday
    }
}
