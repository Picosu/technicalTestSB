//
//  ComicsCollectionViewController.swift
//  TechStreetbees
//
//  Created by Maxence de Cussac on 31/08/2018.
//  Copyright © 2018 Maxence de Cussac. All rights reserved.
//

import UIKit
import Alamofire
import CryptoSwift

private let reuseIdentifier = "comicCollectionViewCell"

class ComicsCollectionViewController: UICollectionViewController {

    // MARK: - Variables
    var datasource = [Comic]() {
        didSet {
            DispatchQueue.main.async {
                self.comicCollectionView.reloadData()
            }
        }
    }

    // Cache
    var session = URLSession.shared
    var task = URLSessionDownloadTask()
    var cache: NSCache<AnyObject, AnyObject>! = NSCache()
    //

    // MARK: - Outlets
    @IBOutlet var comicCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.retrieveComicsData { (comics) in
            guard comics.count != 0 else {
                return
            }
            self.datasource = comics
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.comicCollectionView.register(ComicCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.comicCollectionView.register(ComicCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetail" {
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                let object = datasource[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.currentComic = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return datasource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ComicCollectionViewCell else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        }

        // Configure the cell
        cell.currentComic = datasource[indexPath.row]
        cell.configureCell()

        //
        // 1
        let currentComic = datasource[indexPath.row]

        cell.currentComic = currentComic
        // Image Cache Begin
        if let cachedImage = self.cache.object(forKey: currentComic.digitalId as AnyObject) as? UIImage {
            // 2
            // Use cache
            print("Cached image used, no need to download it")
            cell.comicImageView.image = cachedImage
        } else {
            // 3
            guard let artworkUrl = currentComic.thumbnailURL else {
                print("no profil picture")
                cell.comicImageView.image = UIImage(named: "background")
                return cell
            }
            let url: URL! = artworkUrl
            task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                if let data = try? Data(contentsOf: url) {
                    // 4
                    DispatchQueue.main.async(execute: { () -> Void in
                        // 5
                        // Before we assign the image, check whether the current cell is visible
                        if let updateCell = collectionView.cellForItem(at: indexPath) as? ComicCollectionViewCell {
                            let img: UIImage! = UIImage(data: data)
                            updateCell.comicImageView.image = img
                            self.cache.setObject(img, forKey: currentComic.digitalId as AnyObject)
                        }
                    })
                }
            })
            task.resume()
        }
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

class ComicCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var comicImageView: UIImageView! {
        didSet {
            configureCell()
        }
    }
    @IBOutlet weak var titleLabel: UILabel!

    var currentComic: Comic? {
        didSet {
            configureCell()
        }
    }

    func configureCell() {
        guard let currentComic = currentComic else {
            return
        }
        if let comicImageView = comicImageView {
            if let thumbnailURL = currentComic.thumbnailURL, comicImageView.image == nil {
                comicImageView.imageFromServerURL(url: thumbnailURL)
            }
        }
        titleLabel.text = currentComic.title ?? ""
    }

}
