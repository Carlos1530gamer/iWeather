//
//  Network.swift
//  iWeather
//
//  Created by Carlos Daniel Hernandez Chauteco on 4/1/19.
//  Copyright © 2019 chauteco. All rights reserved.
//

import Foundation

typealias constants = NetworkServiceConstants

struct NetworkServiceKeys {
    static let city = "city"
}

struct ServiceResponseCode {
    static let success = 200
}


class NetworkService {
    
    typealias keys = NetworkServiceKeys
    typealias responseCode = ServiceResponseCode
    
    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    private var pathBase: String
    
    static let shared = NetworkService(pathBase: "https://api.weatherbit.io/v2.0/current")
    
    private init(pathBase: String){
        self.pathBase = pathBase
        self.pathBase += "?key=\(constants.weatherKey)"
        self.pathBase += "&lang=\(constants.lenguage.spanish)"
    }
    
    private func createFullPath(with parameters: [String:String]) -> String{
        guard var auxPath = self.pathBase.copy() as? String else { return "" }
        for key in parameters{
            auxPath += "&\(key.key)=\(key.value)"
        }
        
        return auxPath
    }
    
    private func createURLRequest(with path: String, httpMethod: HttpMethod) -> URLRequest?{
        guard let url = URL(string: path) else { return nil }
        var request = URLRequest(url: url)
        
        request.httpMethod = httpMethod.rawValue
        request.timeoutInterval = constants.timeInterval
        
        return request
    }
    
    //Especial func for images
    
    func getImageforIcon(iconCode: String, success: @escaping(_ data: Data)->Void){
        let path = "https://www.weatherbit.io/static/img/icons/" + iconCode + ".png"
        
        guard let request = createURLRequest(with: path, httpMethod: .get) else { return }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let err = error{
                    print(err.localizedDescription)
                }else{
                    if let response = response as? HTTPURLResponse{
                        switch response.statusCode{
                        case responseCode.success:
                            guard let dat = data else { return }
                            success(dat)
                            break
                        default:
                            print("error desconocido de http")
                            break
                        }
                    }
                }
            }
        }
        
        task.resume()
    }
    
    //MARK: getWheaterByCity
    func getWeather(with parameters: [String:String], success: @escaping(_ data: Data)->Void){
        let url = createFullPath(with: parameters)
        guard let request = createURLRequest(with: url, httpMethod: .get) else { return }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let err = error{
                    print(err.localizedDescription)
                }else{
                    if let response = response as? HTTPURLResponse {
                        switch response.statusCode{
                        case responseCode.success:
                            guard let dat = data else { return }
                            success(dat)
                            break
                        default:
                            print("error desconocido de http")
                            break
                        }
                    }
                }
            }
        }
        
        task.resume()
    }
    
}
