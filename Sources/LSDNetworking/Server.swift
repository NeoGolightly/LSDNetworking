//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 07.12.21.
//

import Foundation


public struct Server {
  let scheme: HTTPScheme
  let host: String?
  let port: Int?
  
  public init(scheme: HTTPScheme = .https, host: String? = nil, port: Int? = nil) {
    self.scheme = scheme
    self.host = host
    self.port = port
  }
}
