//
//  NSDictionary+GJLRuntime.m
//
//  Created by GJL on 2022/11/10.
//  Copyright © 2022. All rights reserved.
//

#import "NSDictionary+GJLRuntime.h"
#import <objc/runtime.h>

@implementation NSDictionary (GJLRuntime)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class dictCls = NSClassFromString(@"__NSPlaceholderDictionary");
        Method original_init = class_getInstanceMethod(dictCls, @selector(initWithObjects:forKeys:count:));
        Method replace_init = class_getInstanceMethod(dictCls, @selector(gjl_swizzing_initWithObjects:forKeys:count:));
        method_exchangeImplementations(original_init, replace_init);
    });
}
- (instancetype)gjl_swizzing_initWithObjects:(const id _Nonnull [_Nullable])objects forKeys:(const id <NSCopying> _Nonnull [_Nullable])keys count:(NSUInteger)cnt{
    
    if (cnt == 0) {
        return [self gjl_swizzing_initWithObjects:objects forKeys:keys count:0];
    }
    if (!objects) {
        NSLog(@"objects is nil");
        return nil;
    }
    if (!keys) {
        NSLog(@"keys is nil");
        return nil;
    }
    
    // 指向objects初始位置
    // 指向keys初始位置
    NSUInteger keyCnt = 0;
    NSUInteger valueCnt = 0;
    // 遍历找到为key nil的位置
    for (   ; valueCnt < cnt; valueCnt ++, objects++) {
        if (*objects == 0)
        {
            break;
        }
    }
    // 遍历找到为key nil的位置
    for (   ; keyCnt < cnt; keyCnt ++, keys++) {
        if (*keys == 0) // 遍历找到为key nil的位置
        {
            break;
        }
    }
    // 找到最小值
    //cnt 不能越界
    NSUInteger minCnt = MIN(keyCnt, valueCnt);
    NSInteger newCnt = MIN(minCnt, cnt);
    
    for (int i = 0; i<valueCnt; i++) {
        objects--;
    }
    for (int i = 0; i<keyCnt; i++) {
        keys--;
    }
    
    return [self gjl_swizzing_initWithObjects:objects forKeys:keys count:newCnt];
}
@end
