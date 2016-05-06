//
//  HYLoginViewBaseCell.m
//  Teshehui
//
//  Created by HYZB on 16/2/20.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYLoginViewBaseCell.h"

@implementation HYLoginViewBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.font = [UIFont systemFontOfSize:13.0];
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = nil;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
        [self.contentView addSubview:lineView];
        _lineView = lineView;
    }
    return self;
}

- (void)setCellHeight:(CGFloat)cellHeight
{
    self.lineView.frame = CGRectMake(TFScalePoint(20), cellHeight, TFScalePoint(280), 0.5);
}

@end
