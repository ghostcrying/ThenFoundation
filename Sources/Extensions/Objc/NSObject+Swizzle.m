//
//  NSObject+Swizzle.m
//  ThenFoundation
//
//  Created by ghost on 2018/3/19.
//

#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

@implementation NSObject(Swizzled)

+ (void)doSwizzle:(SEL)originalSelector with:(SEL)swizzledSelector {
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
