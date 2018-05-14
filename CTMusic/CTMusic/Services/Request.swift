//
//  Request.swift
//  S4SUserClient
//
//  Created by zikong on 16/6/16.
//  Copyright © 2016年 zikong. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import ObjectMapper


extension DataRequest {
    
    public static func ObjectMapperSerializer<T: Mappable>(_ keyPath: String?, mapToObject object: T? = nil, content: MapContext? = nil) -> DataResponseSerializer<T> {
        return DataResponseSerializer { request, response, data, error in
            
            guard error == nil else {
                return .failure(BackendError.network(error: error! as NSError))
            }
            
            guard let _ = data else {
                let failureReason = "Data could not be serialized. Input data is nil."
                return .failure(BackendError.dataSerialization(reason: failureReason))
            }
            
            let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonResponseSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case let .success(value):
                guard let resultDic = value as? NSDictionary else {
                    return .failure(BackendError.dataSerialization(reason:"json to nsdictionary error"))
                }
                
                print(resultDic)
                
                guard let code = resultDic["code"] as? Int else {
                    return .failure(BackendError.dataSerialization(reason:"sever replay error"))
                }
                
                if code > 0 {
                    // Session error
                    if code >= 40000 && code < 50000 {
                        return .failure(BackendError.sessionError)
                    }
                    
                    let msg = resultDic["msg"] as? String ?? "unknow server error"
                    return .failure(BackendError.bussinessError(code:code, msg:msg))
                }
                
                let resultData = resultDic["data"]
                
                let JSONToMap: Any?
                if let keyPath = keyPath , keyPath.isEmpty == false {
                    JSONToMap = (resultData as AnyObject).value(forKeyPath: keyPath)
                } else {
                    JSONToMap = resultData
                }
                
                if let object = object {
                    _ = Mapper<T>().map(JSONObject: JSONToMap, toObject: object)
                    return .success(object)
                } else if let parsedObject = Mapper<T>().map(JSONObject: JSONToMap){
                    return .success(parsedObject)
                }
                
                return .failure(BackendError.dataSerialization(reason: "object mapper failed"))
            case let .failure(error):
                return .failure(BackendError.jsonSerialization(error: error as NSError))
            }
        }
    }
    
    
    @discardableResult
    public func responseObject<T: Mappable>(_ queue: DispatchQueue? = nil, keyPath: String? = nil, mapToObject object: T? = nil, context: MapContext? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: DataRequest.ObjectMapperSerializer(keyPath, mapToObject: object, content: context), completionHandler: { (response: DataResponse<T>) in
            switch response.result {
            case .success(_):
                break
            case let .failure(error):
                switch error as! BackendError {
                case .sessionError:
//                    S4SConfig.globalSessionErrorHandler()
                    break
                default:
                    break
                }
                break
            }
            completionHandler(response)
        })
    }
    
    
    public static func ObjectMapperArraySerializer<T: Mappable>(_ keyPath: String?, context: MapContext? = nil) -> DataResponseSerializer<[T]> {
        return DataResponseSerializer { request, response, data, error in
            guard error == nil else {
                return .failure(BackendError.network(error: error! as NSError))
            }
            
            guard let _ = data else {
                let failureReason = "Data could not be serialized. Input data was nil."
                return .failure(BackendError.dataSerialization(reason: failureReason))
            }
            
            let JSONResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            
            switch result {
            case let .success(value):
                guard let resultDic = value as? NSDictionary else {
                    return .failure(BackendError.dataSerialization(reason:"json to nsdictionary error"))
                }
                
                guard let code = resultDic["code"] as? Int else {
                    return .failure(BackendError.dataSerialization(reason:"sever replay error"))
                }
                
                if code > 0 {
                    // Session error
                    if code >= 40000 && code < 50000 {
                        return .failure(BackendError.sessionError)
                    }
                    
                    let msg = resultDic["msg"] as? String ?? "unknow server error"
                    return .failure(BackendError.bussinessError(code:code, msg:msg))
                }
                
                let JSONToMap: Any?
                if let keyPath = keyPath , keyPath.isEmpty == false {
                    JSONToMap = (resultDic["data"] as AnyObject).value(forKeyPath: keyPath)
                } else {
                    JSONToMap = resultDic["data"]
                }
                
                print(resultDic)
                
                if JSONToMap is NSNull {
                    return .success([])
                }
                
                if let parsedObject = Mapper<T>().mapArray(JSONObject: JSONToMap){
                    return .success(parsedObject)
                }
                return .failure(BackendError.dataSerialization(reason: "ObjectMapper failed to serialize response"))
            case let .failure(error):
                return .failure(BackendError.jsonSerialization(error: error as NSError))
            }
        }
    }
    
    /**
     Adds a handler to be called once the request has finished.
     
     - parameter queue: The queue on which the completion handler is dispatched.
     - parameter keyPath: The key path where object mapping should be performed
     - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped by ObjectMapper.
     
     - returns: The request.
     */
    @discardableResult
//    public func responseArray<T: Mappable>(_ queue: DispatchQueue? = nil, keyPath: String? = nil, context: MapContext? = nil, completionHandler: @escaping (DataResponse<[T]>) -> Void) -> Self {
//        return response(queue: queue, responseSerializer: DataRequest.ObjectMapperArraySerializer(keyPath, context: context), completionHandler: { (response: DataResponse<[T]>) in
//            switch response.result {
//            case .success(_):
//                break
//            case let .failure(error):
//                switch error as! BackendError {
//                case .sessionError:
////                    S4SConfig.globalSessionErrorHandler()
//                    break
//                default:
//                    break
//                }
//                break
//            }
//            completionHandler(response)
//        })
//    }
//
    
    public static func BoolSerializer(_ keyPath: String?, context: MapContext? = nil) -> DataResponseSerializer<Bool> {
        return DataResponseSerializer { request, response, data, error in
            guard error == nil else { return .failure(BackendError.network(error: error! as NSError)) }
            
            guard let _ = data else {
                let failureReason = "Data could not be serialized. Input data was nil."
                return .failure(BackendError.dataSerialization(reason: failureReason))
            }
            
            let JSONResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case let .success(value):
                guard let resultDic = value as? NSDictionary else {
                    return .failure(BackendError.dataSerialization(reason:"json to nsdictionary error"))
                }
                
                guard let code = resultDic["code"] as? Int else {
                    return .failure(BackendError.dataSerialization(reason:"sever replay error"))
                }
                
                if code > 0 {
                    // Session error
                    if code >= 40000 && code < 50000 {
                        return .failure(BackendError.sessionError)
                    }
                    
                    let msg = resultDic["msg"] as? String ?? "unknow server error"
                    return .failure(BackendError.bussinessError(code:code, msg:msg))
                }
                
                if let string = resultDic["data"] as? Bool {
                    print(string)
                    return .success(string)
                }
                
                return .failure(BackendError.dataSerialization(reason: "object mapper failed"))
            case let .failure(error):
                return .failure(BackendError.jsonSerialization(error: error as NSError))
            }
        }
    }
    
    
    @discardableResult
    public func responseBool(_ queue: DispatchQueue? = nil, keyPath: String? = nil,  context: MapContext? = nil, completionHandler: @escaping (DataResponse<Bool>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: DataRequest.BoolSerializer(keyPath, context: context), completionHandler: { (response: DataResponse<Bool>) in
            switch response.result {
            case .success(_):
                break
            case let .failure(error):
                switch error as! BackendError {
                case .sessionError:
//                    S4SConfig.globalSessionErrorHandler()
                    break
                default:
                    break
                }
                break
            }
            completionHandler(response)
        })
    }
    
    public static func StringSerializer(_ keyPath: String?, context: MapContext? = nil) -> DataResponseSerializer<String> {
        return DataResponseSerializer { request, response, data, error in
            guard error == nil else { return .failure(BackendError.network(error: error! as NSError)) }
            
            guard let _ = data else {
                let failureReason = "Data could not be serialized. Input data was nil."
                return .failure(BackendError.dataSerialization(reason: failureReason))
            }
            
            let JSONResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case let .success(value):
                guard let resultDic = value as? NSDictionary else {
                    return .failure(BackendError.dataSerialization(reason:"json to nsdictionary error"))
                }
                
                guard let code = resultDic["code"] as? Int else {
                    return .failure(BackendError.dataSerialization(reason:"sever replay error"))
                }
                
                if code > 0 {
                    // Session error
                    if code >= 40000 && code < 50000 {
                        return .failure(BackendError.sessionError)
                    }
                    
                    let msg = resultDic["msg"] as? String ?? "unknow server error"
                    return .failure(BackendError.bussinessError(code:code, msg:msg))
                }
                
                if let string = resultDic["data"] as? String {
                    print(string)
                    return .success(string)
                }
                
                return .failure(BackendError.dataSerialization(reason: "object mapper failed"))
            case let .failure(error):
                return .failure(BackendError.jsonSerialization(error: error as NSError))
            }
        }
    }
    
    @discardableResult
    public func responseS4SString(_ queue: DispatchQueue? = nil, keyPath: String? = nil, context: MapContext? = nil, completionHandler: @escaping (DataResponse<String>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: DataRequest.StringSerializer(keyPath, context: context), completionHandler: { (response: DataResponse<String>) in
            switch response.result {
            case .success(_):
                break
            case let .failure(error):
                switch error as! BackendError {
                case .sessionError:
//                    S4SConfig.globalSessionErrorHandler()
                    break
                default:
                    break
                }
                break
            }
            completionHandler(response)
        })
    }
    
    public static func IntSerializer(_ keyPath: String?, context: MapContext? = nil) -> DataResponseSerializer<Int> {
        return DataResponseSerializer { request, response, data, error in
            guard error == nil else { return .failure(BackendError.network(error: error! as NSError)) }
            
            guard let _ = data else {
                let failureReason = "Data could not be serialized. Input data was nil."
                return .failure(BackendError.dataSerialization(reason: failureReason))
            }
            
            let JSONResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case let .success(value):
                guard let resultDic = value as? NSDictionary else {
                    return .failure(BackendError.dataSerialization(reason:"json to nsdictionary error"))
                }
                
                guard let code = resultDic["code"] as? Int else {
                    return .failure(BackendError.dataSerialization(reason:"sever replay error"))
                }
                
                if code > 0 {
                    // Session error
                    if code >= 40000 && code < 50000 {
                        return .failure(BackendError.sessionError)
                    }
                    
                    let msg = resultDic["msg"] as? String ?? "unknow server error"
                    return .failure(BackendError.bussinessError(code:code, msg:msg))
                }
                
                if let intValue = resultDic["data"] as? Int {
                    print(intValue)
                    return .success(intValue)
                }
                
                return .failure(BackendError.dataSerialization(reason: "object mapper failed"))
            case let .failure(error):
                return .failure(BackendError.jsonSerialization(error: error as NSError))
            }
        }
    }
    
    @discardableResult
    public func responseInt(_ queue: DispatchQueue? = nil, keyPath: String? = nil, context: MapContext? = nil, completionHandler: @escaping (DataResponse<Int>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: DataRequest.IntSerializer(keyPath, context: context), completionHandler: { (response: DataResponse<Int>) in
            switch response.result {
            case .success(_):
                break
            case let .failure(error):
                switch error as! BackendError {
                case .sessionError:
//                    S4SConfig.globalSessionErrorHandler()
                    break
                default:
                    break
                }
                break
            }
            completionHandler(response)
        })
    }
}
