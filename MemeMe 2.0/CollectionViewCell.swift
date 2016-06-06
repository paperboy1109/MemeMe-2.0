//
//  CollectionViewCell.swift
//  MemeMe 2.0
//
//  Created by Daniel J Janiak on 6/6/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionCellImg: UIImageView!
    @IBOutlet weak var topLbl: UILabel!
    @IBOutlet weak var bottomLbl: UILabel!
    
    var meme: Meme!
    
    func configureCell(meme: Meme) {
        self.meme = meme
        collectionCellImg.image = meme.originalImg
        topLbl.text = meme.topMemeText
        bottomLbl.text = meme.bottomMemeText
    }
    

}
