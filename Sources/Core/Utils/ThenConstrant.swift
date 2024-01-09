//
//  Constrant.swift
//  ThenFoundation
//
//  Created by ghost on 2023/2/21.
//

import Foundation

/*
 机型                     尺寸   逻辑分辨率   设备分辨率     缩放因子 像素密度(PPI)
 5(s/se)                 4.0    320×568    640×1136     @2x    326
 6(s)/7/8/se2/se3        4.7    375×667    750×1334     @2x    326
 6 Plus/7 Plus/8 Plus    5.5    414×736    1080×1920    @3x    401
 X/XS/11Pro              5.8    375×812    1125×2436    @3x    458
 XR/11                   6.1    414×896    828×1792     @2x    326
 XS Max/11 Pro Max       6.5    414×896    1242×2688    @3x    458
 12Mini/13Mini           5.4    375×812    1080×2340    @3x    476
 12/13/14/12Prp/13Pro    6.1    390×844    1170×2532    @3x    460
 12PM/13PM/14Plus        6.7    428×926    1284×2778    @3x    458
 14Pro/15/15pro          6.1    393x852    1179x2556    @3x    460
 14PM/15PM/15Plus        6.7    430x932    1290x2796    @3x    460
 */


#if DEBUG
public let isDebug:    Bool = true
#else
public let isDebug:    Bool = false
#endif

public let isRelease:  Bool = !isDebug

/// print address of struct types
/// the p mast be var
public func logStructPointer<T>(_ p: UnsafePointer<T>) {
    print(p)
}

/// print address of class type
public func logClassPointer(_ p: AnyObject) {
    print(Unmanaged.passUnretained(p).toOpaque())
}

//
private class Constrant {
  
    static let shared = Constrant()
    
    lazy var dateformatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss SSS"
        return formatter
    }()
}

/// 格式化打印: 打印应该有项目本身去配置, 不需要三方库来提供
func printlog<T>(_ message: T,
                 file: String = #file,
                 line: Int = #line,
                 method: String = #function) {
    let date = Constrant.shared.dateformatter.string(from: Date())
    let text = "[THEN] [\(date)] [\((file as NSString).lastPathComponent) line: \(line), method: \(method)]: \n\(message)"
    if isDebug {
        print("\(text)")
    }
}
