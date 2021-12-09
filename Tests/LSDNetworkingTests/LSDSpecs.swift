//
//  File.swift
//  
//
//  Created by Neo Golightly on 04.12.21.
//

import Quick
import Nimble
import Foundation
@testable import LSDNetworking
import Combine

class LSDSpecs: QuickSpec {
  private var subscriptions = Set<AnyCancellable>()
  override func spec() {
    describe("LSD Networking") {
      it("fetcheses some todos") {
        self.runAsyncTest {
//          let api = FakeAPI()
//          api.progress.sink { progress in
//            print(progress)
//          }.store(in: &self.subscriptions)
//
//          let todos = try await api.getTodos()
//          print(todos)
        }
      }
    }
  }
}


extension QuickSpec {
  func runAsyncTest(
    named testName: String = #function,
    in file: StaticString = #file,
    at line: UInt = #line,
    withTimeout timeout: DispatchTimeInterval = .seconds(3),
    test: @escaping () async throws -> Void
  ) {
    
    waitUntil(timeout: timeout) { done in
      Task {
        do {
          try await test()
        } catch {
          fail("Async error thrown: \(error)")
          done()
        }
        
        done()
      }
    }
  }
}
