//
//  File.swift
//  
//
//  Created by Neo Golightly on 08.12.21.
//

import Foundation

@resultBuilder
public struct TripBuilder<B: Codable, R: Codable> {
  typealias Body = B
  typealias ReturnType = R
  public static func buildBlock(_ components: TripComponent<B, R>...) -> TripComponent<B, R> {
    
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
  
  public static func buildExpression(_ expression: Request<B, R>) -> TripComponent<B, R> {
    TripComponent(request: expression, componentType: .request)
  }
  
  public static func buildExpression(_ expression: Endpoint) -> TripComponent<B, R> {
    TripComponent(endpoint: expression, componentType: .endpoint)
  }
  
  public static func buildExpression(_ expression: Server) -> TripComponent<B, R> {
    TripComponent(server: expression, componentType: .endpoint)
  }
}
