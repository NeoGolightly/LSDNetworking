//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 06.12.21.
//

import Foundation

enum ContentType: String {
  case json = "application/json"
}

struct LSDPostRequest<R: Codable, B: Codable>: LSDRequestType, LSDComponentType {
  typealias Response = R
  typealias Body = B
  var responseType: R.Type
  internal init(body: B, response: R.Type) {
    responseType = response
  }
}

extension LSDPostRequest {
  static func POST(body: B, response: R.Type) -> LSDPostRequest {
    LSDPostRequest(body: body, response: response)
  }
}

struct LSDRequest<R: Codable, B: Codable>: LSDComponentType {

  var post: LSDPostRequest<R, B>?
  init(_ post: LSDPostRequest<R, B>) {
    self.post = post
  }
}

protocol LSDRequestType {
  associatedtype Response: Codable
  associatedtype Body: Codable
}


protocol LSDComponentType {}
@resultBuilder
struct ComponentBuilder {
  static func buildBlock(_ components: LSDComponentType...) -> [LSDComponentType] {
    components
  }
}


@resultBuilder
struct TripBuilder {
  static func buildBlock(_ components: TripComponent...) -> TripComponent {
    
  }
}

struct TripComponent {
  
}


class LSDTrip {
  
  private let _urlSession: URLSession
  private let _rootServer: RootServer?
  private let _components: [LSDComponentType]
  
  init(rootServer: RootServer? = nil,
       urlSession: URLSession, components: [LSDComponentType]) {
   _rootServer = rootServer
   _urlSession = urlSession
   _components = components
  }
  
  func tuneIn()  {

  }
}

class LSD {
  public typealias Response = Codable
  private var urlSession: URLSession
  private let rootServer: RootServer?
  
  init(rootServer: RootServer? = nil, urlSession: URLSession = .shared) {
    self.rootServer = rootServer
    self.urlSession = urlSession
  }
  
  func turnOn(@ComponentBuilder _ components: () -> ([LSDComponentType])) -> LSDTrip {
    for component in components() {
      if let request = component as? LSDPostRequest {
        request.responseType
      }
    }
    return LSDTrip(rootServer: rootServer, urlSession: urlSession, components: components())
  }
  

  
  func _tuneIn(request: LSDRequest) {

  }
}

extension Endpoint: LSDComponentType {}



class FakeAPI {
  
  private let lsd = LSD(rootServer: .fakeApiRoot)
  
  func getTodos() -> [Todo] {
    
    return []
  }
  
  func createTodo2(todo: Todo) -> Todo {
    lsd.turnOn {
      Endpoint(.todos)
      LSDPostRequest.POST(body: todo, response: Todo.self)
    }.tuneIn()
    return Todo(id: UUID(), title: "")
  }
  
  func createTodo(todo: Todo) -> Todo {

    
    return Todo(id: UUID(), title: "")
  }
  
  func getTodo(id: String) -> Todo {
//    lsd.turnOn {
////      Endpoint(.todos).addParameter(id)
//    }.tuneIn()
    
    
    return Todo(id: UUID(uuidString: id)!, title: "Hello")
  }
  
  func deleteTodo(id: String) -> HTTPStatus {
    .noContent
  }
}
