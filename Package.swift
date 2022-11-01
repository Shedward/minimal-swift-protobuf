// swift-tools-version:4.2

// Package.swift
//
// Copyright (c) 2014 - 2018 Apple Inc. and the project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.txt for license information:
// https://github.com/apple/swift-protobuf/blob/main/LICENSE.txt
//

import PackageDescription

let package = Package(
  name: "SwiftProtobuf",
  products: [
    .library(name: "MinimalSwiftProtobuf", targets: ["MinimalSwiftProtobuf"])
  ],
  targets: [
    .target(name: "MinimalSwiftProtobuf")
  ],
  swiftLanguageVersions: [.v4, .v4_2, .version("5")]
)
