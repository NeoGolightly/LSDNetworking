//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 02.12.21.
//

import Foundation


///Endpoint
public class Endpoint{
  private var urlComponents = URLComponents()
  
  init(){}
  
  init(basePath: String){
    self.urlComponents.path = basePath
  }
  
  init(scheme: HTTPScheme = .https, host: String? = nil, port: Int? = nil) {
    urlComponents.scheme = scheme.rawValue
    urlComponents.host = host
    urlComponents.port = port
  }
  
  init(_ endpoint: Endpoint) {
    urlComponents = endpoint.components()
  }
  
  init(urlComponents: URLComponents) {
    self.urlComponents = urlComponents
  }
  
  func path(_ path: String) -> Self {
    urlComponents.path = path
    return self
  }
  
  func addParameter(_ parameter: String) -> Self{
    urlComponents.path.append(contentsOf: parameter)
    return self
  }
  
  func port(_ port: Int) -> Self {
    urlComponents.port = port
    return self
  }
  
  func queryItem(name: String, value: String?) -> Self {
    urlComponents.queryItems?.append(URLQueryItem(name: name, value: value))
    return self
  }
  
  func queryItems(_ items: [String : String?]) -> Self {
    let queryItems = items
      .map{ URLQueryItem(name: $0.key, value: $0.value) }
    urlComponents.queryItems?.append(contentsOf: queryItems)
    return self
  }
  
  func components() -> URLComponents {
    return urlComponents
  }
  
  func url() throws -> URL {
    guard let url = urlComponents.url else { throw EndpointError.badURL }
    return url
  }
}
