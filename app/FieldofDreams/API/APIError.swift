//
//  APIError.swift
//  FieldofDreams
//
//  Created by Jay Clark on 11/1/16.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

enum APIError: Error {
    case tokenExpired
    case invalidCredentials
    case invalidResponse
    case server
}
