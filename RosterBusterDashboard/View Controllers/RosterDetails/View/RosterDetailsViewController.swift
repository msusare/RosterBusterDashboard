//
//  RosterDetailsViewController.swift
//  RosterBusterDashboard
//
//  Created by Mayur Susare on 28/05/21.
//

import UIKit

class RosterDetailsViewController: UIViewController {

    //MARK:- Variable Declarations
    var rosterStory: Story?
    
    private var storyDetails: [[String: Any]]?
    
    //MARK: - oulets
    @IBOutlet weak var rosterStoryDetailsTableView: UITableView!
    
    //Internal Constants
    static let identifier = "RosterDetailsViewController"
    struct Constant {
        static let navigationTitle = "Roster Details"
    }
    
    //MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = Constant.navigationTitle
        self.rosterStoryDetailsTableView.allowsSelection = false
        storyDetails = rosterStory?.toDictionaryObject()
    }

}


//MARK:- Table View Methods
extension RosterDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storyDetails?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: RosterDetailsTableViewCell.identifier) as? RosterDetailsTableViewCell
        if cell == nil {
            cell = RosterDetailsTableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: RosterDetailsTableViewCell.identifier) 
        }
        
        guard let itemDict = storyDetails else {
            return cell ?? UITableViewCell()
        }
        
        cell?.configure(model: itemDict, indexPathRow: indexPath.row)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
}
