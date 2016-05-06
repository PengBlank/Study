//
//  HYLoginV2RadioCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/8/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYLoginV2RadioCell.h"
#import "UIImage+Addition.h"

@implementation HYLoginV2RadioCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.textLabel.font = [UIFont systemFontOfSize:14.0];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton *left = [[UIButton alloc] initWithFrame:CGRectZero];
        [left setTitle:@"男" forState:UIControlStateNormal];
        UIImage *limage = [UIImage imageNamed:@"pay_icon_radio"];
        UIImage *limageon = [UIImage imageNamed:@"pay_icon_radio_on"];
        [left setImage:limage forState:UIControlStateNormal];
        [left setImage:limageon forState:UIControlStateSelected];
        [left setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [left setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        left.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [left setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [left addTarget:self action:@selector(radioAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:left];
        self.left = left;
        
        UIImage *rimage = [UIImage imageNamed:@"pay_icon_radio"];
        UIImage *rimageon = [UIImage imageNamed:@"pay_icon_radio_on"];
        UIButton *right = [[UIButton alloc] initWithFrame:CGRectZero];
        [right setTitle:@"女" forState:UIControlStateNormal];
        [right setImage:rimage forState:UIControlStateNormal];
        [right setImage:rimageon forState:UIControlStateSelected];
        [right setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        right.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [right addTarget:self action:@selector(radioAction:) forControlEvents:UIControlEventTouchUpInside];
        [right setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:right];
        self.right = right;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(26, 0, 78, self.frame.size.height);
//    self.textField.frame = CGRectMake(108, 0, self.frame.size.width-118, self.frame.size.height);
    CGFloat width = (self.frame.size.width-118) / 2;
    self.left.frame = CGRectMake(108, 0, width, self.frame.size.height);
    self.right.frame = CGRectMake(108+width, 0, width, self.frame.size.height);
}

- (void)setSex:(HYUserInfoSex)sex
{
    _sex = sex;
    if (sex == HYSexMale)
    {
        _left.selected = YES;
        _right.selected = NO;
    }
    else if(sex == HYSexFemale)
    {
        _left.selected = NO;
        _right.selected = YES;
    }
    else
    {
        
        _left.selected = NO;
        _right.selected = NO;
    }
}

- (void)radioAction:(UIButton *)btn
{
    HYUserInfoSex sex = btn == _left ? HYSexMale : HYSexFemale;
    [self setSex:sex];
    
    if (self.didSelectSex) {
        self.didSelectSex(sex);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
