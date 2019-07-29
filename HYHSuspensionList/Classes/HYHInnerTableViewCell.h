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

@property (nonatomic, weak) id<HYHInnerTableViewCellDelegate> delegate;

@end

@protocol HYHInnerTableViewCellDelegate <NSObject>

- (void)innerTableViewCell:(HYHInnerTableViewCell *)cell scrolledToPageIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
