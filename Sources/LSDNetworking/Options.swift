//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 04.12.21.
//

import Foundation

public enum ReturnType{
  case JSON, HTML
}

public enum HTTPScheme: String {
  case http, https
}

public enum HTTPMethod: String {
  case GET, POST, PUT, PATCH, DELETE
}
