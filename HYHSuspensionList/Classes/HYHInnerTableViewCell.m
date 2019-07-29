//
//  HYHInnerTableViewCell.m
//  HYHSuspensionList
//
//  Created by harry on 2019/7/29.
//

#import "HYHInnerTableViewCell.h"

@interface HYHInnerTableViewCell ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

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
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:scrollView];
        _scrollView = scrollView;
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
    if (self.index != index) {
        self.index = index;
        if ([self.delegate respondsToSelector:@selector(innerTableViewCell:scrolledToPageIndex:)]) {
            [self.delegate innerTableViewCell:self scrolledToPageIndex:index];
        }
    }
}

@end
