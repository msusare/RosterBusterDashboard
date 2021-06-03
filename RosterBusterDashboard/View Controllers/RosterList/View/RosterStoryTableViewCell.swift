//
//  RosterStoryTableViewCell.swift
//  RosterBusterDashboard
//
//  Created by Mayur Susare on 26/05/21.
//

import UIKit

struct FontAwesomeIcons {
    static let Flight = "\u{f072}"
    static let Layover = "\u{f0f2}"
    static let StandBy = "\u{f0c5}"
}


class RosterStoryTableViewCell: UITableViewCell {
    
    static let identifier = "RosterStoryTableViewCell"
    
    @IBOutlet weak var labelTitle: UILabel!

    @IBOutlet weak var labelSubTitle: UILabel!
    
    @IBOutlet weak var labelTime: UILabel!
    
    @IBOutlet weak var labelType: UILabel!
    
    @IBOutlet weak var imageViewIcon: UIImageView!
    
    private var story: Story!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with story: Story){
        self.story = story
        var image = FontAwesomeConverter.image(fromChar: FontAwesomeIcons.Flight, color: UIColor.black, size: 40.0)
        
        labelTitle.text = ""
        labelSubTitle.text = ""
        labelType.text = ""
        labelTime.text = ""
        
        guard let dutyCodeValue = story.dutyCode, let dutyCode = DutyCode(rawValue: dutyCodeValue) else {
            return
        }
        
        switch dutyCode {
            case .flight:
                image = FontAwesomeConverter.image(fromChar:FontAwesomeIcons.Flight, color: UIColor.black, size: 40.0)
                labelTitle.text = "\(story.departure ?? "") - \(story.destination ?? "")"
                labelTime.text = "\(story.timeArrive ?? "") - \(story.timeDepart ?? "")"
                imageViewIcon.image = image
                imageViewIcon.rotate(degrees: -40)
                
            case .layover:
                labelTitle.text = "Layover"
                image = FontAwesomeConverter.image(fromChar:FontAwesomeIcons.Layover, color: UIColor.black, size: 40.0)
                labelSubTitle.text = "\(story.departure ?? "")"
                labelTime.text = "\(story.timeDepart ?? "") hours"
                imageViewIcon.image = image
                imageViewIcon.rotate(degrees: 0)

            case .off:
                labelTitle.text = "Off"
                labelSubTitle.text = "\(story.dutyID ?? "")(\(story.departure ?? ""))"
                imageViewIcon.image = image
                imageViewIcon.rotate(degrees: -40)
                
            case .positioning:
                labelTitle.text = "\(story.departure ?? "") - \(story.destination ?? "")"
                labelTime.text = "\(story.timeArrive ?? "") - \(story.timeDepart ?? "")"
                imageViewIcon.image = image
                imageViewIcon.rotate(degrees: -40)
      
            case .standby:
                image = FontAwesomeConverter.image(fromChar: FontAwesomeIcons.StandBy, color: UIColor.black, size: 40.0)
                labelTitle.text = "Standby"
                labelType.text = "Match Crew"
                labelSubTitle.text = "\(story.dutyID ?? "")(\(story.departure ?? ""))"
                labelTime.text = "\(story.timeArrive ?? "") - \(story.timeDepart ?? "")"
                imageViewIcon.image = image
                imageViewIcon.rotate(degrees: 0)
        }
    }
}

