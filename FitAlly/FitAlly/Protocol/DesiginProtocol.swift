//
//  DesiginProtocol.swift
//  FitAlly
//
//  Created by 차지용 on 3/25/26.
//

import Foundation

protocol DesiginProtocol {
    func configureHierarchy()
    func configureUI()
    func configureLayout()
}

protocol DesiginProtocolBind: DesiginProtocol {
    func bind()
}
