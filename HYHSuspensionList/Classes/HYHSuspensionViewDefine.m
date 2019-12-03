//
//  HYHSuspensionViewDefine.m
//  FBSnapshotTestCase
//
//  Created by harry on 2019/7/29.
//

#import "HYHSuspensionViewDefine.h"

void  safe_callDelegate(id delegate, SEL selector, id param, ...) {
    if (![delegate respondsToSelector:selector]) {
        return;
    }
    va_list valist;
    va_start(valist, param);
    
    NSMethodSignature *signature = [delegate methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    NSUInteger args = [signature numberOfArguments];
    [invocation setArgument:(__bridge void * _Nonnull)(param) atIndex:2];
    
    for (int index = 3; index < args; index++) {
        if (va_arg(valist, id) == nil) {
            break;
        }
        id params = va_arg(valist, id);
        [invocation setArgument:(__bridge void * _Nonnull)(params) atIndex:index];
    }
    va_end(valist);
    [invocation setTarget:delegate];
    [invocation setSelector:selector];
    [invocation invoke];
}
