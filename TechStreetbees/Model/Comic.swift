//
//  Comic.swift
//  TechStreetbees
//
//  Created by Maxence de Cussac on 27/08/2018.
//  Copyright © 2018 Maxence de Cussac. All rights reserved.
//

import UIKit

class Comic: NSObject {

    /// The unique ID of the comic resource.
    var id: Int!

    /// The ID of the digital comic representation of this comic. Will be 0 if the comic is not available digitally.
    var digitalId: Int!

    /// The canonical title of the comic.
    var title: String?

    /// The canonical URL identifier for this resource.
    var resourceURI: String?

    /// The representative image for this comic.
    var thumbnail: NSDictionary?

    /// The preferred description of the comic.
    var officialDescription: String?

    var thumbnailURL: URL? {
        guard let thumbnail = thumbnail else {
            return nil
        }
        guard let path = thumbnail["path"] as? String,
            let fileExtension = thumbnail["extension"] as? String else {
            return nil
        }

        return URL(string: "\(path).\(fileExtension)")
    }

    override var description: String {
        guard let id = id, let digitalId = digitalId, let title = title, let thumbnailURL = thumbnailURL else {
            return self.debugDescription
        }
        return "<\(type(of: self)): id = \(id)\n digitalId = \(digitalId)\n title = \(title)\n thumbnailURL = \(thumbnailURL)\n"
    }

    init(id: Int, digitalId: Int = 0, title: String, resourceURI: String, thumbnail: NSDictionary, officialDescription: String) {
        self.id = id
        self.digitalId = digitalId
        self.title = title
        self.resourceURI = resourceURI
        self.thumbnail = thumbnail
        self.officialDescription = officialDescription
    }

    init(withDictionary dict: NSDictionary) {
        self.id = dict["id"] as? Int
        self.digitalId = dict["digitalId"] as? Int
        self.title = dict["title"] as? String
        self.resourceURI = dict["resourceURI"] as? String
        self.thumbnail = dict["thumbnail"] as? NSDictionary
        self.officialDescription = dict["description"] as? String
    }
}
