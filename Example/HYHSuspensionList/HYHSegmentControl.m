//
//  HYHSegmentControl.m
//  HYHSuspensionList_Example
//
//  Created by harry on 2019/11/26.
//  Copyright © 2019 1335430614@qq.com. All rights reserved.
//

#import "HYHSegmentControl.h"
#import "HYHSegmentModel.h"
#import "HYHSegmentItemCell.h"

static NSString * const CELL_IDENTIFIER = @"CollectionCellIdentifier";

@interface HYHSegmentControl ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray<HYHSegmentModel *> *itemModels;

@end

@implementation HYHSegmentControl

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
    
    _currentSelectedIndex = -1;
    
    self.backgroundColor = UIColor.whiteColor;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(HYHSegmentItemCell.class) bundle:nil] forCellWithReuseIdentifier:CELL_IDENTIFIER];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = self.backgroundColor;
    collectionView.showsVerticalScrollIndicator = false;
    collectionView.showsHorizontalScrollIndicator = false;
    [self addSubview:collectionView];
    _collectionView = collectionView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _collectionView.frame = self.bounds;
}

#pragma mark - setter

- (void)setItems:(NSArray<NSString *> *)items {
    NSAssert(items && items.count > 0, @"items can not null or item is null");
    _items = items;
    NSMutableArray *array = [NSMutableArray array];
    [_items enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HYHSegmentModel *model = [HYHSegmentModel segmentModelWithTitle:obj];
        [array addObject:model];
    }];
    self.itemModels = [array copy];
    [self.collectionView reloadData];
}

- (void)setCurrentSelectedIndex:(NSInteger)currentSelectedIndex {
    if (_currentSelectedIndex == currentSelectedIndex) {
        return;
    }
    _currentSelectedIndex = currentSelectedIndex;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentSelectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self resetHeightlightStateWithCurrentSelectedIndex:_currentSelectedIndex];
}

#pragma mark - data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HYHSegmentModel *itemModel = self.itemModels[indexPath.item];
    HYHSegmentItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    cell.model = itemModel;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.itemModels.count > 0) {
        HYHSegmentModel *model = self.itemModels[indexPath.item];
        return CGSizeMake(model.cellWidth + 16, self.bounds.size.height);
    }
    return CGSizeMake(0, 0);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.currentSelectedIndex = indexPath.item;
    if (self.indexChangeBloc) {
        self.indexChangeBloc(_currentSelectedIndex);
    }
}

- (void)resetHeightlightStateWithCurrentSelectedIndex:(NSInteger)index {
    [self.itemModels enumerateObjectsUsingBlock:^(HYHSegmentModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj willChangeValueForKey:@"heighlighted"];
        obj.heighlighted = idx == index;
        [obj didChangeValueForKey:@"heighlighted"];
    }];
}

@end
