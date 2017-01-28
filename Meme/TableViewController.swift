//
//  TableViewController.swift
//  Meme
//
//  Created by 박종훈 on 2017. 1. 28..
//  Copyright © 2017년 박종훈. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var memes: [Meme] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        memes = appDelegate.memes
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableCell", for: indexPath) as! TableViewCell

        // Configure the cell...
        cell.memeImageView.image = memes[indexPath.row].originalImage
        
        cell.memeTopLabel.attributedText = NSAttributedString(string: memes[indexPath.row].topText, attributes: memeTextAttributes)
        cell.memeBottomLabel.attributedText = NSAttributedString(string: memes[indexPath.row].bottomText, attributes: memeTextAttributes)
        cell.memeTitleLabel.text = memes[indexPath.row].topText + " " + memes[indexPath.row].bottomText
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            appDelegate.memes.remove(at: indexPath.row)
            memes = appDelegate.memes
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Grab the editViewController from Storyboard
        let editNVC = self.storyboard!.instantiateViewController(withIdentifier: "EditNVC") as! UINavigationController

        // Present the view controller using navigation
        self.present(editNVC, animated: true, completion: {
            let editViewController = editNVC.topViewController as! EditViewController
            //Populate view controller with data from the selected item
            editViewController.topTextField.text = self.memes[indexPath.item].topText
            editViewController.bottomTextField.text = self.memes[indexPath.item].bottomText
            editViewController.imagePickerView.image = self.memes[indexPath.item].originalImage
            editViewController.shareButton.isEnabled = true
        })
    }

}
