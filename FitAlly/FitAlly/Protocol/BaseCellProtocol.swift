//
//  BaseCellProtocol.swift
//  FitAlly
//
//  Created by 차지용 on 3/25/26.
//

import Foundation

protocol BaseCellProtocol {
    static var identifier: String { get }
}

extension BaseCellProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
