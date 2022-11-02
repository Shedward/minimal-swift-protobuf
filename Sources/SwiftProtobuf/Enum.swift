// Sources/SwiftProtobuf/Enum.swift - Enum support
//
// Copyright (c) 2014 - 2016 Apple Inc. and the project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.txt for license information:
// https://github.com/apple/swift-protobuf/blob/main/LICENSE.txt
//
// -----------------------------------------------------------------------------
///
/// Generated enums conform to SwiftProtobuf.Enum
///
/// See ProtobufTypes and JSONTypes for extension
/// methods to support binary and JSON coding.
///
// -----------------------------------------------------------------------------

// TODO: `Enum` should require `Sendable` but we cannot do so yet without possibly breaking compatibility.

/// Generated enum types conform to this protocol.
public protocol Enum: RawRepresentable, Hashable {
  /// Creates a new instance of the enum initialized to its default value.
  init()

  /// Creates a new instance of the enum from the given raw integer value.
  ///
  /// For proto2 enums, this initializer will fail if the raw value does not
  /// correspond to a valid enum value. For proto3 enums, this initializer never
  /// fails; unknown values are created as instances of the `UNRECOGNIZED` case.
  ///
  /// - Parameter rawValue: The raw integer value from which to create the enum
  ///   value.
  init?(rawValue: Int)

  /// The raw integer value of the enum value.
  ///
  /// For a recognized enum case, this is the integer value of the case as
  /// defined in the .proto file. For `UNRECOGNIZED` cases in proto3, this is
  /// the value that was originally decoded.
  var rawValue: Int { get }
}

extension Enum {
#if swift(>=4.2)
  public func hash(into hasher: inout Hasher) {
    hasher.combine(rawValue)
  }
#else  // swift(>=4.2)
  public var hashValue: Int {
    return rawValue
  }
#endif  // swift(>=4.2)
}
