//
//  SentMemesTableViewController.swift
//  MemeMe 2.0
//
//  Created by Daniel J Janiak on 6/7/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    var sentMemes: [UIImage] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).sentMemes
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }


    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("TableCell") as? TableViewCell {
            cell.configureCell(memes[indexPath.row], sentMeme: sentMemes[indexPath.row])
            return cell
        } else {
            let cell = TableViewCell()
            cell.configureCell(memes[indexPath.row], sentMeme: sentMemes[indexPath.row])
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let memeDetailImg = sentMemes[indexPath.row]
        performSegueWithIdentifier("MemeDetailVC", sender: memeDetailImg)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 87.0
    }
    
    @IBAction func addMemeTapped(sender: UIBarButtonItem) {
        //let editorViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        //self.navigationController!.pushViewController(editorViewController, animated: true)
        performSegueWithIdentifier("TableToEditor", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MemeDetailVC2" {
            
            navigationItem.title = "Sent Memes"
            
            if let detailsVC = segue.destinationViewController as? MemeDetailViewController {
                if let memeDetailImg = sender as? UIImage {
                    detailsVC.detailImg = memeDetailImg
                }
            }
        }
    }

}
