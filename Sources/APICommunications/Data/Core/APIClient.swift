import Foundation
import OSLog

public struct APIClient<R: APIRequest>: Initializable {
    let logger = Logger(label: "APIClient<\(R.self)>")

    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        return URLSession(configuration: configuration)
    }()

    public init() {}

    public func request(with request: R) async throws -> R.Response {
        logger.info("Request Started: \(R.self)")
        logger.trace("Request Detail: \(R.self)\n\(request.prettyPrintedRequest)")

        do {
            let urlRequest = try makeUrlRequest(from: request)

            let (data, response) = try await session.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.unknown(
                    logMessage: "Response Casting Error."
                )
            }

            logger.trace("""
            Response returned: \(R.Response.self)
            headers: \(httpResponse.allHeaderFields.prettyFormatted)
            response: \(data.prettyFormatted)
            """)

            switch httpResponse.statusCode {
            case 200 ..< 300:
                let response = try decodeResponse(
                    R.Response.self,
                    from: data,
                    keyDecodingStrategy: request.codingStrategy.decoding
                )

                logger.info("Request Success: \(R.self)")

                return response
            default:
                let errorResult = try decodeResponse(
                    R.ErrorResponse.self,
                    from: data,
                    keyDecodingStrategy: request.codingStrategy.decoding
                )

                throw APIError.server(
                    errorResult,
                    logMessage: "Invalid Status Code \(httpResponse.statusCode)."
                )
            }
        } catch let apiError as APIError {
            logger.error("Error: \(apiError.logMessage)")

            throw apiError
        } catch {
            switch error {
            case let urlError as URLError where urlError.code == .timedOut:
                logger.error("Error: Request Timed Out.\n error: \(urlError)")

                throw APIError.requestTimedOut
            default:
                logger.error("Error: Unknown Error.\n error: \(error)")

                throw APIError.unknown()
            }
        }
    }

    private func decodeResponse<T: Decodable>(
        _ type: T.Type,
        from data: Data,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy
    ) throws -> T {
        do {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = keyDecodingStrategy

            return try jsonDecoder.decode(type, from: data)
        } catch {
            throw APIError.jsonDecoding(
                logMessage: "Json Decoding Error.\nerror: \(error)"
            )
        }
    }

    private func makeUrlRequest(from request: R) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = request.scheme
        components.host = request.host
        components.path = request.path
        components.queryItems = request.queryItems

        guard let url = components.url else {
            throw APIError.unknown(logMessage: "URLRequest Making Error. Invalid URL.")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue

        for (key, value) in request.headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        if !(request.body is EmptyBody) {
            urlRequest.httpBody = try encodeBody(
                request.body,
                keyEncodingStrategy: request.codingStrategy.encoding
            )
        }

        return urlRequest
    }

    private func encodeBody<T: Encodable>(
        _ body: T,
        keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy
    ) throws -> Data {
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.keyEncodingStrategy = keyEncodingStrategy

            return try jsonEncoder.encode(body)
        } catch {
            throw APIError.unknown(logMessage: "URLRequest Body Encode Error.")
        }
    }
}
