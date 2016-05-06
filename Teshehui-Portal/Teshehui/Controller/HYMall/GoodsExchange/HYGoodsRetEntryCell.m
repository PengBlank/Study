//
//  HYGoodsRetEntryCell.m
//  Teshehui
//
//  Created by RayXiang on 14-9-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGoodsRetEntryCell.h"

@implementation HYGoodsRetEntryCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.isGray = YES;
        self.nessary = NO;
        self.selectable = NO;
        self.valueLab.text = nil;
        
        UITextField *textField = [[UITextField alloc] initWithFrame:self.valueLab.frame];
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:textField];
        self.textField = textField;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
