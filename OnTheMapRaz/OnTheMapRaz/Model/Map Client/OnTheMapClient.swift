//
//  OnTheMapClient.swift
//  OnTheMapRaz
//
//  Created by pc on 02/05/2023.
//

import Foundation

class OnTheMapClient {
    
    enum Endpoins {
        static let base = "https://onthemap-api.udacity.com/v1/"
        static let session = "session"
        static let limit = "?limit=100"
//        static let limit = "?limit=200&skip=400"
        
        case createSessionId
        case signUp
        case logout
        case getStudentLocations
        case getUserData
        case postStudentLocation
        
        
        var stringValue: String {
            switch self {
            case .createSessionId:
                return Endpoins.base + Endpoins.session
            case .signUp:
                return "https://auth.udacity.com/sign-up"
            case .logout:
                return Endpoins.base + Endpoins.session
            case .getStudentLocations:
                return Endpoins.base + "StudentLocation" + Endpoins.limit + "&order=-updatedAt"
            case .getUserData:
                return Endpoins.base + "users/" + Auth.objectId
            case .postStudentLocation:
                return Endpoins.base + "StudentLocation"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    
    }
    
    
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
                
            } catch {
                do {
                    let range = 5..<data.count
                    let newData = data.subdata(in: range)
                    let newResponseObject = try decoder.decode(ResponseType.self, from: newData)
                    DispatchQueue.main.async {
                        completion(newResponseObject, nil)
                    }
                } catch {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        DispatchQueue.main.async {
                            completion(nil, errorResponse)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(nil, error)
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        request.httpBody = try! encoder.encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                do {
                    let newResponseObject = try decoder.decode(ResponseType.self, from: newData)
                    DispatchQueue.main.async {
                        completion(newResponseObject, nil)
                    }
                } catch {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: newData)
                        DispatchQueue.main.async {
                            completion(nil, errorResponse)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(nil, error)
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    
    
    
    class func createSessionId(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        
        let body = LoginRequest(udacity: ["username" : "\(username)", "password": "\(password)"])
        taskForPOSTRequest(url: Endpoins.createSessionId.url, responseType: LoginResponse.self, body: body) { (response, error) in
            
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.objectId = response.account.key
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
        
    }
    
    
    
    class func getStudentLocations(completion: @escaping ([Results], Error?) -> Void) {
        taskForGETRequest(url: Endpoins.getStudentLocations.url, response: LocationsResponse.self) { (response, error) in
            if let response = response {
                DispatchQueue.main.async {
                    completion(response.results, nil)
                }
            } else {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
    
    
    
    class func getUserData(completion: @escaping (Bool, Error?) -> Void) {
        
        taskForGETRequest(url: Endpoins.getUserData.url, response: UserDataResponse.self) { (response, error) in
            if let response = response {
                Auth.firstName = response.firstName
                Auth.lastName = response.lastName
                Auth.uniqueKey = response.key
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
    }
    
    
    
    
    class func postStudentLocation(mapString: String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping (Bool, Error?) -> Void) {
        
        let body = StudentLocationRequest(uniqueKey: Auth.uniqueKey, firstName: Auth.firstName, lastName: Auth.lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
        
        taskForPOSTRequest(url: Endpoins.postStudentLocation.url, responseType: PostLocationResponse.self, body: body) { (response, error) in
            
            if response != nil {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    
    
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoins.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            print(String(data: newData!, encoding: .utf8)!)
            Auth.sessionId = ""
            Auth.objectId = ""
            completion()
        }
        task.resume()
        
    }
    
}
