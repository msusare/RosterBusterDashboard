//
//  RosterDetailsTableViewCell.swift
//  RosterBusterDashboard
//
//  Created by Mayur Susare on 30/05/21.
//

import UIKit

class RosterDetailsTableViewCell: UITableViewCell {
    static let identifier = "RosterDetailsTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(model: [[String: Any]], indexPathRow: Int) {
        let itemTitle = Array(model[indexPathRow].keys)[0]
        let itemDescription = model[indexPathRow][itemTitle] as? String
        textLabel?.text = itemTitle
        textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        textLabel?.numberOfLines = 0
        detailTextLabel?.text = itemDescription == "" ? "NA" : itemDescription
        detailTextLabel?.numberOfLines = 0
        detailTextLabel?.font = UIFont.systemFont(ofSize: 18)
    }
    
}
