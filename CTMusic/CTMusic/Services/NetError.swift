//
//  NetError.swift
//  S4SUserClient
//
//  Created by 施胡炜 on 2017/8/10.
//  Copyright © 2017年 zikong. All rights reserved.
//

import UIKit
import Moya

enum NetError: Swift.Error {
    case sessionError(resultCode: Int?, resultMsg: String?)
    case jsonMappingError
    case noNeedHandleError
    case bizError(resultCode: Int?, resultMsg: String?)
}

extension NetError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .sessionError(_, let resultMsg):
            return resultMsg
        case .jsonMappingError:
            return "服务端返回对象解析错误"
        case .noNeedHandleError:
            return nil
        case .bizError( _, let resultMsg):
            return resultMsg
        }
    }
}
