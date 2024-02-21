//
//  feedcell.swift
//  sosyalmedya2
//
//  Created by Emir Seçer on 12.09.2023.
//

import UIKit

class feedcell: UITableViewCell {
    @IBOutlet weak var epostatext: UILabel!
    @IBOutlet weak var cellimage: UIImageView!
    @IBOutlet weak var yorumtext: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
