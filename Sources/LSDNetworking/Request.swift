//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 02.12.21.
//

import Foundation

protocol RequestType {
  associatedtype ReturnType: Codable
  associatedtype Body: Codable
  func build() -> URLRequest
}


public class Request<B: Codable, R: Codable>: RequestType {
  typealias Body = B
  typealias ReturnType = R
  // Base
  internal var _httpMethod: HTTPMethod = .GET
  internal var _returnType: R.Type
  internal var _body: B?
  // Options
  internal var _contentType: ContentType? = .json
  
  internal init(body: B?, returnType: R.Type, method: HTTPMethod) {
    _body = body
    _returnType = returnType
    _httpMethod = method
  }
  
  internal init(returnType: R.Type, method: HTTPMethod) {
    _body = nil
    _returnType = returnType
    _httpMethod = method
  }
  
  public init(_ request: Request) {
    _body = request._body
    _returnType = request._returnType
    _httpMethod = request._httpMethod
  }
  
  func applicationJSON() -> Self {
    _contentType = .json
    return self
  }
  
  func build() -> URLRequest {
    URLRequest(url: URL(string: "")!)
  }
}

extension Request {
  public static func POST(body: B?, returnType: R.Type) -> Request {
    Request(body: body, returnType: returnType, method: .POST)
  }
  
  public static func GET(returnType: R.Type) -> Request<EmptyBody, R> {
    Request<EmptyBody, R>(body: EmptyBody(),returnType: returnType, method: .GET)
  }
  
  public static func PUT(body: B?, returnType: R.Type) -> Request {
    Request(body: body, returnType: returnType, method: .PUT)
  }
  
  public static func DELETE(returnType: R.Type) -> Request<EmptyBody, R> {
    Request<EmptyBody, R>(body: EmptyBody(),returnType: returnType, method: .DELETE)
  }
}

extension URLRequest {
  func configure<B, R>(with request: Request<B,R>) throws -> Self {
    guard let url = self.url else { throw LSDTripError.badURL }
    var urlRequest = URLRequest(url: url, cachePolicy: self.cachePolicy, timeoutInterval: self.timeoutInterval)
    
    // Set Body
    if let body = request._body {
      if request._httpMethod != .GET && request._httpMethod != .DELETE {
        print("requestMethod: \(request._httpMethod)")
        let bodyData = try JSONEncoder().encode(body)
        urlRequest.httpBody = bodyData
      }
    }
    
    if let contentType = request._contentType {
      urlRequest.addValue(contentType.rawValue, forHTTPHeaderField: .contentType)
      urlRequest.addValue(contentType.rawValue, forHTTPHeaderField: .accept)
    }
    
    urlRequest.httpMethod = request._httpMethod.rawValue
    
    return urlRequest
  }
  
}


///// RequestType
//public protocol RequestType {
//  associatedtype Response: Codable
//  associatedtype Body: Codable
//  var endpoint: Endpoint { get }
//  func request() throws -> URLRequest
//}
//
//
///// Request
//public class Request<R: Codable, B: Codable>: RequestType {
//  public typealias Response = R
//  public typealias Body = B
//
//  public var endpoint: Endpoint
//
//  private var httpMethod: HTTPMethod = .GET
//  private var _responseType: R.Type?
//  private var _body: B?
//  private var _contentType: ContentType?
//
//
//  init(endpoint: Endpoint) {
//    self.endpoint = endpoint
//  }
//
//  public func request() throws -> URLRequest {
//    let url = try endpoint.url()
//    return URLRequest(url: url)
//  }
//
//  func applicationJSON() -> Self {
//    _contentType = .json
//    return self
//  }
//
//  func body(_ body: B?) -> Self {
//    _body = body
//    return self
//  }
//
//  func responseType(_ responseType: R.Type) -> Self {
//    _responseType = responseType
//    return self
//  }
//
//  func responseType() throws -> R.Type {
//    guard let type = _responseType else { throw RequestError.badResponseType }
//    return type
//  }
//}
//
//
//
//
//extension Request {
//  public func GET() -> Self {
//    httpMethod = .GET
//    return self
//  }
//
//  public func POST(body: B) -> Self {
//    httpMethod = .POST
//    return self.body(body)
//  }
//
//  public func DELETE() -> Self {
//    httpMethod = .DELETE
//    return self
//  }
//
//  public func PATCH() -> Self {
//    httpMethod = .PATCH
//    return self
//  }
//
//  public func PUT() -> Self {
//    httpMethod = .PUT
//    return self
//  }
//}
