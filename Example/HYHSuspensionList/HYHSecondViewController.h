//
//  HYHSecondViewController.h
//  HYHSuspensionList_Example
//
//  Created by harry on 2019/7/29.
//  Copyright © 2019 1335430614@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HYHSuspensionView.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYHSecondViewController : UIViewController<HYHItemProtocol>

@property (nonatomic, copy) void(^itemScrollViewDidScroll)(UIScrollView *scroll);

@end

NS_ASSUME_NONNULL_END
