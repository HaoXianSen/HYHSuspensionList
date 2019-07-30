//
//  HYHFirstViewController.m
//  HYHSuspensionList_Example
//
//  Created by harry on 2019/7/29.
//  Copyright © 2019 1335430614@qq.com. All rights reserved.
//

#import "HYHFirstViewController.h"

@interface HYHFirstViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation HYHFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
//    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tableView];
    _tableView = tableView;
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 34, 0);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}


- (UIScrollView *)scrollView {
    return self.tableView;
}

- (UIView *)containerView {
    return self.view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"我是第%ld行", indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.itemScrollViewDidScroll) {
        self.itemScrollViewDidScroll(scrollView);
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.itemViewDidAppear) {
        self.itemViewDidAppear(self.tableView);
    }
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
