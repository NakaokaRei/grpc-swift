/*
 * DO NOT EDIT.
 *
 * Generated by the protocol buffer compiler.
 * Source: echo.proto
 *
 */

/*
 * Copyright 2018, gRPC Authors All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import Foundation
import Dispatch
import gRPC
import SwiftProtobuf

/// Type for errors thrown from generated client code.
internal enum Echo_EchoClientError : Error {
  case endOfStream
  case invalidMessageReceived
  case error(c: CallResult)
}

/// Get (Unary)
internal protocol Echo_EchoGetCall {
  /// Cancel the call.
  func cancel()
}

/// Get (Unary)
fileprivate final class Echo_EchoGetCallImpl: Echo_EchoGetCall {
  private var call : Call

  /// Create a call.
  init(_ channel: Channel) {
    self.call = channel.makeCall("/echo.Echo/Get")
  }

  /// Run the call. Blocks until the reply is received.
  /// - Throws: `BinaryEncodingError` if encoding fails. `CallError` if fails to call. `Echo_EchoClientError` if receives no response.
  func run(request: Echo_EchoRequest,
                       metadata: Metadata) throws -> Echo_EchoResponse {
    let sem = DispatchSemaphore(value: 0)
    var returnCallResult : CallResult!
    var returnResponse : Echo_EchoResponse?
    _ = try start(request:request, metadata:metadata) {response, callResult in
      returnResponse = response
      returnCallResult = callResult
      sem.signal()
    }
    _ = sem.wait(timeout: DispatchTime.distantFuture)
    if let returnResponse = returnResponse {
      return returnResponse
    } else {
      throw Echo_EchoClientError.error(c: returnCallResult)
    }
  }

  /// Start the call. Nonblocking.
  /// - Throws: `BinaryEncodingError` if encoding fails. `CallError` if fails to call.
  func start(request: Echo_EchoRequest,
                         metadata: Metadata,
                         completion: @escaping ((Echo_EchoResponse?, CallResult)->()))
    throws -> Echo_EchoGetCall {

      let requestData = try request.serializedData()
      try call.start(.unary,
                     metadata:metadata,
                     message:requestData)
      {(callResult) in
        if let responseData = callResult.resultData,
          let response = try? Echo_EchoResponse(serializedData:responseData) {
          completion(response, callResult)
        } else {
          completion(nil, callResult)
        }
      }
      return self
  }

  func cancel() {
    call.cancel()
  }
}

/// Expand (Server Streaming)
internal protocol Echo_EchoExpandCall {
  /// Call this to wait for a result. Blocking.
  func receive() throws -> Echo_EchoResponse
  /// Call this to wait for a result. Nonblocking.
  func receive(completion:@escaping (Echo_EchoResponse?, Echo_EchoClientError?)->()) throws
  
  /// Cancel the call.
  func cancel()
}

internal extension Echo_EchoExpandCall {
  func receive() throws -> Echo_EchoResponse {
    var returnError : Echo_EchoClientError?
    var returnResponse : Echo_EchoResponse!
    let sem = DispatchSemaphore(value: 0)
    do {
      try receive() {response, error in
        returnResponse = response
        returnError = error
        sem.signal()
      }
      _ = sem.wait(timeout: DispatchTime.distantFuture)
    }
    if let returnError = returnError {
      throw returnError
    }
    return returnResponse
  }
}

fileprivate final class Echo_EchoExpandCallImpl: Echo_EchoExpandCall {
  private var call : Call

  /// Create a call.
  init(_ channel: Channel) {
    self.call = channel.makeCall("/echo.Echo/Expand")
  }

  /// Call this once with the message to send. Nonblocking.
  func start(request: Echo_EchoRequest,
                         metadata: Metadata,
                         completion: ((CallResult) -> ())?)
    throws -> Echo_EchoExpandCall {
      let requestData = try request.serializedData()
      try call.start(.serverStreaming,
                     metadata:metadata,
                     message:requestData,
                     completion:completion)
      return self
  }

  func receive(completion:@escaping (Echo_EchoResponse?, Echo_EchoClientError?)->()) throws {
    do {
      try call.receiveMessage() {(responseData) in
        if let responseData = responseData {
          if let response = try? Echo_EchoResponse(serializedData:responseData) {
            completion(response, nil)
          } else {
            completion(nil, Echo_EchoClientError.invalidMessageReceived)
          }
        } else {
          completion(nil, Echo_EchoClientError.endOfStream)
        }
      }
    }
  }

  /// Cancel the call.
  func cancel() {
    call.cancel()
  }
}

/// Simple fake implementation of Echo_EchoExpandCall that returns a previously-defined set of results.
class Echo_EchoExpandCallTestStub: Echo_EchoExpandCall {
  var outputs: [Echo_EchoResponse] = []
  
  func receive(completion:@escaping (Echo_EchoResponse?, Echo_EchoClientError?)->()) throws {
    if let output = outputs.first {
      outputs.removeFirst()
      completion(output, nil)
    } else {
      completion(nil, Echo_EchoClientError.endOfStream)
    }
  }

  func cancel() { }
}

/// Collect (Client Streaming)
internal protocol Echo_EchoCollectCall {
  /// Call this to send each message in the request stream. Nonblocking.
  func send(_ message:Echo_EchoRequest, errorHandler:@escaping (Error)->()) throws
  
  /// Call this to close the connection and wait for a response. Blocking.
  func closeAndReceive() throws -> Echo_EchoResponse
  /// Call this to close the connection and wait for a response. Nonblocking.
  func closeAndReceive(completion:@escaping (Echo_EchoResponse?, Echo_EchoClientError?)->()) throws
  
  /// Cancel the call.
  func cancel()
}

internal extension Echo_EchoCollectCall {
  func closeAndReceive() throws -> Echo_EchoResponse {
    var returnError : Echo_EchoClientError?
    var returnResponse : Echo_EchoResponse!
    let sem = DispatchSemaphore(value: 0)
    do {
      try closeAndReceive() {response, error in
        returnResponse = response
        returnError = error
        sem.signal()
      }
      _ = sem.wait(timeout: DispatchTime.distantFuture)
    } catch (let error) {
      throw error
    }
    if let returnError = returnError {
      throw returnError
    }
    return returnResponse
  }
}

fileprivate final class Echo_EchoCollectCallImpl: Echo_EchoCollectCall {
  private var call : Call

  /// Create a call.
  init(_ channel: Channel) {
    self.call = channel.makeCall("/echo.Echo/Collect")
  }

  /// Call this to start a call. Nonblocking.
  func start(metadata:Metadata, completion: ((CallResult)->())?)
    throws -> Echo_EchoCollectCall {
      try self.call.start(.clientStreaming, metadata:metadata, completion:completion)
      return self
  }

  func send(_ message:Echo_EchoRequest, errorHandler:@escaping (Error)->()) throws {
    let messageData = try message.serializedData()
    try call.sendMessage(data:messageData, errorHandler:errorHandler)
  }

  func closeAndReceive(completion:@escaping (Echo_EchoResponse?, Echo_EchoClientError?)->()) throws {
    do {
      try call.receiveMessage() {(responseData) in
        if let responseData = responseData,
          let response = try? Echo_EchoResponse(serializedData:responseData) {
          completion(response, nil)
        } else {
          completion(nil, Echo_EchoClientError.invalidMessageReceived)
        }
      }
      try call.close(completion:{})
    } catch (let error) {
      throw error
    }
  }

  func cancel() {
    call.cancel()
  }
}

/// Simple fake implementation of Echo_EchoCollectCall
/// stores sent values for later verification and finall returns a previously-defined result.
class Echo_EchoCollectCallTestStub: Echo_EchoCollectCall {
  var inputs: [Echo_EchoRequest] = []
  var output: Echo_EchoResponse?

  func send(_ message:Echo_EchoRequest, errorHandler:@escaping (Error)->()) throws {
    inputs.append(message)
  }
  
  func closeAndReceive(completion:@escaping (Echo_EchoResponse?, Echo_EchoClientError?)->()) throws {
    completion(output!, nil)
  }

  func cancel() { }
}

/// Update (Bidirectional Streaming)
internal protocol Echo_EchoUpdateCall {
  /// Call this to wait for a result. Blocking.
  func receive() throws -> Echo_EchoResponse
  /// Call this to wait for a result. Nonblocking.
  func receive(completion:@escaping (Echo_EchoResponse?, Echo_EchoClientError?)->()) throws
  
  /// Call this to send each message in the request stream.
  func send(_ message:Echo_EchoRequest, errorHandler:@escaping (Error)->()) throws
  
  /// Call this to close the sending connection. Blocking.
  func closeSend() throws
  /// Call this to close the sending connection. Nonblocking.
  func closeSend(completion: (()->())?) throws
  
  /// Cancel the call.
  func cancel()
}

internal extension Echo_EchoUpdateCall {
  func receive() throws -> Echo_EchoResponse {
    var returnError : Echo_EchoClientError?
    var returnMessage : Echo_EchoResponse!
    let sem = DispatchSemaphore(value: 0)
    do {
      try receive() {response, error in
        returnMessage = response
        returnError = error
        sem.signal()
      }
      _ = sem.wait(timeout: DispatchTime.distantFuture)
    }
    if let returnError = returnError {
      throw returnError
    }
    return returnMessage
  }

  func closeSend() throws {
    let sem = DispatchSemaphore(value: 0)
    try closeSend() {
      sem.signal()
    }
    _ = sem.wait(timeout: DispatchTime.distantFuture)
  }
}

fileprivate final class Echo_EchoUpdateCallImpl: Echo_EchoUpdateCall {
  private var call : Call

  /// Create a call.
  init(_ channel: Channel) {
    self.call = channel.makeCall("/echo.Echo/Update")
  }

  /// Call this to start a call. Nonblocking.
  func start(metadata:Metadata, completion: ((CallResult)->())?)
    throws -> Echo_EchoUpdateCall {
      try self.call.start(.bidiStreaming, metadata:metadata, completion:completion)
      return self
  }

  func receive(completion:@escaping (Echo_EchoResponse?, Echo_EchoClientError?)->()) throws {
    do {
      try call.receiveMessage() {(data) in
        if let data = data {
          if let returnMessage = try? Echo_EchoResponse(serializedData:data) {
            completion(returnMessage, nil)
          } else {
            completion(nil, Echo_EchoClientError.invalidMessageReceived)
          }
        } else {
          completion(nil, Echo_EchoClientError.endOfStream)
        }
      }
    }
  }

  func send(_ message:Echo_EchoRequest, errorHandler:@escaping (Error)->()) throws {
    let messageData = try message.serializedData()
    try call.sendMessage(data:messageData, errorHandler:errorHandler)
  }

  func closeSend(completion: (()->())?) throws {
  	try call.close(completion: completion)
  }

  func cancel() {
    call.cancel()
  }
}

/// Simple fake implementation of Echo_EchoUpdateCall that returns a previously-defined set of results
/// and stores sent values for later verification.
class Echo_EchoUpdateCallTestStub: Echo_EchoUpdateCall {
  var inputs: [Echo_EchoRequest] = []
  var outputs: [Echo_EchoResponse] = []
  
  func receive(completion:@escaping (Echo_EchoResponse?, Echo_EchoClientError?)->()) throws {
    if let output = outputs.first {
      outputs.removeFirst()
      completion(output, nil)
    } else {
      completion(nil, Echo_EchoClientError.endOfStream)
    }
  }

  func send(_ message:Echo_EchoRequest, errorHandler:@escaping (Error)->()) throws {
    inputs.append(message)
  }

  func closeSend(completion: (()->())?) throws { completion?() }

  func cancel() { }
}


/// Instantiate Echo_EchoServiceImpl, then call methods of this protocol to make API calls.
internal protocol Echo_EchoService {
  var channel: Channel { get }

  /// This metadata will be sent with all requests.
  var metadata: Metadata { get }

  /// This property allows the service host name to be overridden.
  /// For example, it can be used to make calls to "localhost:8080"
  /// appear to be to "example.com".
  var host : String { get }

  /// This property allows the service timeout to be overridden.
  var timeout : TimeInterval { get }
  
  /// Synchronous. Unary.
  func get(_ request: Echo_EchoRequest) throws -> Echo_EchoResponse
  /// Asynchronous. Unary.
  func get(_ request: Echo_EchoRequest,
                  completion: @escaping (Echo_EchoResponse?, CallResult)->()) throws -> Echo_EchoGetCall

  /// Asynchronous. Server-streaming.
  /// Send the initial message.
  /// Use methods on the returned object to get streamed responses.
  func expand(_ request: Echo_EchoRequest, completion: ((CallResult)->())?)
    throws -> Echo_EchoExpandCall

  /// Asynchronous. Client-streaming.
  /// Use methods on the returned object to stream messages and
  /// to close the connection and wait for a final response.
  func collect(completion: ((CallResult)->())?)
    throws -> Echo_EchoCollectCall

  /// Asynchronous. Bidirectional-streaming.
  /// Use methods on the returned object to stream messages,
  /// to wait for replies, and to close the connection.
  func update(completion: ((CallResult)->())?)
    throws -> Echo_EchoUpdateCall

}

internal final class Echo_EchoServiceClient: Echo_EchoService {
  internal private(set) var channel: Channel

  internal var metadata : Metadata

  internal var host : String {
    get {
      return self.channel.host
    }
    set {
      self.channel.host = newValue
    }
  }

  internal var timeout : TimeInterval {
    get {
      return self.channel.timeout
    }
    set {
      self.channel.timeout = newValue
    }
  }

  /// Create a client.
  internal init(address: String, secure: Bool = true) {
    gRPC.initialize()
    channel = Channel(address:address, secure:secure)
    metadata = Metadata()
  }

  /// Create a client that makes secure connections with a custom certificate and (optional) hostname.
  internal init(address: String, certificates: String, host: String?) {
    gRPC.initialize()
    channel = Channel(address:address, certificates:certificates, host:host)
    metadata = Metadata()
  }

  /// Synchronous. Unary.
  internal func get(_ request: Echo_EchoRequest)
    throws
    -> Echo_EchoResponse {
      return try Echo_EchoGetCallImpl(channel).run(request:request, metadata:metadata)
  }
  /// Asynchronous. Unary.
  internal func get(_ request: Echo_EchoRequest,
                  completion: @escaping (Echo_EchoResponse?, CallResult)->())
    throws
    -> Echo_EchoGetCall {
      return try Echo_EchoGetCallImpl(channel).start(request:request,
                                                 metadata:metadata,
                                                 completion:completion)
  }

  /// Asynchronous. Server-streaming.
  /// Send the initial message.
  /// Use methods on the returned object to get streamed responses.
  internal func expand(_ request: Echo_EchoRequest, completion: ((CallResult)->())?)
    throws
    -> Echo_EchoExpandCall {
      return try Echo_EchoExpandCallImpl(channel).start(request:request, metadata:metadata, completion:completion)
  }

  /// Asynchronous. Client-streaming.
  /// Use methods on the returned object to stream messages and
  /// to close the connection and wait for a final response.
  internal func collect(completion: ((CallResult)->())?)
    throws
    -> Echo_EchoCollectCall {
      return try Echo_EchoCollectCallImpl(channel).start(metadata:metadata, completion:completion)
  }

  /// Asynchronous. Bidirectional-streaming.
  /// Use methods on the returned object to stream messages,
  /// to wait for replies, and to close the connection.
  internal func update(completion: ((CallResult)->())?)
    throws
    -> Echo_EchoUpdateCall {
      return try Echo_EchoUpdateCallImpl(channel).start(metadata:metadata, completion:completion)
  }

}

/// Simple fake implementation of Echo_EchoService that returns a previously-defined set of results
/// and stores request values passed into it for later verification.
/// Note: completion blocks are NOT called with this default implementation, and asynchronous unary calls are NOT implemented!
class Echo_EchoServiceTestStub: Echo_EchoService {
  var channel: Channel { fatalError("not implemented") }
  var metadata = Metadata()
  var host = ""
  var timeout: TimeInterval = 0
  
  var getRequests: [Echo_EchoRequest] = []
  var getResponses: [Echo_EchoResponse] = []
  func get(_ request: Echo_EchoRequest) throws -> Echo_EchoResponse {
    getRequests.append(request)
    defer { getResponses.removeFirst() }
    return getResponses.first!
  }
  func get(_ request: Echo_EchoRequest,
                  completion: @escaping (Echo_EchoResponse?, CallResult)->()) throws -> Echo_EchoGetCall {
    fatalError("not implemented")
  }

  var expandRequests: [Echo_EchoRequest] = []
  var expandCalls: [Echo_EchoExpandCall] = []
  func expand(_ request: Echo_EchoRequest, completion: ((CallResult)->())?)
    throws -> Echo_EchoExpandCall {
      expandRequests.append(request)
      defer { expandCalls.removeFirst() }
      return expandCalls.first!
  }

  var collectCalls: [Echo_EchoCollectCall] = []
  func collect(completion: ((CallResult)->())?)
    throws -> Echo_EchoCollectCall {
      defer { collectCalls.removeFirst() }
      return collectCalls.first!
  }

  var updateCalls: [Echo_EchoUpdateCall] = []
  func update(completion: ((CallResult)->())?)
    throws -> Echo_EchoUpdateCall {
      defer { updateCalls.removeFirst() }
      return updateCalls.first!
  }

}



/// Type for errors thrown from generated server code.
internal enum Echo_EchoServerError : Error {
  case endOfStream
}

/// To build a server, implement a class that conforms to this protocol.
internal protocol Echo_EchoProvider {
  func get(request : Echo_EchoRequest, session : Echo_EchoGetSession) throws -> Echo_EchoResponse
  func expand(request : Echo_EchoRequest, session : Echo_EchoExpandSession) throws
  func collect(session : Echo_EchoCollectSession) throws
  func update(session : Echo_EchoUpdateSession) throws
}

/// Common properties available in each service session.
internal protocol Echo_EchoSession {
  var requestMetadata : Metadata { get }

  var statusCode : StatusCode { get }
  var statusMessage : String { get }
  var initialMetadata : Metadata { get }
  var trailingMetadata : Metadata { get }
}

fileprivate class Echo_EchoSessionImpl: Echo_EchoSession {
  var handler : Handler
  var requestMetadata : Metadata { return handler.requestMetadata }

  var statusCode : StatusCode = .ok
  var statusMessage : String = "OK"
  var initialMetadata : Metadata = Metadata()
  var trailingMetadata : Metadata = Metadata()

  init(handler:Handler) {
    self.handler = handler
  }
}

class Echo_EchoSessionTestStub: Echo_EchoSession {
  var requestMetadata = Metadata()

  var statusCode = StatusCode.ok
  var statusMessage = "OK"
  var initialMetadata = Metadata()
  var trailingMetadata = Metadata()
}

// Get (Unary Streaming)
internal protocol Echo_EchoGetSession : Echo_EchoSession { }

fileprivate final class Echo_EchoGetSessionImpl : Echo_EchoSessionImpl, Echo_EchoGetSession {
  private var provider : Echo_EchoProvider

  /// Create a session.
  init(handler:Handler, provider: Echo_EchoProvider) {
    self.provider = provider
    super.init(handler:handler)
  }

  /// Run the session. Internal.
  func run(queue:DispatchQueue) throws {
    try handler.receiveMessage(initialMetadata:initialMetadata) {(requestData) in
      if let requestData = requestData {
        let requestMessage = try Echo_EchoRequest(serializedData:requestData)
        let replyMessage = try self.provider.get(request:requestMessage, session: self)
        try self.handler.sendResponse(message:replyMessage.serializedData(),
                                      statusCode:self.statusCode,
                                      statusMessage:self.statusMessage,
                                      trailingMetadata:self.trailingMetadata)
      }
    }
  }
}

/// Trivial fake implementation of Echo_EchoGetSession.
class Echo_EchoGetSessionTestStub : Echo_EchoSessionTestStub, Echo_EchoGetSession { }

// Expand (Server Streaming)
internal protocol Echo_EchoExpandSession : Echo_EchoSession {
  /// Send a message. Nonblocking.
  func send(_ response: Echo_EchoResponse, completion: ((Bool)->())?) throws
}

fileprivate final class Echo_EchoExpandSessionImpl : Echo_EchoSessionImpl, Echo_EchoExpandSession {
  private var provider : Echo_EchoProvider

  /// Create a session.
  init(handler:Handler, provider: Echo_EchoProvider) {
    self.provider = provider
    super.init(handler:handler)
  }

  func send(_ response: Echo_EchoResponse, completion: ((Bool)->())?) throws {
    try handler.sendResponse(message:response.serializedData(), completion: completion)
  }

  /// Run the session. Internal.
  func run(queue:DispatchQueue) throws {
    try self.handler.receiveMessage(initialMetadata:initialMetadata) {(requestData) in
      if let requestData = requestData {
        do {
          let requestMessage = try Echo_EchoRequest(serializedData:requestData)
          // to keep providers from blocking the server thread,
          // we dispatch them to another queue.
          queue.async {
            do {
              try self.provider.expand(request:requestMessage, session: self)
              try self.handler.sendStatus(statusCode:self.statusCode,
                                          statusMessage:self.statusMessage,
                                          trailingMetadata:self.trailingMetadata,
                                          completion:nil)
            } catch (let error) {
              print("error: \(error)")
            }
          }
        } catch (let error) {
          print("error: \(error)")
        }
      }
    }
  }
}

/// Simple fake implementation of Echo_EchoExpandSession that returns a previously-defined set of results
/// and stores sent values for later verification.
class Echo_EchoExpandSessionTestStub : Echo_EchoSessionTestStub, Echo_EchoExpandSession {
  var outputs: [Echo_EchoResponse] = []

  func send(_ response: Echo_EchoResponse, completion: ((Bool)->())?) throws {
    outputs.append(response)
  }

  func close() throws { }
}

// Collect (Client Streaming)
internal protocol Echo_EchoCollectSession : Echo_EchoSession {
  /// Receive a message. Blocks until a message is received or the client closes the connection.
  func receive() throws -> Echo_EchoRequest

  /// Send a response and close the connection.
  func sendAndClose(_ response: Echo_EchoResponse) throws
}

fileprivate final class Echo_EchoCollectSessionImpl : Echo_EchoSessionImpl, Echo_EchoCollectSession {
  private var provider : Echo_EchoProvider

  /// Create a session.
  init(handler:Handler, provider: Echo_EchoProvider) {
    self.provider = provider
    super.init(handler:handler)
  }

  func receive() throws -> Echo_EchoRequest {
    let sem = DispatchSemaphore(value: 0)
    var requestMessage : Echo_EchoRequest?
    try self.handler.receiveMessage() {(requestData) in
      if let requestData = requestData {
        requestMessage = try? Echo_EchoRequest(serializedData:requestData)
      }
      sem.signal()
    }
    _ = sem.wait(timeout: DispatchTime.distantFuture)
    if requestMessage == nil {
      throw Echo_EchoServerError.endOfStream
    }
    return requestMessage!
  }

  func sendAndClose(_ response: Echo_EchoResponse) throws {
    try self.handler.sendResponse(message:response.serializedData(),
                                  statusCode:self.statusCode,
                                  statusMessage:self.statusMessage,
                                  trailingMetadata:self.trailingMetadata)
  }

  /// Run the session. Internal.
  func run(queue:DispatchQueue) throws {
    try self.handler.sendMetadata(initialMetadata:initialMetadata) { _ in
      queue.async {
        do {
          try self.provider.collect(session:self)
        } catch (let error) {
          print("error \(error)")
        }
      }
    }
  }
}

/// Simple fake implementation of Echo_EchoCollectSession that returns a previously-defined set of results
/// and stores sent values for later verification.
class Echo_EchoCollectSessionTestStub: Echo_EchoSessionTestStub, Echo_EchoCollectSession {
  var inputs: [Echo_EchoRequest] = []
  var output: Echo_EchoResponse?

  func receive() throws -> Echo_EchoRequest {
    if let input = inputs.first {
      inputs.removeFirst()
      return input
    } else {
      throw Echo_EchoClientError.endOfStream
    }
  }

  func sendAndClose(_ response: Echo_EchoResponse) throws {
    output = response
  }

  func close() throws { }
}

// Update (Bidirectional Streaming)
internal protocol Echo_EchoUpdateSession : Echo_EchoSession {
  /// Receive a message. Blocks until a message is received or the client closes the connection.
  func receive() throws -> Echo_EchoRequest

  /// Send a message. Nonblocking.
  func send(_ response: Echo_EchoResponse, completion: ((Bool)->())?) throws
  
  /// Close a connection. Blocks until the connection is closed.
  func close() throws
}

fileprivate final class Echo_EchoUpdateSessionImpl : Echo_EchoSessionImpl, Echo_EchoUpdateSession {
  private var provider : Echo_EchoProvider

  /// Create a session.
  init(handler:Handler, provider: Echo_EchoProvider) {
    self.provider = provider
    super.init(handler:handler)
  }

  func receive() throws -> Echo_EchoRequest {
    let sem = DispatchSemaphore(value: 0)
    var requestMessage : Echo_EchoRequest?
    try self.handler.receiveMessage() {(requestData) in
      if let requestData = requestData {
        do {
          requestMessage = try Echo_EchoRequest(serializedData:requestData)
        } catch (let error) {
          print("error \(error)")
        }
      }
      sem.signal()
    }
    _ = sem.wait(timeout: DispatchTime.distantFuture)
    if let requestMessage = requestMessage {
      return requestMessage
    } else {
      throw Echo_EchoServerError.endOfStream
    }
  }

  func send(_ response: Echo_EchoResponse, completion: ((Bool)->())?) throws {
    try handler.sendResponse(message:response.serializedData(), completion: completion)
  }

  func close() throws {
    let sem = DispatchSemaphore(value: 0)
    try self.handler.sendStatus(statusCode:self.statusCode,
                                statusMessage:self.statusMessage,
                                trailingMetadata:self.trailingMetadata) { _ in sem.signal() }
    _ = sem.wait(timeout: DispatchTime.distantFuture)
  }

  /// Run the session. Internal.
  func run(queue:DispatchQueue) throws {
    try self.handler.sendMetadata(initialMetadata:initialMetadata) { _ in
      queue.async {
        do {
          try self.provider.update(session:self)
        } catch (let error) {
          print("error \(error)")
        }
      }
    }
  }
}

/// Simple fake implementation of Echo_EchoUpdateSession that returns a previously-defined set of results
/// and stores sent values for later verification.
class Echo_EchoUpdateSessionTestStub : Echo_EchoSessionTestStub, Echo_EchoUpdateSession {
  var inputs: [Echo_EchoRequest] = []
  var outputs: [Echo_EchoResponse] = []

  func receive() throws -> Echo_EchoRequest {
    if let input = inputs.first {
      inputs.removeFirst()
      return input
    } else {
      throw Echo_EchoClientError.endOfStream
    }
  }

  func send(_ response: Echo_EchoResponse, completion: ((Bool)->())?) throws {
    outputs.append(response)
  }

  func close() throws { }
}


/// Main server for generated service
internal final class Echo_EchoServer {
  private var address: String
  private var server: Server
  private var provider: Echo_EchoProvider?

  /// Create a server that accepts insecure connections.
  internal init(address:String,
              provider:Echo_EchoProvider) {
    gRPC.initialize()
    self.address = address
    self.provider = provider
    self.server = Server(address:address)
  }

  /// Create a server that accepts secure connections.
  internal init?(address:String,
               certificateURL:URL,
               keyURL:URL,
               provider:Echo_EchoProvider) {
    gRPC.initialize()
    self.address = address
    self.provider = provider
    guard
      let certificate = try? String(contentsOf: certificateURL, encoding: .utf8),
      let key = try? String(contentsOf: keyURL, encoding: .utf8)
      else {
        return nil
    }
    self.server = Server(address:address, key:key, certs:certificate)
  }

  /// Start the server.
  internal func start(queue:DispatchQueue = DispatchQueue.global()) {
    guard let provider = self.provider else {
      fatalError() // the server requires a provider
    }
    server.run {(handler) in
      let unwrappedHost = handler.host ?? "(nil)"
      let unwrappedMethod = handler.method ?? "(nil)"
      let unwrappedCaller = handler.caller ?? "(nil)"
      print("Server received request to " + unwrappedHost
        + " calling " + unwrappedMethod
        + " from " + unwrappedCaller
        + " with " + handler.requestMetadata.description)

      do {
        switch unwrappedMethod {
        case "/echo.Echo/Get":
          try Echo_EchoGetSessionImpl(handler:handler, provider:provider).run(queue:queue)
        case "/echo.Echo/Expand":
          try Echo_EchoExpandSessionImpl(handler:handler, provider:provider).run(queue:queue)
        case "/echo.Echo/Collect":
          try Echo_EchoCollectSessionImpl(handler:handler, provider:provider).run(queue:queue)
        case "/echo.Echo/Update":
          try Echo_EchoUpdateSessionImpl(handler:handler, provider:provider).run(queue:queue)
        default:
          // handle unknown requests
          try handler.receiveMessage(initialMetadata:Metadata()) {(requestData) in
            try handler.sendResponse(statusCode:.unimplemented,
                                     statusMessage:"unknown method " + unwrappedMethod,
                                     trailingMetadata:Metadata())
          }
        }
      } catch (let error) {
        print("Server error: \(error)")
      }
    }
  }
}
