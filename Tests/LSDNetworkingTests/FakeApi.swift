//
//  File.swift
//  
//
//  Created by Neo Golightly on 07.12.21.
//

import Foundation
@testable import LSDNetworking
import Combine

struct Todo: Codable {
  let id: UUID?
  let title: String
}

//extension Endpoint: LSDComponentType {}

extension Server {
  static let fakeApiRoot = Server(scheme: .https, host: "todos.ngrok.io")
}

extension Endpoint {
  static let todos: Endpoint = Endpoint(basePath: "/todos")
}

class FakeAPI {
  
  public var progress: AnyPublisher<LSDProgressType, Never>
  
  private let lsd = LSD(server: .fakeApiRoot)
  
  public init() {
    progress = lsd.progress
  }
  
  func getTodos() async throws -> [Todo] {
    
    try await lsd.turnOn {
      Endpoint(.todos)
      Request(.GET(returnType: [Todo].self))
    }.tuneIn()
  }
  
  func createTodo(todo: Todo) async throws -> Todo {
    try await lsd.turnOn {
      Server(scheme: .https, host: "todos.ngrok.io")
      Endpoint(.todos)
      Request(.POST(body: todo, returnType: Todo.self))
    }.tuneIn()
  }
  

  
  func getTodo(id: String) async throws -> Todo {
    try await lsd.turnOn {
      Endpoint(.todos).addParameter(id)
      Request(.GET(returnType: Todo.self))
        .applicationJSON()
    }.tuneIn()
    
  }
  
  func likeTodo(id: String) async throws -> Todo {
    try await lsd.turnOn {
      Endpoint(.todos)
        .addParameter(id)
        .addParameter("favorites")
      Request(.GET(returnType: Todo.self))
        .applicationJSON()
    }.tuneIn()
    
  }
  
  func deleteTodo(id: String) async throws -> HTTPStatus {
    try await lsd.turnOn {
      Endpoint(.todos)
        .addParameter(id)
      Request(.DELETE(returnType: HTTPStatus.self))
        .applicationJSON()
    }.tuneIn()
  }
}
