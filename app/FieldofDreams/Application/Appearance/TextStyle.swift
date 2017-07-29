//
//  TextStyle.swift
//  FieldofDreams
//
//  Created by Jay Clark on 11/1/16.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import Foundation
import BonMot

enum TextStyle: String {
    case navigationTitle = "NavigationTitle"
}

extension TextStyle {
    var stringStyle: StringStyle {
        switch self {
        case .navigationTitle:
            return StringStyle(.font(.systemFont(ofSize: 20)))
        }
    }
}
