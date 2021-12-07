//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 07.12.21.
//

import Foundation

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

@resultBuilder
public class TripBuilder<B: Codable, R: Codable> {
  typealias Body = B
  typealias ReturnType = R
  static func buildBlock(_ components: TripComponent<B, R>...) -> TripComponent<B, R> {
    
    guard let request = components.filter({ $0._componentType == .request }).last
    else { fatalError("could not build request")}

    var endpoint: Endpoint?, server: Server?
    if let serverTrip = components.filter({ $0._componentType == .server }).last {
      server = serverTrip._server
    }
    if let endpointTrip = components.filter({ $0._componentType == .endpoint }).last {
      endpoint = endpointTrip._endpoint
    }
    
    return TripComponent(endpoint: endpoint, request: request._request, server: server, componentType: .finalBuild)
  }
  
  static func buildExpression(_ expression: Request<B, R>) -> TripComponent<B, R> {
    TripComponent(request: expression, componentType: .request)
  }
  
  static func buildExpression(_ expression: Endpoint) -> TripComponent<B, R> {
    TripComponent(endpoint: expression, componentType: .endpoint)
  }
  
  static func buildExpression(_ expression: Server) -> TripComponent<B, R> {
    TripComponent(server: expression, componentType: .endpoint)
  }
}

enum TripComponentType {
  case endpoint, request, server, finalBuild
}
