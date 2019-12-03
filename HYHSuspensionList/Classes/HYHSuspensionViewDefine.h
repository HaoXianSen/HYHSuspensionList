//
//  HYHSuspensionViewDefine.h
//  FBSnapshotTestCase
//
//  Created by harry on 2019/7/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define HYH_BOTTOM_HEIGHT (HYH_IS_IPHONEX_OR_LATER ? 34.f : 0.0f)
#define HYH_IS_IPHONEX_OR_LATER ([[UIApplication sharedApplication] statusBarFrame].size.height > 20.0f)

void safe_callDelegate(id delegate, SEL selector, id param, ...);

NS_ASSUME_NONNULL_END
