//
//  Publisher+Await.swift
//  TimeZones
//
//  Created by Chris Nevin on 16/9/21.
//

import Combine

// Future
extension Publisher where Failure == Never {
    /// Convert a publisher into an async/await continuation.
    @discardableResult func `await`() async -> Output {
        await withUnsafeContinuation { (continuation: UnsafeContinuation<Output, Never>) in
            var cancellable: Cancellable?
            cancellable = self
                .prefix(1)
                .sink { output in
                    continuation.resume(returning: output)
                    _ = cancellable
                }
        }
    }

    /// Convert a publisher into an async/await continuation with a condition on the completion.
    @discardableResult func `await`(`while` isInFlight: @escaping (Output) -> Bool) async -> Output {
        await withUnsafeContinuation { (continuation: UnsafeContinuation<Output, Never>) in
            var cancellable: Cancellable?
            cancellable = self
                .filter { !isInFlight($0) }
                .prefix(1)
                .sink { output in
                    continuation.resume(returning: output)
                    _ = cancellable
                }
        }
    }
}
