//
//  NSMutableDictionary+GJLRuntime.m
//
//  Created by GJL on 2022/11/10.
//  Copyright © 2022. All rights reserved.
//

#import "NSMutableDictionary+GJLRuntime.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (GJLRuntime)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class dictCls = NSClassFromString(@"__NSDictionaryM");
        Method original = class_getInstanceMethod(dictCls, @selector(setObject:forKey:));
        Method replace = class_getInstanceMethod(dictCls, @selector(gjl_swizzing_setObject:forKey:));
        method_exchangeImplementations(original, replace);
        
        //删
        Method original1 = class_getInstanceMethod(dictCls, @selector(removeObjectForKey:));
        Method replace1 = class_getInstanceMethod(dictCls, @selector(gjl_swizzing_removeObjectForKey:));
        method_exchangeImplementations(original1, replace1);
        
    });
}
-(void)gjl_swizzing_setObject:(id)aObject forKey:(id<NSCopying>)akey{
    
    if (!aObject) {
        NSLog(@"object is null");
        return;
    }
    if (!akey) {
        NSLog(@"key is null");
        return;
    }
    [self gjl_swizzing_setObject:aObject forKey:akey];
}
-(void)gjl_swizzing_removeObjectForKey:(id)akey{
    if (!akey) {
        NSLog(@"key is null");
        return;
    }
    [self gjl_swizzing_removeObjectForKey:akey];
}

@end
