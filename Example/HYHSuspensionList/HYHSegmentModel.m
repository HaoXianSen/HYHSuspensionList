//
//  HYHSegmentModel.m
//  HYHSuspensionList_Example
//
//  Created by harry on 2019/11/27.
//  Copyright © 2019 1335430614@qq.com. All rights reserved.
//

#import "HYHSegmentModel.h"

@implementation HYHSegmentModel

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        _title = title;
        _textFont = [UIFont boldSystemFontOfSize:16];
        _normalColor = UIColor.blackColor;
        _heighlightColor = UIColor.orangeColor;
        _heighlighted = false;
    }
    return self;
}

+ (instancetype)segmentModelWithTitle:(NSString *)title {
    return [[self alloc] initWithTitle:title];
}

- (CGFloat)cellWidth {
    if (!_cellWidth) {
        _cellWidth = [self calculatePreferredWidth];
    }
    return _cellWidth;
}

- (CGFloat)calculatePreferredWidth {
    if (_title.length <= 0) {
        return 0;
    }
    
    CGSize size = [self.title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.textFont.lineHeight+20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.textFont} context:NULL].size;
    return ceilf(size.width);
}

@end
