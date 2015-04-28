//
//  ProjectsListCell.swift
//  MobileTimeRecording
//
//  Created by DanNglk on 28/04/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

import UIKit


class ProjectsListCell: UITableViewCell
{
    @IBOutlet weak var projectID: UILabel!
    @IBOutlet weak var projectName: UILabel!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
