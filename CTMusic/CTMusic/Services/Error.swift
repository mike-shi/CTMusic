//
//  Error.swift
//  S4SUserClient
//
//  Created by zikong on 16/6/16.
//  Copyright © 2016年 zikong. All rights reserved.
//

import UIKit

enum BackendError: Error {
    case network(error: NSError)
    case dataSerialization(reason: String)
    case jsonSerialization(error: NSError)
    case objectSerialization(reason: String)
    case bussinessError(code:Int, msg:String)
    case sessionError
}

extension String {
    static func ErrorString(_ err: Error) -> String {
        if let error = err as? BackendError {
            switch error {
            case .network:
                return "网络链接失败，请稍候重试"
            case let .dataSerialization(str):
                return str
            case .jsonSerialization(_):
                return "服务端返回对象解析错误"
            case let .objectSerialization(str):
                return str
            case let .bussinessError(_, str):
                return str
            case .sessionError:
                return "会话已过期，请重新登录"
            }
        }
        return ""
    }
}



