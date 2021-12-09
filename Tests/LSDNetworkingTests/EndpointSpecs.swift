//
//  File.swift
//  
//X
//  Created by Neo Golightly on 02.12.21.
//

import XCTest
@testable import LSDNetworking
import Combine

final class EndpointSpecs: XCTestCase {
  let lsd = LSD(server: Server(scheme: .https, host: "todos.ngrok.io"))
  private var subscriptions = Set<AnyCancellable>()
  
  func testExample() async throws {
    let id = UUID().uuidString
    lsd.progress.map{ $0[id] }.sink { progress in
      print(progress?.progress ?? 0)
    }.store(in: &subscriptions)
    
    let newTodo = Todo(id: nil, title: "Niki…es geht :D")
    let newTodoReturn = try await lsd.turnOn {
      Endpoint(basePath: "/todos")
      Request(.POST(body: newTodo, returnType: Todo.self))
    }.tuneIn(progressID: id)
    
    XCTAssertEqual(newTodo.title, newTodoReturn.title)
    
    let todos = try await lsd.turnOn {
      Endpoint(basePath: "/todos")
      Request(.GET(returnType: [Todo].self))
    }.tuneIn(progressID: id)
    
    print(todos)
    
    for todo in todos {
      guard let id = todo.id?.uuidString else { continue }
      let status = try await lsd.turnOn {
        Endpoint(basePath: "/todos")
          .addParameter("/"+id)
        Request(.DELETE(returnType: HTTPStatus.self))
      }.tuneIn()
     print(status)
    }
  }
}


