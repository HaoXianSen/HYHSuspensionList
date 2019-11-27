//
//  HYHSegmentItemCell.m
//  HYHSuspensionList_Example
//
//  Created by harry on 2019/11/26.
//  Copyright © 2019 1335430614@qq.com. All rights reserved.
//

#import "HYHSegmentItemCell.h"

@interface HYHSegmentItemCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HYHSegmentItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(HYHSegmentModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.titleLabel.font = model.textFont;
    self.titleLabel.textColor = model.normalColor;
    self.titleLabel.highlightedTextColor = model.heighlightColor;
    self.titleLabel.highlighted = model.heighlighted;
    [self addObserver:_model forKeyPath:@"heighlighted" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    id newValue = [change objectForKey:NSKeyValueChangeNewKey];
    BOOL heighlighted = [newValue boolValue];
    self.titleLabel.highlighted = heighlighted;
    NSLog(@"HYH");
}

- (void)dealloc
{
    [self removeObserver:self.model forKeyPath:@"heighlighted"];
}
@end
