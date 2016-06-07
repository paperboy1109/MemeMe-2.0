//
//  TableViewCell.swift
//  MemeMe 2.0
//
//  Created by Daniel J Janiak on 6/7/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var tableCellImg: UIImageView!
    @IBOutlet weak var memeText: UILabel!
    
    func configureCell(meme: Meme, sentMeme: UIImage) {
        
        var tempText = ""
        
        tableCellImg.image = sentMeme
        
        if let topText = meme.topMemeText {
            tempText += topText
        }
        
        if let bottomText = meme.bottomMemeText {
            tempText += " "
            tempText += bottomText
        }
        
        memeText.text = tempText
        
    }
    


}
