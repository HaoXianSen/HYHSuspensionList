//
//  HYHSupensionView.h
//  HYHSuspensionList
//
//  Created by harry on 2019/7/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HYHSuspensionViewDelegate, HYHSuspensionViewDataSource, HYHItemProtocol;

@interface HYHSuspensionView : UIView

@property (nonatomic, weak)id<HYHSuspensionViewDataSource> dataSource;
@property (nonatomic, weak)id<HYHSuspensionViewDelegate> delegate;

@property (nonatomic, assign) NSInteger currentIndex;


@end

@protocol HYHSuspensionViewDataSource <NSObject>

@required

- (UIViewController *)suspensionViewAddedViewController:(HYHSuspensionView *)suspensionView;

- (NSInteger)suspensionViewNumberOfItems:(HYHSuspensionView *)suspensionView;

- (UIView *)suspensionViewHeaderView:(HYHSuspensionView *)suspensionView;
- (UIView *)suspensionViewSegmentView:(HYHSuspensionView *)suspensionView;
- (CGFloat)suspensionViewsSegementViewHeight:(HYHSuspensionView *)suspensionView;

- (id<HYHItemProtocol>)suspensionView:(HYHSuspensionView *)suspensionView controllerForSliderAtIndex:(NSInteger)index;


@end

@protocol HYHSuspensionViewDelegate <NSObject>

- (void)suspensionView:(HYHSuspensionView *)suspensionView didChangeSlidePageIndex:(NSInteger)currentIndex;

@end

@protocol HYHItemProtocol <NSObject>

@required

@property (nonatomic, copy) void(^itemScrollViewDidScroll)(UIScrollView *scroll);

- (UIView *)containerView;
- (UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
