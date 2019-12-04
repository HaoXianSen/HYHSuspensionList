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
@property (nonatomic, strong) UIView *segmentView;

@property (nonatomic, assign) CGFloat rowHeight;

@property (nonatomic, strong) NSMutableArray *itemsArray;

@property (nonatomic, assign) BOOL forceScrollToTop;

@property (nonatomic, assign, readonly) CGFloat maxScrollOffsetY;
@property (nonatomic, assign) CGFloat segmentHeight;
@property (nonatomic, assign) BOOL tableViewFixedOffset;
@property (nonatomic, assign) BOOL itemScrollViewFixedOffset;

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

- (void)initailize
{
    _currentIndex = 0;
    _itemsArray = [NSMutableArray array];
    
    HYHTableView *tableView = [[HYHTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:HYHInnerTableViewCell.class forCellReuseIdentifier:kCellId];
    [self addSubview:tableView];
    _tableView = tableView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self forceUpdateItemLayout];
    });
}

- (void)reloadData
{
    _segmentView = nil;
    [self.itemsArray removeAllObjects];
    [self.tableView reloadData];
}

- (void)setDelegate:(id<HYHSuspensionViewDelegate>)delegate
{
    _delegate = delegate;
}

- (void)setDataSource:(id<HYHSuspensionViewDataSource>)dataSource
{
    _dataSource = dataSource;
}

- (UITableView *)innerTableView
{
    return self.tableView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.tableView.frame = self.bounds;
    self.tableView.rowHeight = _rowHeight == 0 ? self.bounds.size.height - self.segmentHeight : _rowHeight;
}

- (void)setHeaderView:(UIView *)headerView {
    _headerView = headerView;
    self.tableView.tableHeaderView = headerView;
}

- (CGFloat)maxScrollOffsetY {
    CGFloat sectionHeaderY = [self.tableView rectForHeaderInSection:0].origin.y;
    return sectionHeaderY;
}

- (CGFloat)segmentHeight {
    if (_segmentView) {
        return self.segmentView.bounds.size.height;
    }
    _segmentView = [self.dataSource suspensionViewSegmentView:self];
    return _segmentView.bounds.size.height;
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
            id<HYHItemProtocol> item = [self.dataSource suspensionView:self itemAtSlideIndex:i];
            if ([item isKindOfClass:UIViewController.class]) {
                UIViewController *currentViewController = [self.dataSource suspensionViewAddedViewController:self];
                UIViewController *controller = (UIViewController *)item;
                [controller willMoveToParentViewController:currentViewController];
                [currentViewController addChildViewController:controller];
                [controller didMoveToParentViewController:currentViewController];
                
            }
            __weak typeof(self) weakSelf = self;
            [item setItemScrollViewDidScroll:^(UIScrollView * _Nonnull scroll) {
                [weakSelf itemScrollViewDidScroll:scroll];
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
    if (!_segmentView) {
        _segmentView = [self.dataSource suspensionViewSegmentView:self];
    }
    return _segmentView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.segmentHeight;
}

#pragma mark - HYHInnerTableViewCellDelegate

- (void)innerTableViewCell:(HYHInnerTableViewCell *)cell didsSrolledToPageIndex:(NSInteger)index {
    _currentIndex = index;
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

- (void)innerTableViewCell:(HYHInnerTableViewCell *)cell willScrollToPageIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(suspensionView:willChangeSlidePageIndex:)]) {
        [self.delegate suspensionView:self willChangeSlidePageIndex:self.currentIndex];
    }
}

- (void)innerTableViewCellWillBeiginDragging:(HYHInnerTableViewCell *)cell {
    self.tableView.scrollEnabled = NO;
}

- (void)innerTableViewCellDidEndDragging:(HYHInnerTableViewCell *)cell {
    self.tableView.scrollEnabled = YES;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.innerScrollView.scrollEnabled = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.tableViewFixedOffset = scrollView.contentOffset.y >= self.maxScrollOffsetY;
    if (self.tableViewFixedOffset || !self.itemScrollViewFixedOffset) {
        [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, self.maxScrollOffsetY)];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.forceScrollToTop) {
        if (CGPointEqualToPoint(CGPointZero, scrollView.contentOffset) ) {
            self.forceScrollToTop = NO;
        }
    }
    self.innerScrollView.scrollEnabled = YES;
}

- (void)itemScrollViewDidScroll:(UIScrollView *)scrollView {
    self.itemScrollViewFixedOffset = scrollView.contentOffset.y <= 0;
    if (!self.tableViewFixedOffset && self.itemScrollViewFixedOffset) {
        [scrollView setContentOffset:CGPointZero];
    }
    CGFloat segmentH = self.segmentHeight;
    CGFloat maxRowHeight = self.bounds.size.height - segmentH - HYH_BOTTOM_HEIGHT;
    if (self.tableView.rowHeight < maxRowHeight) {
        [scrollView setContentOffset:CGPointZero];
    }
}

- (void)changeCanScrollDistanceWithScrollView:(UIScrollView *)scrollView {
    if (!scrollView) {
        if (self.itemsArray.count > self.currentIndex) {
            id<HYHItemProtocol> item = self.itemsArray[self.currentIndex];
            scrollView = item.scrollView;
        }
    }
    if (!scrollView) {
        return;
    }
    UIView *headerView = self.headerView;
    CGFloat segmentH = self.segmentHeight;
    CGFloat minCellH = self.bounds.size.height - headerView.bounds.size.height - segmentH;
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

- (void)forceUpdateItemLayout {
    [self changeCanScrollDistanceWithScrollView:nil];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    NSInteger safeIndex = MAX(0, MIN(currentIndex, self.itemsArray.count));
    if (_currentIndex != safeIndex) {
        _currentIndex = safeIndex;
        HYHInnerTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (cell) {
            UIScrollView *scrollView = cell.scrollView;
            [cell.scrollView setContentOffset:CGPointMake(safeIndex * scrollView.bounds.size.width, 0) animated:self.switchPageAnimated];
        }
    }
}

@end
