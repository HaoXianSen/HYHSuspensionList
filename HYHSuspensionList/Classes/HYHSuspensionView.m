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

@property (nonatomic, strong) NSMutableArray *itemsArray;

@property (nonatomic, assign) BOOL forceScrollToTop;
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
    _itemsArray = [NSMutableArray array];
    
    HYHTableView *tableView = [[HYHTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:HYHInnerTableViewCell.class forCellReuseIdentifier:kCellId];
    [self addSubview:tableView];
    _tableView = tableView;
}

- (void)setDelegate:(id<HYHSuspensionViewDelegate>)delegate {
    _delegate = delegate;
}

- (void)setDataSource:(id<HYHSuspensionViewDataSource>)dataSource {
    _dataSource = dataSource;
    self.tableView.tableHeaderView = [self.dataSource suspensionViewHeaderView:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.tableView.frame = self.bounds;
    self.tableView.rowHeight = _rowHeight == 0 ? self.bounds.size.height - [_dataSource suspensionViewsSegementViewHeight:self] : _rowHeight;
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
    CGFloat h = self.tableView.rowHeight;
    cell.scrollView.contentSize = CGSizeMake(itemsCount * self.tableView.bounds.size.width, self.tableView.rowHeight);
    CGRect rect = {CGPointZero, cell.scrollView.contentSize};
    cell.scrollContentView.frame = rect;
    if (self.itemsArray.count == 0) {
        [cell.scrollContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
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
            [cell.scrollContentView addSubview:containerView];
            [self.itemsArray addObject:item];
        }
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

#pragma mark - HYHInnerTableViewCellDelegate
- (void)innerTableViewCell:(HYHInnerTableViewCell *)cell didsSrolledToPageIndex:(NSInteger)index {
    self.currentIndex = index;
    if ([self.delegate respondsToSelector:@selector(suspensionView:didChangeSlidePageIndex:)]) {
        [self.delegate suspensionView:self didChangeSlidePageIndex:self.currentIndex];
    }
    if (index < self.itemsArray.count) {
        id<HYHItemProtocol> item = self.itemsArray[index];
        UIScrollView *scrollView = item.scrollView;
        if (scrollView) {
            [self changeCanScrollDistanceWithScrollView:scrollView];
        }
    }
}

- (void)innerTableViewCell:(HYHInnerTableViewCell *)cell willscrollToPageIndex:(NSInteger)index {
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGRect maxScrollRect = [self.tableView rectForHeaderInSection:0];
    CGFloat maxY = maxScrollRect.origin.y;
    self.tableView.canScroll = (offsetY < maxY) && !self.itemScrollViewCanScroll;
    if (!self.tableView.canScroll && !self.forceScrollToTop) {
        [scrollView setContentOffset:CGPointMake(0, maxY)];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.forceScrollToTop) {
        if (CGPointEqualToPoint(CGPointZero, scrollView.contentOffset) ) {
            self.forceScrollToTop = NO;
        }
    }
}

- (void)itemScrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    self.itemScrollViewCanScroll = (offsetY >  0) && !self.tableView.canScroll;
    if (self.tableView.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
}

- (void)changeCanScrollDistanceWithScrollView:(UIScrollView *)scrollView {
    UIView *headerView = [self.dataSource suspensionViewHeaderView:self];
    CGFloat segmentH = [self.dataSource suspensionViewsSegementViewHeight:self];
    CGFloat minCellH = self.bounds.size.height - headerView.bounds.size.height - segmentH - HYH_BOTTOM_HEIGHT;
    CGFloat scrollContentH = scrollView.contentSize.height;
    CGFloat maxRowHeight = self.bounds.size.height - segmentH;
    if (scrollContentH > minCellH) {
        if (scrollContentH < maxRowHeight) {
            self.rowHeight = scrollContentH;
            if (self.tableView.contentOffset.y >= headerView.bounds.size.height) {
                self.forceScrollToTop = YES;
                [self.tableView setContentOffset:CGPointZero];
            }
        } else {
            self.rowHeight = maxRowHeight;
        }
    } else {
        self.rowHeight = minCellH;
        self.forceScrollToTop = YES;
        [self.tableView setContentOffset:CGPointZero];
    }
    self.tableView.rowHeight = self.rowHeight;
    [self.tableView reloadData];
    if (CGPointEqualToPoint(CGPointZero, self.tableView.contentOffset)) {
        [scrollView setContentOffset:CGPointZero];
    }
}

@end