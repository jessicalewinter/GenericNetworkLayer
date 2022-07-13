import Foundation

public enum HTTPStatusCode: Int {
    public typealias RawValue = Int

    /// Informational Response(100-199)
    
    /// Client should continue the request or ignore the response if the request is already finished.
    case `continue` = 100
    
    /// This code is sent in response to an Upgrade request header from the client and indicates the protocol the server is switching to.
    case switchingProtocols = 101
}
