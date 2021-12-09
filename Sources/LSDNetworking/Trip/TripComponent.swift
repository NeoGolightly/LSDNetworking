//
//  File.swift
//  
//
//  Created by Neo Golightly on 08.12.21.
//

import Foundation

enum TripComponentType {
  case endpoint, request, server, finalBuild
}


public struct TripComponent<B: Codable, R: Codable> {
  typealias Body = B
  typealias ReturnType = R
  internal var _endpoint: Endpoint?
  internal var _request: Request<B, R>?
  internal var _server: Server?
  internal var _componentType: TripComponentType
  
  internal init(endpoint: Endpoint? = nil,
       request: Request<B, R>? = nil,
       server: Server? = nil,
       componentType: TripComponentType) {
    _endpoint = endpoint
    _request = request
    _server = server
    _componentType = componentType
  }
}
