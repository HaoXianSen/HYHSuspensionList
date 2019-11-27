//
//  HYHSegmentModel.h
//  HYHSuspensionList_Example
//
//  Created by harry on 2019/11/27.
//  Copyright © 2019 1335430614@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYHSegmentModel : NSObject

@property (nonatomic, copy)   NSString *title;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *heighlightColor;

@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) BOOL heighlighted;

- (instancetype)initWithTitle:(NSString *)title;
+ (instancetype)segmentModelWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
