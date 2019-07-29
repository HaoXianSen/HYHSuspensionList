//
//  HYHSupensionView.m
//  HYHSuspensionList
//
//  Created by harry on 2019/7/29.
//

#import "HYHSuspensionView.h"
#import "HYHInnerTableViewCell.h"
#import "HYHSuspensionViewDefine.h"

static NSString *kCellId = @"HYH_CELL_IDENTIFIER";

@interface HYHSuspensionView()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIScrollView *innerScrollView;

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
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
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
    CGFloat height = self.bounds.size.height - [self.dataSource suspensionViewHeaderView:self].bounds.size.height - [self tableView:tableView heightForHeaderInSection:0] - HYH_BOTTOM_HEIGHT;
    return height;
}

@end
