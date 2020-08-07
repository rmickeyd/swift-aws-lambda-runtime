//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftAWSLambdaRuntime open source project
//
// Copyright (c) 2017-2020 Apple Inc. and the SwiftAWSLambdaRuntime project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftAWSLambdaRuntime project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import class Foundation.JSONEncoder

// https://docs.aws.amazon.com/lambda/latest/dg/services-apigateway.html
// https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html

public enum APIGateway {
    /// APIGatewayRequest contains data coming from the API Gateway
    public struct Request: Codable {
        public struct Context: Codable {
            public struct Identity: Codable {
                public let cognitoIdentityPoolId: String?

                public let apiKey: String?
                public let userArn: String?
                public let cognitoAuthenticationType: String?
                public let caller: String?
                public let userAgent: String?
                public let user: String?

                public let cognitoAuthenticationProvider: String?
                public let sourceIp: String?
                public let accountId: String?
            }
            
            public struct Authorizer: Codable {
                public let principalId: String
                public let context: [String: String]
                
                public init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    self.principalId = try container.decode(String.self, forKey: .principalId)
                    self.context = try decoder.singleValueContainer().decode(Dictionary<String, String>.self)
                }
            }

            public let resourceId: String
            public let apiId: String
            public let resourcePath: String
            public let httpMethod: String
            public let requestId: String
            public let accountId: String
            public let stage: String

            public let identity: Identity
            public let extendedRequestId: String?
            public let path: String
            public let authorizer: Authorizer?
        }

        public let resource: String
        public let path: String
        public let httpMethod: HTTPMethod

        public let queryStringParameters: [String: String]?
        public let multiValueQueryStringParameters: [String: [String]]?
        public let headers: HTTPHeaders
        public let multiValueHeaders: HTTPMultiValueHeaders
        public let pathParameters: [String: String]?
        public let stageVariables: [String: String]?

        public let requestContext: Context
        public let body: String?
        public let isBase64Encoded: Bool
    }
}

// MARK: - Response -

extension APIGateway {
    public struct Response: Codable {
        public let statusCode: HTTPResponseStatus
        public let headers: HTTPHeaders?
        public let multiValueHeaders: HTTPMultiValueHeaders?
        public let body: String?
        public let isBase64Encoded: Bool?

        public init(
            statusCode: HTTPResponseStatus,
            headers: HTTPHeaders? = nil,
            multiValueHeaders: HTTPMultiValueHeaders? = nil,
            body: String? = nil,
            isBase64Encoded: Bool? = nil
        ) {
            self.statusCode = statusCode
            self.headers = headers
            self.multiValueHeaders = multiValueHeaders
            self.body = body
            self.isBase64Encoded = isBase64Encoded
        }
    }
}
