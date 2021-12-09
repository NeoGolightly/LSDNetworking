//
//  File.swift
//  
//
//  Created by Neo Golightly on 06.12.21.
//

import Foundation
import Logging
import Combine

public class LSD {
  
  public var progress: AnyPublisher<LSDProgressType, Never> {
    _progress.eraseToAnyPublisher()
  }
  
  internal let _progress = PassthroughSubject<LSDProgressType, Never>()
  
  internal var _urlSession: URLSession
  internal let _server: Server?
  
  public init(server: Server? = nil, urlSession: URLSession = .shared) {
    _server = server
    _urlSession = urlSession
  }
  
  /// Create your Endpoint and Request here with the TripBuilder
  ///
  ///
  ///```swift
  /// let server = Server(scheme: .https,
  ///                     host: "yourRootServer.com")
  /// let lsd = LSD(server: server)
  /// let todos = try await lsd.turnOn {
  ///   Endpoint(basePath: "/todos")
  ///   Request(.GET(returnType: [Todo].self))
  /// }.tuneIn()
  ///```
  /// "Turn on" meant go within to activate your neural and genetic equipment. Become sensitive to the many and various levels of consciousness and the specific triggers engaging them. Drugs were one way to accomplish this end.
  public func turnOn<B: Codable, R: Codable, T: Request<B, R>>(@TripBuilder<B, R> _ component: () -> (TripComponent<B,R>)) -> LSDTrip<B, R, T> {
    LSDTrip(lsd: self, tripComponent: component())
  }
}




extension LSD {
  public static var logLevel: Logger.Level = .debug
  static var logger: Logger {
    var logger = Logger(label: "LSD Networking")
    logger.logLevel = LSD.logLevel
    
    return logger
  }
}

//extension Endpoint: LSDComponentType {}

extension Server {
  static let fakeApiRoot = Server(scheme: .https, host: "todos.ngrok.io")
}

extension Endpoint {
  static let todos: Endpoint = Endpoint(basePath: "/todos")
  static let bucketItem: Endpoint = Endpoint(basePath: "/bucket_items")
}





