//
//  HYHMainViewController.m
//  HYHSuspensionList_Example
//
//  Created by harry on 2019/7/31.
//  Copyright © 2019 1335430614@qq.com. All rights reserved.
//

#import "HYHMainViewController.h"
#import "HYHFirstViewController.h"
#import "HYHSecondViewController.h"
#import <HYHSuspensionList/HYHSuspensionView.h>

@interface HYHMainViewController ()<HYHSuspensionViewDelegate, HYHSuspensionViewDataSource>
@property (nonatomic, weak) HYHSuspensionView *suspensionView;
@end

@implementation HYHMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    //    self.automaticallyAdjustsScrollViewInsets  = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    HYHSuspensionView *suspensionView = [[HYHSuspensionView alloc] initWithFrame:self.view.bounds];
    suspensionView.dataSource = self;
    suspensionView.delegate = self;
    [self.view addSubview:suspensionView];
    _suspensionView = suspensionView;
    
}

//- (BOOL)extendedLayoutIncludesOpaqueBars {
//    return NO;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.suspensionView.frame = self.view.bounds;
}

#pragma mark - HYHSuspensionViewDataSource delegate

- (void)suspensionView:(nonnull HYHSuspensionView *)suspensionView didChangeSlidePageIndex:(NSInteger)currentIndex {
    
}

- (UIViewController *)suspensionViewAddedViewController:(HYHSuspensionView *)suspensionView {
    return self;
}

- (id<HYHItemProtocol>)suspensionView:(nonnull HYHSuspensionView *)suspensionView itemAtSlideIndex:(NSInteger)index{
    
    if (index == 0) {
        HYHFirstViewController *viewController = [[HYHFirstViewController alloc] init];
        return viewController;
    } else {
        HYHSecondViewController *viewController = [[HYHSecondViewController alloc] init];
        return viewController;
    }
}

- (nonnull UIView *)suspensionViewHeaderView:(nonnull HYHSuspensionView *)suspensionView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, suspensionView.bounds.size.width, 120)];
    imageView.image = [UIImage imageNamed:@"header_image.jpg"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    return imageView;
}

- (NSInteger)suspensionViewNumberOfItems:(nonnull HYHSuspensionView *)suspensionView {
    return 2;
}

- (nonnull UIView *)suspensionViewSegmentView:(nonnull HYHSuspensionView *)suspensionView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, suspensionView.bounds.size.width, 44)];
    view.backgroundColor = UIColor.redColor;
    return view;
}

- (CGFloat)suspensionViewsSegementViewHeight:(nonnull HYHSuspensionView *)suspensionView {
    return 44.f;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end