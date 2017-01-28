//
//  CollectionViewController.swift
//  Meme
//
//  Created by 박종훈 on 2017. 1. 28..
//  Copyright © 2017년 박종훈. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

let memeTextAttributes:[String:Any] = [
    NSStrokeColorAttributeName: UIColor.black,
    NSForegroundColorAttributeName: UIColor.white,
    NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
    NSStrokeWidthAttributeName: -3.0]

class CollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var memes: [Meme] = []
    var isCellEditing: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UINib(nibName: "MemeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        // Do any additional setup after loading the view.
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        memes = appDelegate.memes
        self.collectionView?.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        setNormalMode()
        if let collectionView = self.collectionView, let indexPathsForSelectedItems = collectionView.indexPathsForSelectedItems {
            for indexPath in indexPathsForSelectedItems {
                collectionView.deselectItem(at: indexPath, animated: false)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UI Action
    @IBAction func edit(_ sender: UIBarButtonItem) {
        if isCellEditing {
            deleteCells()
            setNormalMode()
        } else {
            setDeleteMode()
        }
    }
    
    func setDeleteMode() {
        self.collectionView?.allowsMultipleSelection = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(CollectionViewController.edit(_:)))
        isCellEditing = true
    }
    
    func setNormalMode() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(CollectionViewController.edit(_:)))
        self.collectionView?.allowsMultipleSelection = false
        isCellEditing = false
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
    
        // Configure the cell
        cell.imageView.image = memes[indexPath.item].originalImage
        
        cell.topLabel.attributedText = NSAttributedString(string: memes[indexPath.row].topText, attributes: memeTextAttributes)
        cell.bottomLabel.attributedText = NSAttributedString(string: memes[indexPath.row].bottomText, attributes: memeTextAttributes)
        cell.checkImageView.isHidden = true
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        // edit 상태
        if isCellEditing {
            if let cell: MemeCollectionViewCell = collectionView.cellForItem(at: indexPath) as? MemeCollectionViewCell {
                cell.setSelected()
            }
        }
        // 일반
        else {
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
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell: MemeCollectionViewCell = collectionView.cellForItem(at: indexPath) as? MemeCollectionViewCell {
            cell.setDeSelected()
        }
    }
    
    func deleteCells() {
        if let collectionView = self.collectionView, let indexPathsForSelectedItems = collectionView.indexPathsForSelectedItems {
            let indexPaths = indexPathsForSelectedItems.sorted(by: { (pre, post) -> Bool in
                return pre.item > post.item
            })
            for indexPath in indexPaths {
                appDelegate.memes.remove(at: indexPath.item)
                memes = appDelegate.memes
            }
            collectionView.deleteItems(at: indexPathsForSelectedItems)
        }
    }
}
