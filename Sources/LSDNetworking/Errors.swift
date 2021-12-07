//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 04.12.21.
//

import Foundation

/// LSDNetworking Error
enum LSDNetworkingError: Error {
  case serverError(errorCode: Int)
}

/// Endpoint Error
enum EndpointError: Error {
  case badURL
}

/// Request Error
enum RequestError: Error {
  case badResponseType
}
