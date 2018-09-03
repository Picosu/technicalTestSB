//
//  Constants.swift
//  TechStreetbees
//
//  Created by Maxence de Cussac on 23/08/2018.
//  Copyright © 2018 Maxence de Cussac. All rights reserved.
//

import Foundation

// MARK: - Environment
enum Environment: String {
    case dev = "dev"
    case prod = "prod"

    var marvelServerURL: String {
        switch self {
        case .dev: return "https://gateway.marvel.com/"
        case .prod: return "https://gateway.marvel.com/"
        }
    }

    var marverComicsURL: String {
        switch self {
        case .dev: return self.marvelServerURL + "v1/public/comics"
        case .prod : return self.marvelServerURL + "v1/public/comics"
        }
    }

    var marvelPrivateKey: String {
        switch self {
        case .dev: return "35c9494bda47939ca0d4c0ce2c3995e6d8d35bae"
        case .prod: return "35c9494bda47939ca0d4c0ce2c3995e6d8d35bae"
        }
    }

    var marvelPublicKey: String {
        switch self {
        case .dev: return "6de7b74fed3c6482bb62ccaf96963a21"
        case .prod: return "6de7b74fed3c6482bb62ccaf96963a21"
        }
    }

}

// MARK: - Configuration
struct Configuration {
    lazy var environment: Environment = {
        #if DEBUG
        return Environment.dev
        #else
        return Environment.prod
        #endif
    }()

}
