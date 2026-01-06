///|
// Socket abstraction layer for IB MoonBit API
// This file provides a unified interface for socket operations across different platforms
// Actual implementations are in target-specific packages (target/js, target/wasm, target/c)

pub struct Socket {
  socket_id : Int
}

///|
pub struct Address {
  host : String
  port : Int
}

///|
pub enum SocketError {
  ConnectionRefused
  Timeout
  Closed
  Other(String)
}

///|
pub fn SocketError::to_string(self : SocketError) -> String {
  match self {
    ConnectionRefused => "ConnectionRefused"
    Timeout => "Timeout"
    Closed => "Closed"
    Other(msg) => "Other(" + msg + ")"
  }
}

// Stub implementations - actual FFI implementations are in target-specific packages
// These stubs allow the code to compile, but will always return errors
// To use actual socket operations, build with explicit target (js, wasm, c)
// and the target-specific implementation will be used

///|
pub fn connect(
  _addr : Address,
  _timeout_ms : Int,
) -> Result[Socket, SocketError] {
  // Stub implementation - actual implementation in target-specific files
  Err(Other("Socket FFI not implemented - build with explicit target"))
}

///|
pub fn send(_sock : Socket, _data : Array[Byte]) -> Result[Unit, SocketError] {
  // Stub implementation - actual implementation in target-specific files
  Err(Other("Socket FFI not implemented - build with explicit target"))
}

///|
pub fn receive(
  _sock : Socket,
  _length : Int,
  _timeout_ms : Int,
) -> Result[Array[Byte], SocketError] {
  // Stub implementation - actual implementation in target-specific files
  Err(Other("Socket FFI not implemented - build with explicit target"))
}

///|
pub fn close(_sock : Socket) -> Result[Unit, SocketError] {
  // Stub implementation - actual implementation in target-specific files
  Err(Other("Socket FFI not implemented - build with explicit target"))
}
