//
//  BaseViewModel.swift
//  FitAlly
//
//  Created by 차지용 on 3/25/26.
//

import Foundation

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
