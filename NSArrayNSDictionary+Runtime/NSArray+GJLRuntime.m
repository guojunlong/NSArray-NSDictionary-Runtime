//
//  NSArray+GJLRuntime.m
//
//  Created by GJL on 2022/11/10.
//  Copyright © 2022. All rights reserved.
//

#import "NSArray+GJLRuntime.h"
#import <objc/runtime.h>

@implementation NSArray (GJLRuntime)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //取值
        //objectAtIndex:
        Method original_get_value = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:));
        Method replace_get_value = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(gjl_swizzing_objectAtIndexI:));
        method_exchangeImplementations(original_get_value, replace_get_value);
        
        //array[index];
        Method original_get_value_1 = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndexedSubscript:));
        Method replace_get_value_1 = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(gjl_swizzing_objectAtIndexedSubscript:));
        method_exchangeImplementations(original_get_value_1, replace_get_value_1);
        
        Method original_get_2 = class_getInstanceMethod(objc_getClass("__NSArray0"), @selector(objectAtIndex:));
        Method replace_get_2 = class_getInstanceMethod(objc_getClass("__NSArray0"), @selector(gjl_swizzing_objectAtIndex0:));
        method_exchangeImplementations(original_get_2, replace_get_2);
        
        Method original_get_3 = class_getInstanceMethod(objc_getClass("__NSSingleObjectArrayI"), @selector(objectAtIndex:));
        Method replace_get_3 = class_getInstanceMethod(objc_getClass("__NSSingleObjectArrayI"), @selector(gjl_swizzing_objectAtIndexSingle:));
        method_exchangeImplementations(original_get_3, replace_get_3);
        
        Method original_get_4 = class_getInstanceMethod(objc_getClass("__NSPlaceholderArray"), @selector(objectAtIndex:));
        Method replace_get_4 = class_getInstanceMethod(objc_getClass("__NSPlaceholderArray"), @selector(gjl_swizzing_objectAtIndexPlaceholder:));
        method_exchangeImplementations(original_get_4, replace_get_4);
        
        //赋值
        Method original_init_1 = class_getInstanceMethod(objc_getClass("__NSPlaceholderArray"), @selector(initWithObjects:count:));
        Method replace_init_1 = class_getInstanceMethod(objc_getClass("__NSPlaceholderArray"), @selector(gjl_swizzing_initWithObjects:count:));
        method_exchangeImplementations(original_init_1, replace_init_1);
        
        
    });
}

#pragma mark objectAtIndex:
//__NSArrayI
- (id)gjl_swizzing_objectAtIndexI:(NSUInteger)index {
    
    if (![self judgeArrayIndex:index]) {
        return nil;
    }
    return [self gjl_swizzing_objectAtIndexI:index];
}
//补充
- (id)gjl_swizzing_objectAtIndexedSubscript:(NSInteger)index {
    if (![self judgeArrayIndex:index]) {
        return nil;
    }
    return [self gjl_swizzing_objectAtIndexedSubscript:index];
}

//__NSArray0
- (id)gjl_swizzing_objectAtIndex0:(NSUInteger)index {
    
    if (![self judgeArrayIndex:index]) {
        return nil;
    }
    return [self gjl_swizzing_objectAtIndex0:index];
}
//__NSSingleObjectArrayI
- (id)gjl_swizzing_objectAtIndexSingle:(NSUInteger)index {
    
    if (![self judgeArrayIndex:index]) {
        return nil;
    }
    return [self gjl_swizzing_objectAtIndexSingle:index];
}
//__NSPlaceholderArray
- (id)gjl_swizzing_objectAtIndexPlaceholder:(NSUInteger)index {
    NSLog(@"%s\n%s\n%@",class_getName(self.class),__func__,@"数组未初始化");
    return nil;
}
-(BOOL)judgeArrayIndex:(NSUInteger)index{
    
    if (!self.count || self.count == 0) {
        NSLog(@"%s\n%s\n%@",class_getName(self.class),__func__,@"数组为空");
        return NO;
    }
    else if (self.count-1 < index){
        NSLog(@"%s\n%s\n%@",class_getName(self.class),__func__,@"数组越界了");
        return NO;
    }
    return YES;
}

#pragma mark initWithObjects:count:
- (id)gjl_swizzing_initWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)cnt{
    for (int i = 0 ; i<cnt ; i++) {
        if (objects[i] == nil) {
            NSLog(@"数组第%d个参数为空",i);
            return nil;
        }
    }
    return [self gjl_swizzing_initWithObjects:objects count:cnt];
}


@end
