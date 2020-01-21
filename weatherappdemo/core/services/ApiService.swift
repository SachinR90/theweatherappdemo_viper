//
//  ApiService.swift
//  weatherappdemo
//
//  Created by Sachin Rao on 20/01/20.
//

import Foundation
import Alamofire

class ApiService{
    static fileprivate func createRequest(url:String, method:HTTPMethod) -> URLRequest{
        guard let url = URL(string: url),var request = try? URLRequest(url: url,method: method) else{
            fatalError("Invalid Request")
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.timeoutInterval = 30
        return request
    }
    
    @discardableResult
    static func request<T:Codable>(url: String, requestType: HTTPMethod, requiredRequestHeaders: [String: String], parameters: [String: Any]?, completion:@escaping (Result<T, ResponseError>) -> Void) -> DataRequest {
        
        var request = createRequest(url: url, method: requestType)
        let jsonData: Data?
        
        for (key, value) in requiredRequestHeaders {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        if let json = parameters, requestType != .get {
            jsonData = try? JSONSerialization.data(withJSONObject: json)
            request.httpBody = jsonData
        }
        
        let decoder: JSONDecoder = JSONDecoder().self
        return AF.request(request).responseDecodable(decoder: decoder) { (response: AFDataResponse<T>) in
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure:
                print("Error: %@", response.error ?? "Unknown Error")
                let httpStatusCode = response.error?.asAFError?.responseCode ?? 500 //Default
                let description = response.error?.localizedDescription ?? "Unknown Error"
                completion(.failure(.errorInfo(httpStatusCode: httpStatusCode, description: description)))
            }
            
        }.validate()
    }
    
    @discardableResult
    static func imageRequest(url:String, completion:@escaping (AFDataResponse<Data>)->Void)->DataRequest{
        return AF.request(url).responseData(completionHandler: completion)
    }
}

public enum ResponseError: Error {
    case errorInfo(httpStatusCode: Int, description: String)
}
