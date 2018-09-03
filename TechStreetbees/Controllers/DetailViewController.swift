//
//  DetailViewController.swift
//  TechStreetbees
//
//  Created by Maxence de Cussac on 23/08/2018.
//  Copyright © 2018 Maxence de Cussac. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var comicScrollView: UIScrollView! {
        didSet {
            comicScrollView.contentOffset.y += 150
        }
    }

    @IBOutlet weak var coverImageView: UIImageView! {
        didSet {
            guard let currentComic = currentComic else {
                return
            }
            if let thumbnailURL = currentComic.thumbnailURL {
                coverImageView.imageFromServerURL(url: thumbnailURL)
            }
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    func configureView() {
        guard let currentComic = currentComic else {
            return
        }
        if let titleLabel = titleLabel {
            titleLabel.text = currentComic.title
        }
        if let descriptionLabel = descriptionLabel {
            descriptionLabel.text = currentComic.officialDescription
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    var currentComic: Comic? {
        didSet {
            configureView()
        }
    }

}

