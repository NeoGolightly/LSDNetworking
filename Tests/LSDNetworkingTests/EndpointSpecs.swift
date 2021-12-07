//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 02.12.21.
//

import XCTest
@testable import LSDNetworking

final class EndpointSpecs: XCTestCase {
 
  
  let urlSession = URLSession.shared
  
  func testExample() async throws {
    let rootServer = RootServer(scheme: .https, host: "todos.ngrok.io")
    let lsd = LSDNetworking()
    let endpoint = Endpoint(scheme: .https, host: "todos.ngrok.io")
      .path("/todos")
    let request = Request(endpoint: endpoint)
      .GET()
      .responseType([Todo].self)
    let todos = try await lsd.tuneIn(request)
    print(todos)
    
  }
}
