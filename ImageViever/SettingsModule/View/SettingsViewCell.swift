//
//  SettingsViewCell.swift
//  ImageViever
//
//  Created by Denis Medvedev on 09/02/2022.
//  Copyright © 2022 Denis Medvedev. All rights reserved.
//

import UIKit

final class SettingsViewCell: UITableViewCell {

    //MARK: inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
