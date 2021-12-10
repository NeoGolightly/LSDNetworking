//
//  File.swift
//  
//
//  Created by Neo Golightly on 07.12.21.
//

import Foundation

public actor LSDTrip<B: Codable, R: Codable, T: Request<B, R>> {
  private weak var _lsd: LSD?
  private let _tripComponent: TripComponent<B, R>
  
  
  internal init(lsd: LSD, tripComponent: TripComponent<B, R>) {
    _lsd = lsd
    _tripComponent = tripComponent
  }
  
   
  /// Starts the Trip (URLSession)
  /// - Parameter progressID: Set a progress id so select this special progress with progress property on LSD
  /// - Returns: Rquests return object
  ///
  /// Timothy Leary: "Tune in" meant interact harmoniously with the world around you—externalize, materialize, express your new internal perspectives.
  @MainActor
  public func tuneIn(progressID: String = UUID().uuidString) async throws -> R {
    guard let lsd = await _lsd else { throw LSDTripError.noLSD }
    guard let sessionRequest = try? await buildURLRequest() else { throw LSDTripError.badRequest }
    //
    let (asyncBytes, response) = try await lsd._urlSession.bytes(for: sessionRequest)
    // Set expected
    let expectedContentLength = Int(response.expectedContentLength)
    // Create empty response data
    var responseData = Data()
    // Reserve capacity for expected content length
    responseData.reserveCapacity(expectedContentLength)
    // AsyncSequence with asyncBytes
    // Adds incoming byte to response data.
    // Sends progress to publisher
    for try await byte in asyncBytes {
      responseData.append(byte)
      let progress = Double(responseData.count) / Double(expectedContentLength)
      lsd._progress.send([progressID : LSDProgress(expectedLength: expectedContentLength,
                                                   bytesCount: responseData.count,
                                                   progress: progress)])
    }
    // Check response status
    guard let httpResponse = response as? HTTPURLResponse,
          200..<300 ~= httpResponse.statusCode
    else { throw LSDNetworkingError.serverError(errorCode: (response as! HTTPURLResponse).statusCode) }
    
    // If return type is HTTPStatus
    if T.ReturnType.self == HTTPStatus.self {
      guard let status = HTTPStatus(statusCode: httpResponse.statusCode) as? R
      else { throw LSDTripError.httpStatus }
      return status
    }
    
    // Decode response
    guard let responseObject = try?  JSONDecoder().decode(T.ReturnType.self, from: responseData)
    else { throw LSDTripError.jsonDecoding }
    // Return decoded response object
    return responseObject
  }
  
  /// "Drop out" suggested an active, selective, graceful process of detachment from involuntary or unconscious commitments.
  /// "Drop Out" meant self-reliance, a discovery of one's singularity, a commitment to mobility, choice, and change. Unhappily, my explanations of this sequence of personal development are often misinterpreted to mean "Get stoned and abandon all constructive activity".
  private func dropOut() {
    
  }
}

private extension LSDTrip {
  
  /// Builds URLRequest from ``Server``, ``Endpoint`` and ``Request``  objects
  /// - Returns: URLRequest
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
    
    return try URLRequest(url: url, request: request)
  }
}
