//
//  HYHTableView.m
//  HYHSuspensionList
//
//  Created by harry on 2019/7/29.
//

#import "HYHTableView.h"

@implementation HYHTableView

//- (void)setCanScroll:(BOOL)canScroll {
//    _canScroll = canScroll;
//    self.scrollEnabled = canScroll;
//}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
