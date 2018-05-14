//
//  Observable+ObjectMapper.swift
//  S4SFinancialClient
//
//  Created by zikong on 2017/5/31.
//  Copyright © 2017年 zikong. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper
import SVProgressHUD

public extension Response {
    
    public func mapObject<T: BaseMappable>(_ type: T.Type, keyPath: String? = nil, context: MapContext? = nil, autoHandleSessionError: Bool = true) throws -> T {
        guard let topResult = try mapJSON() as? [String: Any] else {
            throw NetError.jsonMappingError
        }
        guard let flag = topResult["flag"] as? String else {
            throw NetError.jsonMappingError
        }
        let code = NSString.init(string: flag).integerValue
        let msg = topResult["message"] as? String ?? "unknow server error"
        if code > 0 {
            if code != 2000{
                throw NetError.sessionError(resultCode: code, resultMsg: msg)
            }
        }
        var data = topResult["result"]
        if let keyPath = keyPath, !keyPath.isEmpty {
            data = (data as AnyObject).value(forKeyPath: keyPath)
        }
        
        guard let object = Mapper<T>(context: context).map(JSONObject: data) else {
            throw NetError.sessionError(resultCode: code, resultMsg: msg)
//            return
        }
        
        return object
    }
    
    public func mapiOSObject<T: BaseMappable>(_ type: T.Type, keyPath: String? = nil, context: MapContext? = nil, autoHandleSessionError: Bool = true) throws -> T {
        guard let topResult = try mapJSON() as? [String: Any] else {
            throw NetError.jsonMappingError
        }

        
        guard let object = Mapper<T>(context: context).map(JSONObject: topResult) else {
            throw NetError.sessionError(resultCode: 404, resultMsg: "msg")
            //            return
        }
        
        return object
    }
    
    public func mapArray<T: BaseMappable>(_ type: T.Type, keyPath: String? = nil, context: MapContext? = nil, autoHandleSessionError: Bool = true) throws -> [T] {
        
        guard let topResult = try mapJSON() as? [String: Any] else {
            throw NetError.jsonMappingError
        }
        
        var data = topResult["message"]
        if let keyPath = keyPath, !keyPath.isEmpty {
            data = (data as AnyObject).value(forKeyPath: keyPath)
        }
        
        if data is NSNull {
            return []
        }
        
        guard let array = Mapper<T>(context: context).mapArray(JSONObject: data) else {
            throw NetError.jsonMappingError
        }
        
        return array
    }
    
    public func mapS4SString(keyPath: String? = nil, context: MapContext? = nil, autoHandleSessionError: Bool = true) throws -> String {
        guard let topResult = try mapJSON() as? [String: Any] else {
            throw NetError.jsonMappingError
        }
        
        guard let code = topResult["code"] as? Int else {
            throw NetError.jsonMappingError
        }
        
        if code > 0 {
            let msg = topResult["msg"] as? String ?? "unknow server error"
            if code >= 40000 && code < 50000 {
                if autoHandleSessionError {
//                    S4SConfig.globalSessionErrorHandler()
                    throw NetError.noNeedHandleError
                }
                else {
                    throw NetError.sessionError(resultCode: code, resultMsg: msg)
                }
            }
            throw NetError.bizError(resultCode: code, resultMsg: msg)
        }
        
        var data = topResult["data"]
        if let keyPath = keyPath, !keyPath.isEmpty {
            data = (data as AnyObject).value(forKeyPath: keyPath)
        }
        
        guard let string = data as? String else {
            throw NetError.jsonMappingError
        }
        
        return string
    }
    
    public func mapS4SBool(keyPath: String? = nil, context: MapContext? = nil, autoHandleSessionError: Bool = true) throws -> Bool {
        guard let topResult = try mapJSON() as? [String: Any] else {
            throw NetError.jsonMappingError
        }
        
        guard let code = topResult["code"] as? Int else {
            throw NetError.jsonMappingError
        }
        
        if code > 0 {
            let msg = topResult["msg"] as? String ?? "unknow server error"
            if code >= 40000 && code < 50000 {
                if autoHandleSessionError {
//                    S4SConfig.globalSessionErrorHandler()
                    throw NetError.noNeedHandleError
                }
                else {
                    throw NetError.sessionError(resultCode: code, resultMsg: msg)
                }
            }
            throw NetError.bizError(resultCode: code, resultMsg: msg)
        }
        
        var data = topResult["data"]
        if let keyPath = keyPath, !keyPath.isEmpty {
            data = (data as AnyObject).value(forKeyPath: keyPath)
        }
        
        guard let bool = data as? Bool else {
            throw NetError.jsonMappingError
        }
        
        return bool
    }
    
}


// MARK: - ImmutableMappable
public extension Response {
    
    public func mapObject<T: ImmutableMappable>(_ type: T.Type, keyPath: String? = nil, context: MapContext? = nil, autoHandleSessionError: Bool = true) throws -> T {
        guard let topResult = try mapJSON() as? [String: Any] else {
            throw NetError.jsonMappingError
        }
        
        guard let code = topResult["flag"] as? Int else {
            throw NetError.jsonMappingError
        }
        
        if code > 0 {
            let msg = topResult["message"] as? String ?? "unknow server error"
            if code >= 40000 && code < 50000 {
                if autoHandleSessionError {
//                    S4SConfig.globalSessionErrorHandler()
                    throw NetError.noNeedHandleError
                }
                else {
                    throw NetError.sessionError(resultCode: code, resultMsg: msg)
                }
            }
            throw NetError.bizError(resultCode: code, resultMsg: msg)
        }
        
        var data = topResult["result"]
        if let keyPath = keyPath, !keyPath.isEmpty {
            data = (data as AnyObject).value(forKeyPath: keyPath)
        }
        
        guard let object = Mapper<T>(context: context).map(JSONObject: data) else {
            throw NetError.jsonMappingError
        }
        return object
    }
    
    public func mapArray<T: ImmutableMappable>(_ type: T.Type, keyPath: String? = nil, context: MapContext? = nil, autoHandleSessionError: Bool = true) throws -> [T] {
        guard let topResult = try mapJSON() as? [String: Any] else {
            throw NetError.jsonMappingError
        }
        
        guard let code = topResult["code"] as? Int else {
            throw NetError.jsonMappingError
        }
        
        if code > 0 {
            let msg = topResult["msg"] as? String ?? "unknow server error"
            if code >= 40000 && code < 50000 {
                if autoHandleSessionError {
//                    S4SConfig.globalSessionErrorHandler()
                    throw NetError.noNeedHandleError
                }
                else {
                    throw NetError.sessionError(resultCode: code, resultMsg: msg)
                }
            }
            throw NetError.bizError(resultCode: code, resultMsg: msg)
        }
        
        var data = topResult["data"]
        if let keyPath = keyPath, !keyPath.isEmpty {
            data = (data as AnyObject).value(forKeyPath: keyPath)
        }
        
        if data is NSNull {
            return []
        }
        
        guard let array = Mapper<T>(context: context).mapArray(JSONObject: data) else {
            throw NetError.jsonMappingError
        }
        
        return array
    }
    
}


/// Extension for processing Responses into Mappable objects through ObjectMapper
public extension ObservableType where E == Response {
    
    public func mapObject<T: BaseMappable>(_ type: T.Type, keyPath: String? = nil, context: MapContext? = nil, autoHandleSessionError: Bool = true) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(try response.mapObject(T.self, keyPath: keyPath, context: context, autoHandleSessionError: autoHandleSessionError))
        }
    }
    
    public func mapiOSObject<T: BaseMappable>(_ type: T.Type, keyPath: String? = nil, context: MapContext? = nil, autoHandleSessionError: Bool = true) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(try response.mapiOSObject(T.self, keyPath: keyPath, context: context, autoHandleSessionError: autoHandleSessionError))
        }
    }
    
    public func mapArray<T: BaseMappable>(_ type: T.Type, keyPath: String? = nil, context: MapContext? = nil, autoHandleSessionError: Bool = true) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            return Observable.just(try response.mapArray(T.self, keyPath: keyPath, context: context, autoHandleSessionError: autoHandleSessionError))
        }
    }
    
    public func mapS4SString(keyPath: String? = nil, context: MapContext? = nil, autoHandleSessionError: Bool = true) -> Observable<String> {
        return flatMap { response -> Observable<String> in
            return Observable.just(try response.mapS4SString(keyPath: keyPath, context: context, autoHandleSessionError: autoHandleSessionError))
        }
    }
    
    public func mapS4SBool(keyPath: String? = nil, context: MapContext? = nil, autoHandleSessionError: Bool = true) -> Observable<Bool> {
        return flatMap { response -> Observable<Bool> in
            return Observable.just(try response.mapS4SBool(keyPath: keyPath, context: context, autoHandleSessionError: autoHandleSessionError))
        }
    }
}


// MARK: - ImmutableMappable
public extension ObservableType where E == Response {
    
    public func mapObject<T: ImmutableMappable>(_ type: T.Type, keyPath: String? = nil, context: MapContext? = nil, autoHandleSessionError: Bool = true) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(try response.mapObject(T.self, keyPath: keyPath, context: context, autoHandleSessionError: autoHandleSessionError))
        }
    }
    
    public func mapArray<T: ImmutableMappable>(_ type: T.Type, keyPath: String? = nil, context: MapContext? = nil, autoHandleSessionError: Bool = true) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            return Observable.just(try response.mapArray(T.self, keyPath: keyPath, context: context, autoHandleSessionError: autoHandleSessionError))
        }
    }
    
    
    
}
