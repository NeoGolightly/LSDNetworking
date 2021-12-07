//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 04.12.21.
//

import Foundation

public enum DecoderType {
  case JSON
}

public enum HTTPScheme: String {
  case http, https
}

public enum HTTPMethod: String {
  case GET, POST, PUT, PATCH, DELETE
}

enum ContentType: String {
  case json = "application/json"
}

enum HeaderFields: String {
  case contentType = "Content-Type"
  case accept = "Accept"
}

extension String {
  static let contentType = HeaderFields.contentType.rawValue
  static let accept = HeaderFields.accept.rawValue
}
