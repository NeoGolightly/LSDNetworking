//
//  File.swift
//  
//
//  Created by Neo Golightly on 02.12.21.
//

import Foundation



/// A class that constructs a http endpoint
///
/// Create your Endpoint with a base path. It's possible to create an Endpoint with
/// a server configuration for this special Endpoint.
/// If you want to set a global server for all Endpoints set it with ``LSD/init(server:urlSession:)``.
public class Endpoint {
  private var _urlComponents = URLComponents()
  
  // MARK: - Initializers
  /// Creates an empty Endpoint
  public init(){}
  
  /// Creates an Endpoint with a base path.
  /// - Parameter basePath: A string describing your endpoints base path.
  public init(basePath: String){
    self._urlComponents.path = basePath
      .addingPrefix("/")
      .deletingSuffix("/")
  }
  
  /// Creates an Endpoint with a server configuration.
  /// - Parameter server: A server object describing your scheme, host and port
  public init(server: Server) {
    _urlComponents.scheme = server.scheme.rawValue
    _urlComponents.host = server.host
    _urlComponents.port = server.port
  }
  
  /// Creates an Endpoint with another Endpoint.
  /// - Parameter endpoint: An Endpoint object
  public convenience init(_ endpoint: Endpoint) {
    self.init(urlComponents: endpoint._urlComponents)
  }
  
  /// Creates an Endpoint with a base path using string components.
  /// - Parameter basePathComponents: String components describing your endpoints base path
  ///
  /// Use it in a Vapor route style
  /// ```swift
  /// Endpoint(basePathComponents: "api", "todos")
  /// ```
  ///  All '/' will be added or removed for you to create a save url
  public convenience init(basePathComponents: String...){
    let path = basePathComponents
      .map{ $0.addingPrefix("/").deletingSuffix("/") }
      .joined(separator: "/")
    self.init(basePath: path)
  }
  
  
  /// Creates an Endpoint with another Endpoint and appends another path
  /// - Parameters:
  ///   - endpoint: An Endpoint object
  ///   - appendPath: A string describing a path that is added to the endpoint
  public convenience init(_ endpoint: Endpoint, appendPath: String) {
    var urlComponents = endpoint.components()
    urlComponents.path = urlComponents.path.deletingSuffix("/") + appendPath.addingPrefix("/")
    self.init(urlComponents: urlComponents)
  }
  
  /// Creates an Endpoint from URLComponents
  /// - Parameter urlComponents: A structure that parses URLs into and constructs URLs from their constituent parts.
  internal init(urlComponents: URLComponents) {
    self._urlComponents = urlComponents
  }
  
  // MARK: - Path and Parameters
  
  public func addPath(_ appendPath: String) -> Self {
    _urlComponents.path = _urlComponents.path.deletingSuffix("/") + appendPath.addingPrefix("/")
    return self
  }
  
  public func addParameter(_ parameter: String) -> Self {
    _urlComponents.path.append(contentsOf: parameter.addingPrefix("/"))
    return self
  }
  
  public func addParameter(_ parameter: UUID) -> Self {
    return addParameter(parameter.uuidString)
  }
  

  // MARK: - Query Items
  public func queryItem(name: String, value: String?) -> Self {
    _urlComponents.queryItems?.append(URLQueryItem(name: name, value: value))
    return self
  }
  
  public func queryItems(_ items: [String : String?]) -> Self {
    let queryItems = items
      .map{ URLQueryItem(name: $0.key, value: $0.value) }
    _urlComponents.queryItems?.append(contentsOf: queryItems)
    return self
  }
  
  
  // MARK: - Output
  public func components() -> URLComponents {
    return _urlComponents
  }
  
  public func url() throws -> URL {
    guard let url = _urlComponents.url else { throw EndpointError.badURL }
    return url
  }
}
