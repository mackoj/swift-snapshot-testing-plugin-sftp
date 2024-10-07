import Foundation
import FileSerializationPlugin
@preconcurrency import Citadel

/*
 THIS CODE IS BAD PRETTY BAD
 FileSerializationPlugin to be redesign to better support concurrency and customability
 PLEASE NO ONE SHOULD EVER USE THIS
 */

public actor SFTPFileTransport: @preconcurrency FileSerializationPlugin {
  public typealias Configuration = SSHClientConnectConfiguration
  
  public struct SSHClientConnectConfiguration {
    let host: String
    let port: Int = 22
    let authenticationMethod: SSHAuthenticationMethod
    let hostKeyValidator: SSHHostKeyValidator
    let reconnect: SSHReconnectMode
    let algorithms: SSHAlgorithms = SSHAlgorithms()
  }

  var sftp: SFTPClient? = nil
  var client: SSHClient? = nil

  public init() {}
  
  public static var location = FileSerializationLocation.plugins("sftp")
  
  public func write(_ data: Data, to url: URL, options: Data.WritingOptions) async throws {
    let file = try await sftp?.openFile(filePath: url.path, flags: [.read, .write, .forceCreate])
    try await file?.write(.init(data: data))
    try await file?.close()
  }
  
  public func read(_ url: URL) async throws -> Data? {
    let resolv = try await sftp?.openFile(filePath: url.path, flags: .read)
    let resolvContents = try await resolv?.readAll()
    let data = resolvContents?.getData(at: 0, length: resolvContents?.readableBytes ?? 0)
    return data
  }
  
  public func start(_ configuration: Configuration) async throws {
    client = try await SSHClient.connect(
      host: configuration.host,
      port: configuration.port,
      authenticationMethod: configuration.authenticationMethod,
      hostKeyValidator: configuration.hostKeyValidator,
      reconnect: configuration.reconnect,
      algorithms: configuration.algorithms
    )
    sftp = try await client?.openSFTP()
  }
  
  public func stop() async throws {
    try await client?.close()
  }
  
  public static let identifier: String = "FileSerializationPlugin.sftp"
}

