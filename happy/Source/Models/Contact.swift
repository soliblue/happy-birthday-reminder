import Contacts

extension CNContact {
    
    var age: Int? {
        guard let birthdateDate = self.birthday?.date else {
            return nil
        }
        
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: birthdateDate, to: now)
        if let ageValue = ageComponents.year, ageValue > 0, ageValue <= 150 {
            return ageValue
        } else {
            return nil
        }
    }
    
    var name: String {
        if !self.nickname.isEmpty {
            return self.nickname
        } else {
            return "\(self.givenName) \(self.familyName)"
        }
    }

   
    func hasBirthday() -> Bool {
        guard let birthdayComponents = self.birthday else {
            return false
        }
        
        let calendar = Calendar.current
        let nowComponents = calendar.dateComponents([.day, .month], from: Date())
        
        return nowComponents.day == birthdayComponents.day && nowComponents.month == birthdayComponents.month
    }
    
    var nextBirthday: Date? {
        guard let birthdateDate = self.birthday?.date else {
            return nil
        }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // Extract only day and month from the birthdate and set the year to the current year.
        var components = calendar.dateComponents([.day, .month], from: birthdateDate)
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
