//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 02.12.21.
//

import Foundation


public protocol EmptyBodyType: Codable{}
public struct EmptyBody: Codable, EmptyBodyType { public init() {} }

/// RequestType
public protocol RequestType {
  associatedtype Response: Codable
  associatedtype Body: Codable
  var endpoint: Endpoint { get }
  func request() throws -> URLRequest
}


/// Request
public class Request<R: Codable, B: Codable>: RequestType {
  public typealias Response = R
  public typealias Body = B
  
  public var endpoint: Endpoint
  
  private var httpMethod: HTTPMethod = .GET
  private var _responseType: R.Type?
  private var _body: B?
  private var _contentType: ContentType?
  
  
  init(endpoint: Endpoint) {
    self.endpoint = endpoint
  }
  
  public func request() throws -> URLRequest {
    let url = try endpoint.url()
    return URLRequest(url: url)
  }
  
  func applicationJSON() -> Self {
    _contentType = .json
    return self
  }
  
  func body(_ body: B?) -> Self {
    _body = body
    return self
  }
  
  func responseType(_ responseType: R.Type) -> Self {
    _responseType = responseType
    return self
  }
  
  func responseType() throws -> R.Type {
    guard let type = _responseType else { throw RequestError.badResponseType }
    return type
  }
}




extension Request {
  public func GET() -> Self {
    httpMethod = .GET
    return self
  }
    
  public func POST(body: B) -> Self {
    httpMethod = .POST
    return self.body(body)
  }
  
  public func DELETE() -> Self {
    httpMethod = .DELETE
    return self
  }
  
  public func PATCH() -> Self {
    httpMethod = .PATCH
    return self
  }
  
  public func PUT() -> Self {
    httpMethod = .PUT
    return self
  }
}
