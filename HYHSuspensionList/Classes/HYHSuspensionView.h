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
@property (nonatomic, strong)UIView *headerView;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, weak, readonly) UITableView *innerTableView;
/// default： NO
@property (nonatomic, assign) BOOL switchPageAnimated;

- (void)forceUpdateItemLayout;
- (void)reloadData;

@end

@protocol HYHSuspensionViewDataSource <NSObject>

@required

- (UIViewController *)suspensionViewAddedViewController:(HYHSuspensionView *)suspensionView;

- (NSInteger)suspensionViewNumberOfItems:(HYHSuspensionView *)suspensionView;

- (UIView *)suspensionViewSegmentView:(HYHSuspensionView *)suspensionView;

- (id<HYHItemProtocol>)suspensionView:(HYHSuspensionView *)suspensionView itemAtSlideIndex:(NSInteger)index;


@optional

- (UIView *)suspensionViewHeaderView:(HYHSuspensionView *)suspensionView __deprecated_msg("use @property headerView replace");
- (CGFloat)suspensionViewsSegementViewHeight:(HYHSuspensionView *)suspensionView      __deprecated_msg("API deprecated, user suspensionViewSegmentView: get segmentView height");

@end

@protocol HYHSuspensionViewDelegate <NSObject>

- (void)suspensionView:(HYHSuspensionView *)suspensionView didChangeSlidePageIndex:(NSInteger)currentIndex;

- (void)suspensionView:(HYHSuspensionView *)suspensionView willChangeSlidePageIndex:(NSInteger)currentIndex;

@end

@protocol HYHItemProtocol <NSObject>

@required

@property (nonatomic, copy) void(^itemScrollViewDidScroll)(UIScrollView *scroll);

- (UIView *)containerView;
- (UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
