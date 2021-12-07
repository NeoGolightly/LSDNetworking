//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 06.12.21.
//

import Foundation
import Logging
import Combine

var logger: Logger {
  var logger = Logger(label: "LSD Networking")
  logger.logLevel = .debug
  return logger
}

public struct LSDProgress{
  let expectedLength: Int
  let bytesCount: Int
  let progress: Double
}

public protocol EmptyType: Codable {}
public struct EmptyBody: EmptyType { public init() {} }


public class LSDTrip<B: Codable, R: Codable, T: Request<B, R>> {
  

  
  private weak var _lsd: LSD?
  private let _tripComponent: TripComponent<B, R>

  init(lsd: LSD, tripComponent: TripComponent<B, R>) {
    _lsd = lsd
    _tripComponent = tripComponent
  }
  
  private func buildURLRequest() throws -> URLRequest {
    guard var components = _tripComponent._endpoint?.components()
    else { throw LSDTripError.noEndpointComponents }
    
    // If Server is configured in LSD class
    if let server = _lsd?._server {
      components.host = server.host
      components.scheme = server.scheme.rawValue
      components.port = server.port
    }
    
    // If Server is added in TripBuilder
    if let server = _tripComponent._server {
      components.host = server.host
      components.scheme = server.scheme.rawValue
      components.port = server.port
    }
    
    guard let url = components.url else { throw LSDTripError.badURL }
    guard let request = _tripComponent._request else { throw LSDTripError.noRequestComponents }
    
    let urlRequest = URLRequest(url: url)
    
    return try urlRequest.configure(with: request)
  }
  
  public func tuneIn(progressID: String = UUID().uuidString) async throws -> R {
    guard let lsd = _lsd else { throw LSDTripError.noLSD }
    
    var sessionRequest: URLRequest
    do {
     sessionRequest = try buildURLRequest()
    } catch {
      throw LSDTripError.badRequest
    }
    let (asyncBytes, response) = try await lsd._urlSession.bytes(for: sessionRequest)
    
    let length = Int(response.expectedContentLength)
    var responseData = Data()
    responseData.reserveCapacity(length)
    for try await byte in asyncBytes {
      responseData.append(byte)
      let progress = Double(responseData.count) / Double(length)
      lsd._progress.send([progressID : LSDProgress(expectedLength: length,
                                                   bytesCount: responseData.count,
                                                   progress: progress)])
//      logger.debug("\(String(describing: sessionRequest.httpMethod ?? ""))", metadata: ["percent" : "\(progress)"])
    }
    
    
    guard let httpResponse = response as? HTTPURLResponse,
          200..<300 ~= httpResponse.statusCode
    else { throw LSDNetworkingError.serverError(errorCode: (response as! HTTPURLResponse).statusCode) }
    
    return try JSONDecoder().decode(T.ReturnType.self, from: responseData)
  }
}

public class LSD {
  
  public var progress: AnyPublisher<[String: LSDProgress], Never> {
    _progress.eraseToAnyPublisher()
  }
  
  internal let _progress = PassthroughSubject<[String: LSDProgress], Never>()
  
  internal var _urlSession: URLSession
  internal let _server: Server?
  
  public init(server: Server? = nil, urlSession: URLSession = .shared) {
    _server = server
    _urlSession = urlSession
  }
  
  public func turnOn<B: Codable, R: Codable, T: Request<B, R>>(@TripBuilder<B, R> _ component: () -> (TripComponent<B,R>)) -> LSDTrip<B, R, T> {
    LSDTrip(lsd: self, tripComponent: component())
  }
  
  ///"Turn on" meant go within to activate your neural and genetic equipment. Become sensitive to the many and various levels of consciousness and the specific triggers engaging them. Drugs were one way to accomplish this end. "Tune in" meant interact harmoniously with the world around you—externalize, materialize, express your new internal perspectives. "Drop out" suggested an active, selective, graceful process of detachment from involuntary or unconscious commitments. "Drop Out" meant self-reliance, a discovery of one's singularity, a commitment to mobility, choice, and change. Unhappily, my explanations of this sequence of personal development are often misinterpreted to mean "Get stoned and abandon all constructive activity".
}

//extension Endpoint: LSDComponentType {}

extension Server {
  static let fakeApiRoot = Server(scheme: .https, host: "todos.ngrok.io")
}

extension Endpoint {
  static let todos: Endpoint = Endpoint(basePath: "todos")
  static let bucketItem: Endpoint = Endpoint(basePath: "bucket_items")
}


enum HTTPStatus: Codable {
  case OK
  case created
  case noContent
}

struct Todo: Codable {
  let id: UUID?
  let title: String
}

class FakeAPI {
  
  private let lsd = LSD(server: .fakeApiRoot)
  
  func getTodos() -> [Todo] {
    
    return []
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
      Endpoint(.bucketItem).addParameter(id)
      Request(.GET(returnType: Todo.self))
        .applicationJSON()
    }.tuneIn()
    
  }
  
  func likeTodo(id: String) async throws -> Todo {
    try await lsd.turnOn {
      Endpoint(.bucketItem)
        .addParameter(id)
        .addParameter("favorites")
      Request(.GET(returnType: Todo.self))
        .applicationJSON()
    }.tuneIn()
    
  }
  
  func deleteTodo(id: String) async throws -> HTTPStatus {
    try await lsd.turnOn {
      Endpoint(.bucketItem)
        .addParameter(id)
        .addParameter("favorites")
      Request(.DELETE(returnType: HTTPStatus.self))
        .applicationJSON()
    }.tuneIn()
  }
}
