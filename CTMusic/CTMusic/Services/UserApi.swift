//
//  UserApi.swift
//  S4SUserClient
//
//  Created by 施胡炜 on 2017/8/9.
//  Copyright © 2017年 zikong. All rights reserved.
//

import UIKit
import RxSwift
import Moya
import Alamofire

let policies: [String: ServerTrustPolicy] = [
    "user.api.mys4s.cn": .disableEvaluation,
    "dev.user.api.mys4s.cn": .disableEvaluation
]

let manager = Manager(
    configuration: URLSessionConfiguration.default,
    serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies)
)

let endpointClosure = { (target:UserApi ) -> Endpoint<UserApi> in
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    
    var newParam: [String: String] = [:]
    target.parameters?.forEach({
        newParam[$0.0] = String(describing: $0.1)
    })
    var headerFields: [String: String] = ["token": Constants.accessToken ?? "", "Content-Type": "application/x-www-form-urlencoded"]
    if target.path == "/api/Point/Trail" || target.path == "/api/Account/PutBindEqu" {
        headerFields = ["Authorization": "bearer " + Constants.accessToken!, "Content-Type": "applocation/json"]
    }
    
    return Endpoint<UserApi>(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: newParam).adding(newHTTPHeaderFields: headerFields)
}
let networkLogger = NetworkLoggerPlugin(verbose: true, responseDataFormatter: nil)

let apiProvider = RxMoyaProvider<UserApi>(endpointClosure: endpointClosure, manager: manager, plugins: [networkLogger])

enum UserApi {
    case appToken(password: String, userName: String)
    case lastPoint(cid: String)
    case alertList(date: String)
    case driveList(day: String)
    case driveDetail(beg: String, end: String)
    case getFance(cid: String)
    case setFance(param: [String: Any])
    case getSpeed()
    case setSpeed(cid:String, parameter: Int)
    case getStatues(initFlag: Int)
    case setShake(shakeFlag: Int)
    case setSafe(safeFlag: Int)
    case getMessage()
    case getHomePageInfo()
    case bindEquipment(param: [String: Any])
    case getShopNearby(lat: Double, lon: Double)
    case getAd()
}

extension UserApi: TargetType {

    var baseURL: URL {
        switch self {
        case .getShopNearby, .getAd, .getMessage:
            return URL(string: Constants.registUrl)!
        case .driveDetail,.bindEquipment:
            return URL(string: Constants.iOSBaseUrl)!
        default:
            return URL(string: Constants.baseUrl)!
        }
    }
    var path: String {
        switch self {
        case .appToken:
            return "/api/Token"
        case .lastPoint:
            return "/api/Point/Last"
        case .alertList:
            return "/loveApi/cheway/alert/getAlertsRecord.do"
        case .driveList:
            return "/loveApi/cheway/point/getDrivRecordOfOneDay.do"
        case .driveDetail:
            return "/api/Point/Trail"
        case .getFance:
            return "/loveApi/cheway/fances/getFances.do"
        case .setFance:
            return "/loveApi/cheway/fances/saveOrUpdateFances.do"
        case .setSpeed:
            return "/loveApi/cheway/setalarm/getAlertTypeSpeed.do"
        case .getSpeed:
            return "/loveApi/cheway/setalarm/getAlertTypeSpeeds.do"
        case .getStatues:
            return "/loveApi/cheway/newCmds/getStatus.do"
        case .setShake:
            return "/loveApi/cheway/newCmds/shake.do"
        case .setSafe:
            return "/loveApi/cheway/login/postSafeTcpcmds.do"
        case .getMessage:
            return "/message/all"
        case .getHomePageInfo:
            return "/loveApi/cheway/login/getHomepageInfo.do"
        case .bindEquipment:
            return "/api/Account/PutBindEqu"
        case .getShopNearby:
            return "/shop/nearby"
        case .getAd:
            return "/ad/get"
        }
    }
    var parameters: [String: Any]? {
        switch self {
        case .appToken(let password, let userName):
            return ["grant_type": "password", "password": password, "scope": "single","username": userName]
        case .lastPoint(let cid):
            return ["cid":cid]
        case .alertList(let date):
            return ["date" :date, "cid": Constants.cid]
        case .driveList(let day):
            return ["day": day, "cid": Constants.cid]
        case .driveDetail(let beg, let end):
            return ["cid": Constants.cid ,"beg": beg,"end": end]
        case .getFance(let cid):
            return ["cid": cid]
        case .setFance(let param):
            return param
        case .setSpeed(let cid, let parameter):
            return ["cid": cid, "parameter": parameter]
        case .getSpeed:
            return ["cid": Constants.cid]
        case .getStatues(let initFlag):
            return ["cid": Constants.cid, "initFlag": initFlag]
        case .setShake(let shakeFlag):
            return ["cid": Constants.cid, "shakeFlag": shakeFlag, "clientid": "安卓"]
        case .setSafe(let safeFlag):
            return ["cid": Constants.cid, "safeFlag": safeFlag]
        case .getMessage:
            return [:]
        case .getHomePageInfo:
            return ["cid": Constants.cid, "devinfo": 1, "devlogin": 1, "addflag": 1, "totalmile": 1, "devpower": 1]
        case .bindEquipment(let param):
            return param
        case .getShopNearby(let lat, let lon):
            return ["lat": lat, "lon": lon]
        case  .getAd():
            return [:]
        }
    }
    var sampleData: Data {
        switch self {
        default:
            return "{}".utf8Encoded
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .setFance:
            return .post
        case .setSpeed:
            return .post
        case .getSpeed:
            return .post
        case .getStatues:
            return .post
        case .setShake:
            return .post
        case .setSafe:
            return .post
        case .bindEquipment:
            return .put
        default:
            return .get
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        
        return JSONEncoding.default // Send parameters as JSON in request body
    }
    
    var task: Task {
        
        return .request
    }
}

private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
}
