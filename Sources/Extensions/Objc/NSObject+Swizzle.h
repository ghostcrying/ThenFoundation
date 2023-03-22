//
//  NSObject+Swizzle.h
//  ThenFoundation
//
//  Created by ghost on 2018/3/19.
//

#import <Foundation/Foundation.h>

@interface NSObject(Swizzled)

/// 方法附加
+ (void)doSwizzle:(SEL)originalSelector with:(SEL)swizzledSelector;

@end
