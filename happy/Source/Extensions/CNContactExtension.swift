import Contacts

extension CNContact {
    
    var shortName: String {
        if !self.nickname.isEmpty {
            return self.nickname
        } else if !self.givenName.isEmpty {
            return self.givenName
        } else {
            return self.familyName
        }
    }
    
    var name: String {
        if !self.nickname.isEmpty {
            return self.nickname
        } else {
            return "\(self.givenName) \(self.familyName)"
        }
    }
 
    var relevantBirthday: Date? {
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
