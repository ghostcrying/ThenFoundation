//
//  StatisticsProtocol.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/21.
//

import Foundation

// MARK: 统计
public protocol ThenStatistisProtocol {
    
    func event()
    func event(_ attributes: [AnyHashable: Any]?)
    func event(product id: Int, duration: Int?)
    
    func beginlogPageView()
    func endedlogPageView()
}

extension ThenStatistisProtocol {
    
    func event() { }
    func event(_ attributes: [AnyHashable: Any]?) { }
    func event(product id: Int, duration: Int?) { }
    
    func beginlogPageView() { }
    func endedlogPageView() { }
}
