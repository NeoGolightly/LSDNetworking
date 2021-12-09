//
//  File.swift
//  
//
//  Created by Neo Golightly on 02.12.21.
//

import Foundation

protocol RequestType {
  associatedtype ReturnType: Codable
  associatedtype Body: Codable
}




/// A class for constructing a http request.
///
/// Use it with one of static the methods
/// ``Request/GET(returnType:)``,
/// ``Request/POST(body:returnType:)``,
/// ``Request/PATCH(body:returnType:)``,
/// ``Request/PUT(body:returnType:)`` or
/// ``Request/DELETE(returnType:)`` to construct a new Request.
/// ```swift
/// Request(.GET(returnType: SomeObject.type)
/// Request(.POST(body: SomeObject(), returnType: SomeObject.type)
/// Request(.PATCH(body: SomeObject(), returnType: SomeObject.type)
/// Request(.PUT(body: SomeObject(), returnType: SomeObject.type)
/// Request(.DELETE(returnType: HTTPStatus.self)
/// ```
///
public class Request<B: Codable, R: Codable>: RequestType {
  typealias Body = B
  typealias ReturnType = R
  // Base
  internal var _httpMethod: HTTPMethod = .GET
  internal var _returnType: R.Type
  internal var _body: B?
  // Options
  internal var _contentType: ContentType? = .json
  internal var _bearer: String?
  
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
  
  
  
  /// Creates a Request with another request
  /// - Parameter request: A Request from on of the static methods
  ///
  /// Use one of the Requests static methods
  /// ``Request/GET(returnType:)``,
  /// ``Request/POST(body:returnType:)``,
  /// ``Request/PATCH(body:returnType:)``,
  /// ``Request/PUT(body:returnType:)`` or
  /// ``Request/DELETE(returnType:)`` to construct a new Request
  public init(_ request: Request) {
    _body = request._body
    _returnType = request._returnType
    _httpMethod = request._httpMethod
  }
  
  
  public func applicationJSON() -> Self {
    _contentType = .json
    return self
  }
  
  public func bearer(token: String?) -> Self {
    _bearer = token
    return self
  }

}

extension Request {
  
  /// Creates a new  request
  /// - Parameter returnType: Defines the expected return type
  /// - Returns: A new Request object with an empty body
  public static func GET(returnType: R.Type) -> Request<EmptyBody, R> {
    Request<EmptyBody, R>(body: EmptyBody(),returnType: returnType, method: .GET)
  }
  
  /// Creates a new **POST** request
  /// - Parameters:
  ///   - body: A type that conforms to Codable protocol
  ///   - returnType: Defines the expected return type
  /// - Returns: A new Request object
  public static func POST(body: B?, returnType: R.Type) -> Request {
    Request(body: body, returnType: returnType, method: .POST)
  }
  
  /// Creates a new **PUT** request
  /// - Parameters:
  ///   - body: A type that conforms to Codable protocol
  ///   - returnType: Defines the expected return type
  /// - Returns: A new Request object
  public static func PUT(body: B?, returnType: R.Type) -> Request {
    Request(body: body, returnType: returnType, method: .PUT)
  }
  
  /// Creates a new **PATCH** request
  /// - Parameters:
  ///   - body: A type that conforms to Codable protocol
  ///   - returnType: Defines the expected return type
  /// - Returns: A new Request object
  public static func PATCH(body: B?, returnType: R.Type) -> Request {
    Request(body: body, returnType: returnType, method: .PUT)
  }
  
  /// Creates a new **DELETE** request
  /// - Parameter returnType: Defines the expected return type
  /// - Returns: A new Request object with an empty body
  public static func DELETE(returnType: R.Type) -> Request<EmptyBody, R> {
    Request<EmptyBody, R>(body: EmptyBody(),returnType: returnType, method: .DELETE)
  }
}




public protocol EmptyType: Codable {}
public struct EmptyBody: EmptyType { public init() {} }
