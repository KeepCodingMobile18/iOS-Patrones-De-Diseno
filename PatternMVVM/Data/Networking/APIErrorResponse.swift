import Foundation

struct APIErrorResponse: Error, Equatable, LocalizedError {
    let url: String
    let statusCode: Int
    let data: Data?
    let message: String
    var errorDescription: String? {
        NSLocalizedString(message, comment: "") // We can use a key to make it localizable instead of passing the entire object
    }
    
    init(_ statusCode: Int, _ message: String, _ url: String, data: Data? = nil) {
        // Every time we add default values we have can't add _ as external name
        (self.url, self.statusCode, self.data, self.message) = (url, statusCode, data, message)
    }
}

extension APIErrorResponse {
    static func network(_ url: String) -> APIErrorResponse {
        return APIErrorResponse(-1, "Network connection error", url)
    }
    
    static func parseData(_ url: String) -> APIErrorResponse {
        return APIErrorResponse(-2, "Cannot parse data from URL", url)
    }
    
    static func unknown(_ url: String) -> APIErrorResponse {
        return APIErrorResponse(-3, "Unknown error", url)
    }
    
    static func empty(_ url: String) -> APIErrorResponse {
        return APIErrorResponse(-4, "Empty data", url)
    }
    
    static func malformedUrl(_ url: String) -> APIErrorResponse {
        return APIErrorResponse(-5, "Can't generate the Url", url)
    }
}
