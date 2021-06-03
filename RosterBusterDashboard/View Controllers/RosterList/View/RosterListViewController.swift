//
//  ViewController.swift
//  RosterBusterDashboard
//
//  Created by Mayur Susare on 26/05/21.
//

import UIKit
import CoreData

class RosterListViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    //MARK: - oulets
    @IBOutlet weak var tableViewRosterStories: UITableView!
    
    //MARK: - Variables
    private let refreshControl  = UIRefreshControl()
    private var groupedStories  = [[String? : [Story]]]()
    private var viewModel       : RosterStoryTableViewModel?

    //Internal Constants
    struct Constants {
        static let refreshControlMessage = "Fetching Roster Data ..."
        static let NoDataFoundMessage = "No Data Found..."
    }
    
    //MARK:- UIViewController Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = RosterStoryTableViewModel(context: self)
        //Add message to refresh view controller
        refreshControl.attributedTitle = NSAttributedString(string: Constants.refreshControlMessage)

        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableViewRosterStories.refreshControl = refreshControl
        } else {
            tableViewRosterStories.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshRostersData(_:)), for: .valueChanged)
        
        //Check if network connection is available and use data
        setupData()
    }
    
    private func setupData() {
        viewModel?.retriveRosterData(completionHandler: { [weak self] (response, error) in
            guard let groupedStories = response, error == nil else{
                return
            }
            
            self?.groupedStories = groupedStories
            
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                self?.tableViewRosterStories.reloadData()
            }
        })
        
    }
    
    @objc private func refreshRostersData(_ sender: Any) {
        // Fetch Rosters Data and setup UI
        setupData()
    }
    
}


//MARK:- Table View Extension
extension RosterListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let stringArray = self.groupedStories[section].keys.first, let title = stringArray  else {
            return ""
        }
        
        return viewModel?.formatTitle(title) ?? ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if groupedStories.count == 0 {
            tableView.setEmptyMessage(Constants.NoDataFoundMessage)
            return 0
        }
        tableView.restore()
        return self.groupedStories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupedStories[section].values.first?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rosterStory = self.groupedStories[indexPath.section].values.first?[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RosterStoryTableViewCell.identifier, for: indexPath) as? RosterStoryTableViewCell, let rosterStoryItem = rosterStory else {
            return UITableViewCell()
        }
        
        cell.configure(with: rosterStoryItem)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: RosterDetailsViewController.identifier) as? RosterDetailsViewController else { return }
        
        let rosterStory = self.groupedStories[indexPath.section].values.first?[indexPath.row]
        
        detailViewController.rosterStory = rosterStory
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }

}

