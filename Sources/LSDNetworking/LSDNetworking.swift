import Foundation




public struct RootServer {
  let scheme: HTTPScheme
  let host: String?
  let port: Int?
  
  public init(scheme: HTTPScheme = .https, host: String? = nil, port: Int? = nil) {
    self.scheme = scheme
    self.host = host
    self.port = port
  }
}

@resultBuilder
public struct EndpointBuilder {
  public static func buildBlock(_ components: Endpoint...) -> [Endpoint] {
    components
  }
}

public class LSDNetworking {
  private var urlSession: URLSession
  private let rootServer: RootServer?
//  private var endpointPool: EndpointPool = EndpointPool(endpointIDs: [:])
  
  init(rootServer: RootServer? = nil, urlSession: URLSession = .shared) {
    self.rootServer = rootServer
    self.urlSession = urlSession
  }
  
  func turnOn(@EndpointBuilder builder: () -> [Endpoint]) -> Self {
//    for endpoint in builder() {
//      guard let endpointID = endpoint.endpointID else { continue }
//      endpointPool.endpointIDs[endpointID] = endpoint
//    }
    return self
  }
  
  @discardableResult
  func changeURLSession(_ urlSession: URLSession) -> Self {
    self.urlSession = urlSession
    return self
  }
  
  public func tuneIn<R: RequestType>(_ request: R, returnType: ReturnType = .JSON) async throws -> R.Response {

    let request = try request.request()
    let (responseData, response) = try await urlSession.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse,
          200..<300 ~= httpResponse.statusCode
    else { throw LSDNetworkingError.serverError(errorCode: (response as! HTTPURLResponse).statusCode) }
    
    return try JSONDecoder().decode(R.Response.self, from: responseData)
  }
}





///"Turn on" meant go within to activate your neural and genetic equipment. Become sensitive to the many and various levels of consciousness and the specific triggers engaging them. Drugs were one way to accomplish this end. "Tune in" meant interact harmoniously with the world around you—externalize, materialize, express your new internal perspectives. "Drop out" suggested an active, selective, graceful process of detachment from involuntary or unconscious commitments. "Drop Out" meant self-reliance, a discovery of one's singularity, a commitment to mobility, choice, and change. Unhappily, my explanations of this sequence of personal development are often misinterpreted to mean "Get stoned and abandon all constructive activity".

@resultBuilder
struct EndpointCollectionBuilder {
  static func buildBlock(_ components: EndpointConfig...) -> [EndpointConfig] {
    components
  }
}


struct EndpointCollection {
  let endpointConfigs: [EndpointID : EndpointConfig]
  init(@EndpointCollectionBuilder builder: () -> [EndpointConfig]) {
    var dic: [EndpointID : EndpointConfig] = [:]
    for item in builder() {
      dic[item.endpointID] = item
    }
    endpointConfigs = dic
  }
  
  subscript(id: EndpointID) -> EndpointConfig? {
    endpointConfigs[id]
  }
}


//typealias EndpointID = String


struct EndpointPool {
//  var endpointIDs: [EndpointID : Endpoint]
}

struct EndpointConfig {
  let rootPath: String
  let endpointID: EndpointID
}

enum EndpointID: Hashable {
  case id(String)
}

struct FakeApiEndpointCollection {
  static let todos: EndpointID = .id("tods")
}

extension Endpoint {
  static let todos: Endpoint = Endpoint(basePath: "todos")
  static let bucketItem: Endpoint = Endpoint(basePath: "bucket_items")
}

extension RootServer {
  static let fakeApiRoot = RootServer(scheme: .https, host: "todos.ngrok.io")
}




enum HTTPStatus {
  case OK
  case created
  case noContent
}

struct Todo: Codable {
  let id: UUID?
  let title: String
}
