//
//  HYHTableView.h
//  HYHSuspensionList
//
//  Created by harry on 2019/7/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYHTableView : UITableView<UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL canScroll;

@end

NS_ASSUME_NONNULL_END
