//
//  SentMemesCollectionViewController.swift
//  MemeMe 2.0
//
//  Created by Daniel J Janiak on 6/4/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    var sentMemes: [UIImage] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).sentMemes
    }
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.delegate = self
        collection.dataSource = self
        
        let space: CGFloat = 3.0
        let horizontalDimension = (view.frame.size.width - (2*space)) / 3.0
        let vertcalDimension = (view.frame.size.height - (2*space)) / 3.0
        let dimension = min(horizontalDimension, vertcalDimension)
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        collection.reloadData()
        
        //self.tabBarController?.tabBar.hidden = false
        //self.navigationController?.navigationBarHidden = false
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as? CollectionViewCell {
            
            /*
            let cellMeme = memes[indexPath.row]
            cell.configureCell(cellMeme)
            */
            
            cell.collectionCellImg.image = sentMemes[indexPath.row]
            
            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("didSelectItemAtIndexPath has been called")
        let memeDetailImg = sentMemes[indexPath.row]
        performSegueWithIdentifier("MemeDetailVC", sender: memeDetailImg)
    }
    
    @IBAction func addMemeTapped(sender: UIBarButtonItem) {
        let editorViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        self.navigationController!.pushViewController(editorViewController, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MemeDetailVC" {
            
            navigationItem.title = "Sent Memes"
            
            if let detailsVC = segue.destinationViewController as? MemeDetailViewController {
                if let memeDetailImg = sender as? UIImage {
                    detailsVC.detailImg = memeDetailImg
                }
            }
        }
    }

}
