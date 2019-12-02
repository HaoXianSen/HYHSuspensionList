//
//  HYHInnerTableViewCell.h
//  HYHSuspensionList
//
//  Created by harry on 2019/7/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HYHInnerTableViewCellDelegate;

@interface HYHInnerTableViewCell : UITableViewCell

@property (nonatomic, weak, readonly) UIScrollView *scrollView;
@property (nonatomic, weak, readonly) UIView *scrollContentView;

@property (nonatomic, weak) id<HYHInnerTableViewCellDelegate> delegate;

@end

@protocol HYHInnerTableViewCellDelegate <NSObject>

- (void)innerTableViewCell:(HYHInnerTableViewCell *)cell willScrollToPageIndex:(NSInteger)index;
- (void)innerTableViewCell:(HYHInnerTableViewCell *)cell didsSrolledToPageIndex:(NSInteger)index;
- (void)innerTableViewCellWillScroll:(HYHInnerTableViewCell *)cell;
- (void)innerTableViewCellDidScroll:(HYHInnerTableViewCell *)cell;

@end

NS_ASSUME_NONNULL_END
