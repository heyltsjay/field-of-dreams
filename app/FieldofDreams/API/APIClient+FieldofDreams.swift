//
//  APIClient+FieldofDreams.swift
//  FieldofDreams
//
//  Created by Jay Clark on 7/24/17.
//
//

import Foundation

extension APIClient {

    static var shared = APIClient(baseURL: {
        let baseURL: URL
        switch APIEnvironment.active {
        case .develop:
            baseURL = URL(string: "https://FieldofDreams-dev.raizlabs.xyz")!
        case .sprint:
            baseURL = URL(string: "https://FieldofDreams-sprint.raizlabs.xyz")!
        case .production:
            fatalError("Specify the release server")
        }
        return baseURL
    }())

}
