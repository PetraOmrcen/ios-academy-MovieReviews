//
//  NetworkManager.swift
//  TV Shows
//
//  Created by Infinum on 25.08.2021..
//

import Foundation
import Alamofire

struct NetworkManager {
    
}

protocol EndPointType {
    
    // MARK: - Vars & Lets
    
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var url: URL { get }
    var encoding: ParameterEncoding { get }
    var version: String { get }
    
}

enum EndpointItem {
    
    // MARK: User actions
    
    case singIn
    case login
    case shows
    case updateUser
    case reviews
    case showDetails(_: String)
    case profileDetails
}

// MARK: - Extensions
// MARK: - EndPointType
extension EndpointItem: EndPointType {
    
    // MARK: - Vars & Lets
    
    var baseURL: String {
        return "https://tv-shows.infinum.academy/"
    }
    
    var version: String {
        return "/v0_1"
    }
    
    var path: String {
        switch self {
        
        case .singIn:
            return "users/sign_in"
        case .login:
            return "users"
        case .shows:
            return "shows"
        case .updateUser: //ovo jos moram vidjet
            return "users"
        case .reviews:
            return "reviews"
        case .showDetails(let id):
            return "shows/\(id)/reviews"
        case .profileDetails:
            return "users/me"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .updateUser:
            return .put
        case .login, .singIn, .reviews:
            return .post
        default:
            return .get
        }
    }
    
    // ovo popravi
    var headers: HTTPHeaders? {
        switch self {
        case .updateUser:
            return ["Content-Type": "application/json",
                    "X-Requested-With": "XMLHttpRequest",
                    "x-access-token": "someToken"]
        default:
            return ["Content-Type": "application/json",
                    "X-Requested-With": "XMLHttpRequest"]
        }
    }
    
    var url: URL {
        switch self {
        default:
            return URL(string: self.baseURL + self.path)!
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        default:
            return JSONEncoding.default
        }
    }
    
}

class APIManager {
    
    // MARK: - Vars & Lets
    
    private let sessionManager: Session
    //static let networkEnviroment: NetworkEnvironment = .dev
    
    // MARK: - Vars & Lets
    
    private static var sharedApiManager: APIManager = {
        let apiManager = APIManager(sessionManager: Session())
        return apiManager
    }()
    
    // MARK: - Accessors
    
    class func shared() -> APIManager {
        return sharedApiManager
    }
    
    // MARK: - Initialization
    
    init(sessionManager: Session) {
        self.sessionManager = sessionManager
    }
    
    
    func call<T>(type: EndPointType, params: Parameters? = nil, handler: @escaping (T?)->()) where T: Codable {
        self.sessionManager
            .request(
                type.url,
                method: type.httpMethod,
                parameters: params,
                encoding: type.encoding,
                headers: type.headers
            ).validate()
            .responseJSON { data in
                switch data.result {
                case .success(_):
                    let decoder = JSONDecoder()
                    if let jsonData = data.data {
                        let result = try! decoder.decode(T.self, from: jsonData)
                        handler(result)
                    }
                    break
                case .failure(_):
                    print("Fail")
                    break
                }
            }
    }
    
    func call(type: EndPointType, params: Parameters? = nil, handler: @escaping (()?)->()) {
        self.sessionManager.request(type.url,
                                    method: type.httpMethod,
                                    parameters: params,
                                    encoding: type.encoding,
                                    headers: type.headers).validate().responseJSON { data in
                                        switch data.result {
                                        case .success(_):
                                            handler(())
                                            break
                                        case .failure(_):
                                            print("Fail")
                                            break
                                        }
                                    }
    }
    
    
}

