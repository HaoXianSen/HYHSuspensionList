//
//  HYHSegmentControl.h
//  HYHSuspensionList_Example
//
//  Created by harry on 2019/11/26.
//  Copyright © 2019 1335430614@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SegmentControlChangeBloc)(NSInteger currentIndex);

@interface HYHSegmentControl : UIView

@property (nonatomic, copy) NSArray<NSString *> *items;
@property (nonatomic, assign) NSInteger currentSelectedIndex;

@property (nonatomic, copy) SegmentControlChangeBloc indexChangeBloc;

/// default origin
@property (nonatomic, strong) UIColor *indicatorColor;
/// default YES
@property (nonatomic, assign) BOOL showIndicator;

- (instancetype)initWithFrame:(CGRect)frame itemTitles:(NSArray <NSString *> *)itemTitles;

@end

NS_ASSUME_NONNULL_END
