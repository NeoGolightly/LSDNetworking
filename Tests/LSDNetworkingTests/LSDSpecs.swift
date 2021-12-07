//
//  File.swift
//  
//
//  Created by Michael Helmbrecht on 04.12.21.
//

import Quick
import Nimble
import Foundation
@testable import LSDNetworking

class LSDSpecs: QuickSpec {
  override func spec() {
    describe("LSD Networking") {
      it("fetcheses some todos") {
        self.runAsyncTest {
          
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
