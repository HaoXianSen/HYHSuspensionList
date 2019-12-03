//
//  HYHInnerTableViewCell.m
//  HYHSuspensionList
//
//  Created by harry on 2019/7/29.
//

#import "HYHInnerTableViewCell.h"
#import "HYHSuspensionViewDefine.h"

@interface HYHInnerTableViewCell ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIView *scrollContentView;

@property (nonatomic, assign) NSInteger index;

@end

@implementation HYHInnerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.bounces = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:scrollView];
        _scrollView = scrollView;
        
        CGRect rect = {CGPointZero, scrollView.contentSize};
        UIView *contentView = [[UIView alloc] initWithFrame:rect];
        [_scrollView addSubview:contentView];
        _scrollContentView = contentView;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat width = scrollView.bounds.size.width;
    NSInteger index = offsetX / (width * 0.5);
    if (index != _index) {
        self.index = index;
        if ([self.delegate respondsToSelector:@selector(innerTableViewCell:willScrollToPageIndex:)]) {
            [self.delegate innerTableViewCell:self willScrollToPageIndex:index];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat width = scrollView.bounds.size.width;
    NSInteger index = offsetX / width;
    self.index = index;
    if ([self.delegate respondsToSelector:@selector(innerTableViewCell:didsSrolledToPageIndex:)]) {
            [self.delegate innerTableViewCell:self didsSrolledToPageIndex:index];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    safe_callDelegate(self.delegate, @selector(innerTableViewCellWillBeiginDragging:), self);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    safe_callDelegate(self.delegate, @selector(innerTableViewCellDidEndDragging:), self);
}

@end
