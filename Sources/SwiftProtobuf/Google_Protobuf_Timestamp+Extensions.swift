// Sources/SwiftProtobuf/Google_Protobuf_Timestamp+Extensions.swift - Timestamp extensions
//
// Copyright (c) 2014 - 2016 Apple Inc. and the project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.txt for license information:
// https://github.com/apple/swift-protobuf/blob/main/LICENSE.txt
//
// -----------------------------------------------------------------------------
///
/// Extend the generated Timestamp message with customized JSON coding,
/// arithmetic operations, and convenience methods.
///
// -----------------------------------------------------------------------------

import Foundation

private let minTimestampSeconds: Int64 = -62135596800  // 0001-01-01T00:00:00Z
private let maxTimestampSeconds: Int64 = 253402300799  // 9999-12-31T23:59:59Z

// TODO: Add convenience methods to interoperate with standard
// date/time classes:  an initializer that accepts Unix timestamp as
// Int or Double, an easy way to convert to/from Foundation's
// NSDateTime (on Apple platforms only?), others?

private func formatTimestamp(seconds: Int64, nanos: Int32) -> String? {
  let (seconds, nanos) = normalizeForTimestamp(seconds: seconds, nanos: nanos)
  guard seconds >= minTimestampSeconds && seconds <= maxTimestampSeconds else {
    return nil
  }

  let (hh, mm, ss) = timeOfDayFromSecondsSince1970(seconds: seconds)
  let (YY, MM, DD) = gregorianDateFromSecondsSince1970(seconds: seconds)

  let dateString = "\(fourDigit(YY))-\(twoDigit(MM))-\(twoDigit(DD))"
  let timeString = "\(twoDigit(hh)):\(twoDigit(mm)):\(twoDigit(ss))"
  let nanosString = nanosToString(nanos: nanos) // Includes leading '.' if needed

  return "\(dateString)T\(timeString)\(nanosString)Z"
}

extension Google_Protobuf_Timestamp {
  /// Creates a new `Google_Protobuf_Timestamp` equal to the given number of
  /// seconds and nanoseconds.
  ///
  /// - Parameter seconds: The number of seconds.
  /// - Parameter nanos: The number of nanoseconds.
  public init(seconds: Int64 = 0, nanos: Int32 = 0) {
    self.init()
    self.seconds = seconds
    self.nanos = nanos
  }
}

extension Google_Protobuf_Timestamp {
  /// Creates a new `Google_Protobuf_Timestamp` initialized relative to 00:00:00
  /// UTC on 1 January 1970 by a given number of seconds.
  ///
  /// - Parameter timeIntervalSince1970: The `TimeInterval`, interpreted as
  ///   seconds relative to 00:00:00 UTC on 1 January 1970.
  public init(timeIntervalSince1970: TimeInterval) {
    let sd = floor(timeIntervalSince1970)
    let nd = round((timeIntervalSince1970 - sd) * TimeInterval(nanosPerSecond))
    let (s, n) = normalizeForTimestamp(seconds: Int64(sd), nanos: Int32(nd))
    self.init(seconds: s, nanos: n)
  }

  /// Creates a new `Google_Protobuf_Timestamp` initialized relative to 00:00:00
  /// UTC on 1 January 2001 by a given number of seconds.
  ///
  /// - Parameter timeIntervalSinceReferenceDate: The `TimeInterval`,
  ///   interpreted as seconds relative to 00:00:00 UTC on 1 January 2001.
  public init(timeIntervalSinceReferenceDate: TimeInterval) {
    let sd = floor(timeIntervalSinceReferenceDate)
    let nd = round(
      (timeIntervalSinceReferenceDate - sd) * TimeInterval(nanosPerSecond))
    // The addition of timeIntervalBetween1970And... is deliberately delayed
    // until the input is separated into an integer part and a fraction
    // part, so that we don't unnecessarily lose precision.
    let (s, n) = normalizeForTimestamp(
      seconds: Int64(sd) + Int64(Date.timeIntervalBetween1970AndReferenceDate),
      nanos: Int32(nd))
    self.init(seconds: s, nanos: n)
  }

  /// Creates a new `Google_Protobuf_Timestamp` initialized to the same time as
  /// the given `Date`.
  ///
  /// - Parameter date: The `Date` with which to initialize the timestamp.
  public init(date: Date) {
    // Note: Internally, Date uses the "reference date," not the 1970 date.
    // We use it when interacting with Dates so that Date doesn't perform
    // any double arithmetic on our behalf, which might cost us precision.
    self.init(
      timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate)
  }

  /// The interval between the timestamp and 00:00:00 UTC on 1 January 1970.
  public var timeIntervalSince1970: TimeInterval {
    return TimeInterval(self.seconds) +
      TimeInterval(self.nanos) / TimeInterval(nanosPerSecond)
  }

  /// The interval between the timestamp and 00:00:00 UTC on 1 January 2001.
  public var timeIntervalSinceReferenceDate: TimeInterval {
    return TimeInterval(
      self.seconds - Int64(Date.timeIntervalBetween1970AndReferenceDate)) +
      TimeInterval(self.nanos) / TimeInterval(nanosPerSecond)
  }

  /// A `Date` initialized to the same time as the timestamp.
  public var date: Date {
    return Date(
      timeIntervalSinceReferenceDate: self.timeIntervalSinceReferenceDate)
  }
}

private func normalizeForTimestamp(
  seconds: Int64,
  nanos: Int32
) -> (seconds: Int64, nanos: Int32) {
  // The Timestamp spec says that nanos must be in the range [0, 999999999),
  // as in actual modular arithmetic.

  let s = seconds + Int64(div(nanos, nanosPerSecond))
  let n = mod(nanos, nanosPerSecond)
  return (seconds: s, nanos: n)
}
