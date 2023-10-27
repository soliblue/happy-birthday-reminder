import Foundation

struct Human: Identifiable, CustomStringConvertible, Equatable {
    var id = UUID()
    var name: String
    var givenName: String?
    var familyName: String?
    var nickname: String?
    var birthdate: Date
    var phoneNumber: String?
    var email: String?
    var imageData: Data?
    
    var age: Int? {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: birthdate, to: now)
        if let ageValue = ageComponents.year, ageValue > 0, ageValue <= 150 {
            return ageValue
        } else {
            return nil
        }
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
        let today = calendar.startOfDay(for: Date())
        var components = calendar.dateComponents([.day, .month], from: birthdate)
        components.year = calendar.component(.year, from: today)
        
        let thisYearsBirthday = calendar.date(from: components)!
        
        if today > thisYearsBirthday {
            let threeMonthsAgo = calendar.date(byAdding: .month, value: -3, to: today)!
            return thisYearsBirthday > threeMonthsAgo ? thisYearsBirthday : calendar.date(byAdding: .year, value: 1, to: thisYearsBirthday)!
        }
        
        return thisYearsBirthday
        
    }
    
    var description: String {
        return "Human(name: \(name), nickname: \(String(describing: nickname)), birthdate: \(birthdate), age: \(age), nextBirthday: \(nextBirthday))"
    }
    
    func hasBirthday() -> Bool {
        let calendar = Calendar.current
        let now = Date()
        
        let nowComponents = calendar.dateComponents([.day, .month], from: now)
        let birthComponents = calendar.dateComponents([.day, .month], from: birthdate)
        
        return nowComponents.day == birthComponents.day && nowComponents.month == birthComponents.month
    }
    
}
