// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

/*
 * Copyright (c) 2020-Present, Okta, Inc. and/or its affiliates. All rights reserved.
 * The Okta software accompanied by this notice is provided pursuant to the Apache License, Version 2.0 (the "License.")
 *
 * You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0.
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *
 * See the License for the specific language governing permissions and limitations under the License.
 */

import PackageDescription

let package = Package(
    name: "OktaSecureStorage",
    platforms: [
        .macOS(.v10_14),
        .iOS(.v10)
    ],
    products: [
        .library(name: "OktaSecureStorage",
                 targets: [
                    "OktaSecureStorage"
                 ])
    ],
    targets: [
        .target(name: "OktaSecureStorage",
                path: "Sources"),
    ] + [
        .testTarget(name: "OktaSecureStorageTests",
                    dependencies: [
                        "OktaSecureStorage"
                    ],
                    path: "Tests")
    ]
)
