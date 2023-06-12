//
//  NetworkError.swift
//  Weather
//
//  Created by Srinivasa Tottempudi on 6/10/23.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case noData
    case request(underlyingError: Error)
    case finalError(underlyingError: [String: String])
    case unableToDecode(underlyingError: Error)
}
