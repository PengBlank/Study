//
//  HYLoginV2CheckCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/8/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYLoginV2CheckCell.h"
#import "UIImage+Addition.h"

@implementation HYLoginV2CheckCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(26, 0, 100, 44)];
        [self.checkBtn setImage:[[UIImage imageNamed:@"icon_check"] imageWithSize:CGSizeMake(15, 15)] forState:UIControlStateNormal];
        [self.checkBtn setImage:[[UIImage imageNamed:@"icon_check_on"] imageWithSize:CGSizeMake(15, 15)] forState:UIControlStateSelected];
        [self.checkBtn setTitle:@"平安意外险" forState:UIControlStateNormal];
        [_checkBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _checkBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _checkBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_checkBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [self.contentView addSubview:_checkBtn];
        
        UIImage *arrow = [UIImage imageNamed:@"cell_indicator"];
        
        UIImageView *arrowv = [[UIImageView alloc] initWithImage:arrow];
        arrowv.frame = CGRectMake(CGRectGetWidth(self.frame)-10-arrow.size.width, CGRectGetHeight(self.frame)/2-arrow.size.height/2, arrow.size.width, arrow.size.height);
        arrowv.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:arrowv];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _checkBtn.frame = CGRectMake(26, 0, 250, self.frame.size.height);
//    self.textLabel.frame = CGRectMake(26, 0, 78, self.frame.size.height);
//    //    self.textField.frame = CGRectMake(108, 0, self.frame.size.width-118, self.frame.size.height);
//    CGFloat width = (self.frame.size.width-118);
//    self.detailTextLabel.frame = CGRectMake(108, 0, width, self.frame.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
