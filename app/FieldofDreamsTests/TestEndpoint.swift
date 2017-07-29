//
//  RandomEndpoint.swift
//  FieldofDreams
//
//  Created by Jay Clark on 11/3/16.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import Alamofire
import Marshal
@testable import FieldofDreams

struct TestEndpoint: APIEndpoint {
    typealias ResponseType = [TestEndpointResult]
    var path: String { return "test" }
    var method: HTTPMethod { return .get }
    var encoding: ParameterEncoding { return URLEncoding.default }
    var parameters: JSONObject? { return [:] }
    var headers: HTTPHeaders { return [:] }

}

struct TestEndpointResult: Unmarshaling {

    let value: String

    init(object: MarshaledObject) throws {
        value = try object.value(for: "value")
    }
}
