import UserNotifications

class NotificationService {
    private let center = UNUserNotificationCenter.current()
    
    func requestAccess(completion: @escaping (Bool) -> Void) {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            completion(granted)
        }
    }
    
    func removeAllNotifications(with identifier: String, completion: @escaping () -> Void) {
        center.getPendingNotificationRequests { [weak self] requests in
            let identifiersToRemove = requests.filter { $0.content.categoryIdentifier == identifier }.map { $0.identifier }
            self?.center.removePendingNotificationRequests(withIdentifiers: identifiersToRemove)
            completion()
        }
    }
    
    func scheduleNotification(title: String, body: String, categoryIdentifier: String, triggerDate: Date, imageData: Data? = nil) {
        // First, ensure the app has the necessary permissions
        requestAccess { [weak self] granted in
            guard granted else {
                print("Notification permissions denied.")
                return
            }
            
            // Prepare the content
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.categoryIdentifier = categoryIdentifier
            // Attach the image if available
            if let imageData = imageData {
                // Write the image data to a temporary location
                let tempDirURL = URL(fileURLWithPath: NSTemporaryDirectory())
                let fileURL = tempDirURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
                do {
                    try imageData.write(to: fileURL)
                    let imageAttachment = try UNNotificationAttachment(identifier: "image", url: fileURL, options: nil)
                    content.attachments = [imageAttachment]
                } catch {
                    print("Error saving image or creating attachment: \(error)")
                }
            }
            
            // Trigger the notification 1 minute from now
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            // Create the request
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                        
            // Schedule the notification
            self?.center.add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                }
            }
        }
    }
    
    
    
}
