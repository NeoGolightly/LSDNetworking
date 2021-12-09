//
//  File.swift
//  
//
//  Created by Neo Golightly on 04.12.21.
//

import Foundation

/// LSDNetworking Error
enum LSDNetworkingError: Error {
  case serverError(errorCode: Int)
}

extension LSDNetworkingError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case let .serverError(errorCode):
      return HTTPStatus(statusCode: errorCode).reasonPhrase
    }
  }
}

/// Endpoint Error
enum EndpointError: Error {
  case badURL
}

extension EndpointError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .badURL:
      return NSLocalizedString("Could not create url from URLComponents for endpoint",
                               comment: "EndpointError badURL")
    }
  }
}

enum LSDTripError: Error {
  case noLSD
  case badRequest
  case noEndpointComponents
  case noRequestComponents
  case badURL
  case jsonDecoding
  case httpStatus
}

extension LSDTripError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .badRequest:
      return NSLocalizedString("Could not create Request",
                               comment: "LSDTripError badURL")
    case .badURL:
      return NSLocalizedString("Could not create url",
                               comment: "LSDTripError badURL")
    case .noLSD:
      return NSLocalizedString("Could not find LSD object",
                               comment: "LSDTripError jsonDecoding")
    case .noEndpointComponents:
      return NSLocalizedString("Could not find Endpoint object",
                               comment: "LSDTripError jsonDecoding")
    case .noRequestComponents:
      return NSLocalizedString("Could not find Request object",
                               comment: "LSDTripError jsonDecoding")
    case .jsonDecoding:
      return NSLocalizedString("Could not decode JSON",
                               comment: "LSDTripError jsonDecoding")
    case .httpStatus:
      return NSLocalizedString("Could not create HTTPStatus",
                               comment: "LSDTripError jsonDecoding")
    }
  }
}

/// Request Error
enum RequestError: Error {
  case badResponseType
}
