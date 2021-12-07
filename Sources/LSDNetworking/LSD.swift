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

public protocol EmptyBodyType: Codable{}
public struct EmptyBody: Codable, EmptyBodyType { public init() {} }
public struct EmptyReturn: Codable { public init() {} }

class LSDRequest<B: Codable, R: Codable>: LSDComponentType, LSDRequestType {
  typealias Body = B
  typealias ReturnType = R
  private var _httpMethod: HTTPMethod = .GET
  private var _returnType: R.Type
  private var _body: B?
  private var _contentType: ContentType?
  
  internal init(body: B?, returnType: R.Type, method: HTTPMethod) {
    _body = body
    _returnType = returnType
    _httpMethod = method
  }
  
  public init(_ request: LSDRequest) {
    _body = request._body
    _returnType = request._returnType
    _httpMethod = request._httpMethod
  }
  
  func applicationJSON() -> Self {
    _contentType = .json
    return self
  }
  
  func build() -> URLRequest {
    URLRequest(url: URL(string: "")!)
  }
}

extension LSDRequest {
  static func POST(body: B?, returnType: R.Type) -> LSDRequest {
    LSDRequest(body: body, returnType: returnType, method: .POST)
  }
  
  static func GET(body: B?, returnType: R.Type) -> LSDRequest {
    LSDRequest(body: body, returnType: returnType, method: .POST)
  }
}

protocol LSDRequestType {
  associatedtype ReturnType: Codable
  associatedtype Body: Codable
  func build() -> URLRequest
}


protocol LSDComponentType {}
@resultBuilder
struct ComponentBuilder {
  static func buildBlock(_ components: LSDComponentType...) -> [LSDComponentType] {
    components
  }
}


@resultBuilder
class TripBuilder<B: Codable, R: Codable> {
  typealias Body = B
  typealias ReturnType = R
  static func buildBlock(_ components: TripComponent<B, R>...) -> TripComponent<B, R> {
    guard let server = components.filter({ $0._componentType == .server }).last,
          let endpoint = components.filter({ $0._componentType == .endpoint }).last,
          let request = components.filter({ $0._componentType == .request }).last
    else { fatalError("could not build request")}
    return TripComponent(endpoint: endpoint._endpoint, request: request._request, server: server._server, componentType: .finalBuild)
  }
  
  static func buildExpression(_ expression: LSDRequest<B, R>) -> TripComponent<B, R> {
    TripComponent(request: expression, componentType: .request)
  }
  
  static func buildExpression(_ expression: Endpoint) -> TripComponent<B, R> {
    TripComponent(endpoint: expression, componentType: .endpoint)
  }
  
  static func buildExpression(_ expression: Server) -> TripComponent<B, R> {
    TripComponent(server: expression, componentType: .endpoint)
  }
  

  
}

enum TripComponentType {
  case endpoint, request, server, finalBuild
}

struct Server {
  let scheme: HTTPScheme
  let host: String?
  let port: Int?
  
  public init(scheme: HTTPScheme = .https, host: String? = nil, port: Int? = nil) {
    self.scheme = scheme
    self.host = host
    self.port = port
  }
}

struct TripComponent<B: Codable, R: Codable> {
  typealias Body = B
  typealias ReturnType = R
  var _endpoint: Endpoint?
  var _request: LSDRequest<B, R>?
  var _server: Server?
  var _componentType: TripComponentType
  
  init(endpoint: Endpoint? = nil,
       request: LSDRequest<B, R>? = nil,
       server: Server? = nil,
       componentType: TripComponentType) {
    _endpoint = endpoint
    _request = request
    _server = server
    _componentType = componentType
  }
}

extension RandomAccessCollection {
//  func join<B: Codable, R: Codable>() -> Element where Element == TripComponent<B,R>, B: Codable, R: Codable {
//    let request = LSDRequest<EmptyBody, EmptyReturn>(body: EmptyBody(), returnType: EmptyReturn.self)
//    return TripComponent<LSDRequest.Body, LSDRequest.ReturnType>(request: request, componentType: .request)
//  }
}


class LSDTrip<B: Codable, R: Codable, T: LSDRequest<B, R>> {

  private weak var _lsd: LSD?
  private var _request: LSDRequest<B, R>
  init(lsd: LSD, request: LSDRequest<B, R>) {
    _lsd = lsd
    _request = request
  }
  
  func tuneIn() async throws -> R {
    guard let lsd = _lsd else { fatalError("no lsd :/") }

    let sessionRequest = _request.build()
    
    let (responseData, response) = try await lsd.urlSession.data(for: sessionRequest)
    guard let httpResponse = response as? HTTPURLResponse,
          200..<300 ~= httpResponse.statusCode
    else { throw LSDNetworkingError.serverError(errorCode: (response as! HTTPURLResponse).statusCode) }
    
    return try JSONDecoder().decode(T.ReturnType.self, from: responseData)
  }
}

class LSD {

  internal var urlSession: URLSession
  private let rootServer: RootServer?
  
  init(rootServer: RootServer? = nil, urlSession: URLSession = .shared) {
    self.rootServer = rootServer
    self.urlSession = urlSession
  }
  
  func turnOn<B: Codable, R: Codable, T: LSDRequest<B, R>>(@TripBuilder<B, R> _ component: () -> (TripComponent<B,R>)) -> LSDTrip<B, R, T> {
    LSDTrip(lsd: self, request: component()._request!)
  }
}

extension Endpoint: LSDComponentType {}



class FakeAPI {
  
  private let lsd = LSD(rootServer: .fakeApiRoot)
  
  func getTodos() -> [Todo] {
    
    return []
  }
  
  func createTodo(todo: Todo) async throws -> Todo {
    try await lsd.turnOn {
      Server(scheme: .https, host: "todos.ngrok.io")
      Endpoint(.todos)
      LSDRequest(.POST(body: todo, returnType: Todo.self))
    }.tuneIn()
  }
  

  
  func getTodo(id: String) async throws -> Todo {
    try await lsd.turnOn {
      Endpoint(.bucketItem).addParameter(id)
      LSDRequest(.GET(body: EmptyBody(), returnType: Todo.self))
        .applicationJSON()
    }.tuneIn()
    
  }
  
  func likeTodo(id: String) async throws -> Todo {
    try await lsd.turnOn {
      //www.meinServer.de/bucket_item/12412412412412/favorites
      Endpoint(.bucketItem)
        .addParameter(id)
        .addParameter("favorites")
      LSDRequest(.GET(body: EmptyBody(), returnType: Todo.self))
        .applicationJSON()
    }.tuneIn()
    
  }
  
  func deleteTodo(id: String) -> HTTPStatus {
    .noContent
  }
}
