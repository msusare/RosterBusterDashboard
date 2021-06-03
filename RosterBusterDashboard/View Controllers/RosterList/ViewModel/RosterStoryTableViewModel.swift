//
//  RosterStoryTableViewCellViewModel.swift
//  RosterBusterDashboard
//
//  Created by Mayur Susare on 27/05/21.
//

import Foundation
import UIKit
import Network
import CoreData

class RosterStoryTableViewModel {
    
    //MARK:- Variables
    let url = URL(string: Configuration.baseUrl)
    private var groupedStories  = [[String? : [Story]]]()
    
    private var context: UIViewController?
    
    fileprivate var fetchedResultsController: NSFetchedResultsController<Story>?
    
    //Internal Constants
    struct Constants {
        static let dateFormatter = "dd/MM/yyyy"
        static let headerDateFormatter = "E dd MMM, yyyy"
        static let entityName = "Story"
        static let networkQueue = "Network"
    }
    
    //MARK:- Methods
    //Initialiser
    init(context: UIViewController) {
        self.context = context
        self.setupFetchResultController()
    }
    
    func formatTitle(_ title: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormatter
        dateFormatter.locale = Locale.current

        
        guard let todayDate = dateFormatter.date(from: title) else { return nil }
        dateFormatter.dateFormat = Constants.headerDateFormatter
                    
        return dateFormatter.string(from: todayDate)
    }
    
    private func setupFetchResultController(){
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Story> = Story.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        let appDelegate =
                UIApplication.shared.delegate as? AppDelegate
        
        let managedContext =
            appDelegate!.persistentContainer.viewContext

        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)

        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self.context as? RosterListViewController
        
        self.fetchedResultsController = fetchedResultsController
    }
    
    func retriveRosterData(completionHandler: @escaping ([[String? : [Story]]]?, Error?) -> Void) {
        checkNetworkConnection(completionHandler: { (response, error) in
            completionHandler(response, error)
        })
    }
    
    func fetchDataFromAPI(completionHandler: @escaping ([[String? : [Story]]]?, Error?) -> Void) {
        
        APIManager.readDataFromBaseUrl(url: url) { [weak self] (rosterStoryElement, response, error) in
            if let rosterStoryElement = rosterStoryElement {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = Constants.dateFormatter
                
                DispatchQueue.main.async {
                    //delete all data from DB and Save new data
                    self?.deleteAllDataFromDB(Constants.entityName)
                    self?.insertNewDataToDB(rosterStoryElement)
                }
            }

            self?.fetchDataFromDB(completionHandler:{ (response, error) in
                completionHandler(response, error)
            })
        }
    }
    
    func checkNetworkConnection(completionHandler: @escaping ([[String? : [Story]]]?, Error?) -> Void)
    {
        let monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                //connected To internet
                self?.fetchDataFromAPI(completionHandler: { (response, error) in
                    completionHandler(response, error)
                })
            }else{
                //No internet
                self?.fetchDataFromDB(completionHandler:{ (response, error) in
                    completionHandler(response, error)
                })
            }
        }
        
        let queue = DispatchQueue(label: Constants.networkQueue)
        monitor.start(queue: queue)
    }
    
    func fetchDataFromDB(completionHandler: @escaping ([[String? : [Story]]]?, Error?) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormatter
        
        do {
            try self.fetchedResultsController?.performFetch()
            
            let stories = self.fetchedResultsController?.fetchedObjects
            
            if (stories?.count ?? 0) > 0 {
                let groupedStories = Dictionary(grouping: stories ?? [], by: { $0.date })
                
                self.groupedStories = groupedStories.sorted(by: { dateFormatter.date(from:$0.key ?? "")?.compare(dateFormatter.date(from:$1.key ?? "") ?? Date()) == .orderedDescending }).map({[$0.key: $0.value]})
                
                completionHandler(self.groupedStories, nil)
            }
            
        } catch {
//            let fetchError = error as NSError
            completionHandler(nil, error)
        }
    }
    
    func insertNewDataToDB(_ stories: [RosterStoryElement]) {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        for (_ , story) in stories.enumerated() {
            let newStory = Story(context: managedContext)
            newStory.flightnr = story.flightnr
            newStory.tail = story.tail
            newStory.date = story.date
            newStory.departure = story.departure
            newStory.destination = story.destination
            newStory.timeArrive = story.timeArrive
            newStory.timeDepart = story.timeDepart
            newStory.dutyCode = story.dutyCode?.rawValue ?? ""
            newStory.dutyID = story.dutyID?.rawValue ?? ""
            newStory.captain = story.captain
            newStory.firstOfficer = story.firstOfficer
            newStory.flightAttendant = story.flightAttendant 
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteAllDataFromDB(_ entityName:String) {
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                managedContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entityName) error :", error)
        }
    }
}
