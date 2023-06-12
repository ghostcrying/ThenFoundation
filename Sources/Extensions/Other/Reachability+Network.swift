//
//  Reachability+Network.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/14.
//

import Foundation
import CoreTelephony

public let reachability = Reachability()!

extension Reachability: ThenExtensionCompatible { }

public extension ThenExtension where T == Reachability {
    
    /// 运营商
    var carrierName: String {
        return CTTelephonyNetworkInfo().subscriberCellularProvider?.carrierName ?? "none"
    }
    
    /// 网络环境
    var network: String {
        switch value.currentReachabilityStatus {
        case .notReachable:
            return "none"
        case .reachableViaWiFi:
            return "wifi"
        case .reachableViaWWAN:
            /// iOS12.0代码并未包含属性: CTTelephonyNetworkInfo().serviceCurrentRadioAccessTechnology[""], 其于iOS12.1修复
            guard let radio = CTTelephonyNetworkInfo().currentRadioAccessTechnology else {
                return "unknown"
            }
            switch radio {
            case CTRadioAccessTechnologyGPRS:           return "GPRS"
            case CTRadioAccessTechnologyEdge:           return "2.75G EDGE"
            case CTRadioAccessTechnologyWCDMA:          return "3G"
            case CTRadioAccessTechnologyHSDPA:          return "3.5G HSDPA"
            case CTRadioAccessTechnologyHSUPA:          return "3.5G HSUPA"
            case CTRadioAccessTechnologyCDMA1x:         return "2G"
            case CTRadioAccessTechnologyCDMAEVDORev0:   return "3G"
            case CTRadioAccessTechnologyCDMAEVDORevA:   return "3G"
            case CTRadioAccessTechnologyCDMAEVDORevB:   return "3G"
            case CTRadioAccessTechnologyeHRPD:          return "3.75G HRPD"
            case CTRadioAccessTechnologyLTE:            return "4G"
            default:
                if #available(iOS 14.1, *) {
                    switch radio {
                    case CTRadioAccessTechnologyNRNSA:  return "5G NSA"
                    case CTRadioAccessTechnologyNR:     return "5G"
                    default: break
                    }
                }
                return "undefined"
            }
        }
    }
}
