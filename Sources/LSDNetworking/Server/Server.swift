//
//  File.swift
//  
//
//  Created by Neo Golightly on 07.12.21.
//

import Foundation

public struct Server {
  let scheme: HTTPScheme
  let host: String?
  let port: Int?
  
  /// Configuration object for your server
  /// - Parameters:
  ///   - scheme: Set your url scheme (http, https)
  ///   - host: Set your host (www.myDomain.com)
  ///   - port: Set your server port
  public init(scheme: HTTPScheme = .https, host: String? = nil, port: Int? = nil) {
    self.scheme = scheme
    self.host = host
    self.port = port
  }
}
