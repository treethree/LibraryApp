//
//  DatabaseManager.swift
//  LibraryApp
//
//  Created by SHILEI CUI on 4/2/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import Foundation
import CoreData

//Manager class is responsible for managing and handling database setup and db operation.
class DatabaseManager{
    static let shared = DatabaseManager()
    private init(){}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LibraryApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        //before ios 10, default value for these two property are false
        //to in order to support database migratation
//        let persistentDescription = NSPersistentStoreDescription()
//        persistentDescription.shouldInferMappingModelAutomatically = true
//        persistentDescription.shouldMigrateStoreAutomatically = true
//        container.persistentStoreDescriptions = [persistentDescription]
        
        return container
    }()
    
    var mainContext : NSManagedObjectContext{
        
        //viewContext is attached to main queue (serial queue)
        return persistentContainer.viewContext
    }
    
    func saveContext(context: NSManagedObjectContext){
        if context.hasChanges{
            do{
                try context.save()
            }catch{
                print("error in saving context")
            }
        }
    }
    
    func addBookDept(name: String, id: Int32, location: String){
        
        //another way to implement background context
        persistentContainer.performBackgroundTask { (bgContext) in
            //let bgContext = self.persistentContainer.newBackgroundContext()
            let dept = BookDepartment(context: bgContext)
            dept.depName = name
            dept.depId = id
            dept.depLocation = location
            dept.bookNums = 0
            
            let insertObjs = [NSInsertedObjectsKey: [dept.objectID]]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: insertObjs, into: [self.mainContext])
            
            self.saveContext(context: bgContext)
        }
        
    }
    
    func addBook(author : String, name: String, pages : Int32, publisher : String, deptid: Int32){
        //create background context
        let bgContext = persistentContainer.newBackgroundContext()
        
//        persistentContainer.performBackgroundTask { (bgCotext) in
//
//        }
        
        let deptFetchReq : NSFetchRequest<BookDepartment> = BookDepartment.fetchRequest()
        deptFetchReq.predicate = NSPredicate(format: "depId = %d", deptid)
        
        do{
            //every time we get only one department for each deptId
            let dept = try bgContext.fetch(deptFetchReq)
            
            if dept.count == 1{
                let bookDept = dept[0]
                
                // initialize the book record
                let book = Book(context: bgContext)
                book.author = author
                book.title = name
                book.pages = pages
                book.publisher = publisher
                            
                //here we are relating bookDept with book, method create with relationship
                bookDept.addToBooks(book)
                
                //update other context's when using multi-threading coredata.
                //instead of write one more method to fetch [book] we can use this method
                //do this for multiple context
                let updatedObjects = [NSUpdatedObjectsKey: [bookDept.objectID]]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: updatedObjects, into: [mainContext])
                saveContext(context: bgContext)
            }
        }catch{
            print("error in fetching ")
        }
    }
    
    func fetchBookDepts() -> [BookDepartment]{
        let bookDeptFetchReq : NSFetchRequest<BookDepartment> = BookDepartment.fetchRequest()
        do{
            let depts = try mainContext.fetch(bookDeptFetchReq)
            return depts
        }catch{
            print("error in fetching")
        }
        return []
    }
    
    func deleteBook(){
        
    }
    
    func deleteBookDept(bookDept: BookDepartment){
        mainContext.delete(bookDept)
        saveContext(context: mainContext)
        
    }
    
//    func setupDatabase(){
//        if #available(iOS 10 , *){
//            //code for supporting ios 10 and later
//        }else{
//            //write code for supporting ios9 or below version of your app
//
//            let mom = NSManagedObjectModel(contentsOf: Bundle.main.bundleURL.appendingPathComponent("myapp.sqlite"))
//            let psc = NSPersistentStoreCoordinator(managedObjectModel: mom!)
//            let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
//            do {
//                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
//            } catch {
//                fatalError("Failed to add persistent store: \(error)")
//            }
//
//            let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        }
//    }
    
    
}

//multi context mean multi thread
//NSManagedObjectContext(attached to a thread):

//writting operation (non UI) preferably need to be done on bg context
//reading/fetching operations mostly will be done on main context


//objectID - every record/row in the database will have a unique id generated by coredata. this is of class type NSManagedObjectID[thread safe].
//objectID is only thing which is thread safe in core data. others is not thread safe
//core data is not thread safe

//mock: imitation od logit class or function
//stub: fake data

//rdmbs - relational database management system(SQL, MySQL)
//SQLite - is relational database(ORM - object relational model)
//Coredata - is a framework, based on object graph model(OGM)

//when you can use multiple store u can use multiple store coordinator.
