//
//  HYHSupensionView.m
//  HYHSuspensionList
//
//  Created by harry on 2019/7/29.
//

#import "HYHSuspensionView.h"
#import "HYHInnerTableViewCell.h"
#import "HYHSuspensionViewDefine.h"
#import "HYHTableView.h"

static NSString *kCellId = @"HYH_CELL_IDENTIFIER";

@interface HYHSuspensionView()<UITableViewDataSource, UITableViewDelegate, HYHInnerTableViewCellDelegate>

@property (nonatomic, weak) HYHTableView *tableView;
@property (nonatomic, weak) UIScrollView *innerScrollView;

@property (nonatomic, assign) CGFloat rowHeight;

@property (nonatomic, assign) BOOL itemScrollViewCanScroll;

@end

@implementation HYHSuspensionView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initailize];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initailize];
    }
    return self;
}

- (void)initailize {
    
    _currentIndex = 0;
    
    HYHTableView *tableView = [[HYHTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:HYHInnerTableViewCell.class forCellReuseIdentifier:kCellId];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self addSubview:tableView];
    _tableView = tableView;
}

- (void)setDelegate:(id<HYHSuspensionViewDelegate>)delegate {
    _delegate = delegate;
}

- (void)setDataSource:(id<HYHSuspensionViewDataSource>)dataSource {
    _dataSource = dataSource;
    self.tableView.tableHeaderView = [self.dataSource suspensionViewHeaderView:self];
//     _rowHeight = self.bounds.size.height - [self.dataSource suspensionViewHeaderView:self].bounds.size.height - [self tableView:self.tableView heightForHeaderInSection:0] - HYH_BOTTOM_HEIGHT;
     _rowHeight = self.bounds.size.height + HYH_BOTTOM_HEIGHT;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.tableView.frame = self.bounds;
}

#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYHInnerTableViewCell *cell = (HYHInnerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellId];
    cell.delegate = self;
    NSInteger itemsCount = [self.dataSource suspensionViewNumberOfItems:self];
    CGFloat w = self.tableView.bounds.size.width;
    CGFloat h = [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.scrollView.contentSize = CGSizeMake(itemsCount * self.tableView.bounds.size.width, [self tableView:tableView heightForRowAtIndexPath:indexPath]);
    CGRect rect = {CGPointZero, cell.scrollView.contentSize};
    UIView *contentView = [[UIView alloc] initWithFrame:rect];
    [cell.scrollView addSubview:contentView];
    
    for (int i = 0; i < itemsCount; i++) {
        id<HYHItemProtocol> item = [self.dataSource suspensionView:self controllerForSliderAtIndex:i];
        if ([item isKindOfClass:UIViewController.class]) {
            UIViewController *currentViewController = [self.dataSource suspensionViewAddedViewController:self];
            UIViewController *controller = (UIViewController *)item;
            [controller willMoveToParentViewController:currentViewController];
            [currentViewController addChildViewController:controller];
            [controller didMoveToParentViewController:currentViewController];
            
        }
        [item setItemScrollViewDidScroll:^(UIScrollView * _Nonnull scroll) {
            [self itemScrollViewDidScroll:scroll];
        }];
        UIView *containerView = item.containerView;
        containerView.frame = CGRectMake(i * w, 0, w, h);
        [contentView addSubview:containerView];
    }
    self.innerScrollView = cell.scrollView;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self.dataSource suspensionViewSegmentView:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self.dataSource suspensionViewsSegementViewHeight:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _rowHeight;
}

#pragma mark - HYHInnerTableViewCellDelegate
- (void)innerTableViewCell:(HYHInnerTableViewCell *)cell scrolledToPageIndex:(NSInteger)index {
    self.currentIndex = index;
//    UIScrollView *scrollView = [self.dataSource suspensionView:self controllerForSliderAtIndex:index].scrollView;
//    if (scrollView.contentSize.height > [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]) {
//        if (scrollView.contentSize.height <= self.tableView.bounds.size.height + HYH_BOTTOM_HEIGHT) {
//            self.rowHeight = scrollView.contentSize.height + HYH_BOTTOM_HEIGHT;
//        } else {
//            self.rowHeight = self.tableView.bounds.size.height + HYH_BOTTOM_HEIGHT;
//        }
//        [self.tableView reloadData];
//    } else {
//        self.rowHeight = self.bounds.size.height - [self.dataSource suspensionViewHeaderView:self].bounds.size.height - [self tableView:self.tableView heightForHeaderInSection:0] - HYH_BOTTOM_HEIGHT;
//        [self.tableView reloadData];
//    }
    if ([self.delegate respondsToSelector:@selector(suspensionView:didChangeSlidePageIndex:)]) {
        [self.delegate suspensionView:self didChangeSlidePageIndex:self.currentIndex];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGRect maxScrollRect = [self.tableView rectForHeaderInSection:0];
    CGFloat maxY = maxScrollRect.origin.y;
    self.tableView.canScroll = (offsetY < maxY) && !self.itemScrollViewCanScroll;
    if (!self.tableView.canScroll) {
        [scrollView setContentOffset:CGPointMake(0, maxY)];
    }
}

- (void)itemScrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    self.itemScrollViewCanScroll = (offsetY >  0) && !self.tableView.canScroll;
    if (self.tableView.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
}

@end
