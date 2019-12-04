//
//  HYHTableView.m
//  HYHSuspensionList
//
//  Created by harry on 2019/7/29.
//

#import "HYHTableView.h"

@implementation HYHTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
