//
//  APIEndpoint.swift
//  FieldofDreams
//
//  Created by Jay Clark on 11/1/16.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import Alamofire
import Marshal

protocol APIEndpoint: NetworkLoggable {
    associatedtype ResponseType

    var path: String { get }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    var parameters: JSONObject? { get }
    var headers: HTTPHeaders { get }
}
