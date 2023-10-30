import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    let context: NSManagedObjectContext
    
    private init() {
        let container = NSPersistentContainer(name: "AppDataModel")
        container.loadPersistentStores { (description, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        self.context = container.viewContext
    }
}
