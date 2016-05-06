//
//  HYMineInfoServiceCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/8/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMineInfoServiceCell.h"
#import "HYImageButton.h"
#import <TencentOpenAPI/TencentApiInterface.h>

@implementation HYMineInfoServiceCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        CGFloat width = [[UIScreen mainScreen] bounds].size.width;
        self.frame = CGRectMake(0, 0, width, 55);
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = nil;
        
        HYImageButton *balance = [[HYImageButton alloc] initWithFrame:CGRectMake(6, 6, width/2-9, 44)];
        [balance setImage:[UIImage imageNamed:@"customer_call"] forState:UIControlStateNormal];
        balance.imageOrigin = CGPointMake(29, 10);
        [balance setTitle:@"客服电话" forState:UIControlStateNormal];
        balance.titleLabel.font = [UIFont systemFontOfSize:15.0];
        balance.titleOrigin = CGPointMake(67, 22-balance.titleLabel.font.lineHeight/2.0);
        balance.layer.borderColor = [UIColor colorWithWhite:.90 alpha:1].CGColor;
        balance.layer.borderWidth = 1.0;
        balance.backgroundColor = [UIColor whiteColor];
        balance.type = ImageButtonTypeCustom;
        [balance setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [balance addTarget:self action:@selector(phoneBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        balance.tag = 102;
        [self.contentView addSubview:balance];
        
        HYImageButton *points = [[HYImageButton alloc] initWithFrame:CGRectMake(width/2+3, 6, width/2-9, 44)];
        [points setImage:[UIImage imageNamed:@"customer_online"] forState:UIControlStateNormal];
        points.imageOrigin = CGPointMake(29, 10);
        [points setTitle:@"小秘书" forState:UIControlStateNormal];
        points.titleLabel.font = [UIFont systemFontOfSize:15.0];
        points.titleOrigin = CGPointMake(67, 22-balance.titleLabel.font.lineHeight/2.0);
        points.type = ImageButtonTypeCustom;
        points.layer.borderColor = [UIColor colorWithWhite:.90 alpha:1].CGColor;
        points.layer.borderWidth = 1.0;
        points.backgroundColor = [UIColor whiteColor];
        [points setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
        [points addTarget:self
                   action:@selector(qqBtnAction:)
         forControlEvents:UIControlEventTouchUpInside];
        points.tag = 103;
        [self.contentView addSubview:points];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    if (![TencentApiInterface isTencentAppInstall:kIphoneQQ])
//    {
//        UIView *qq = [self.contentView viewWithTag:103];
//        qq.hidden = YES;
//        UIView *phone = [self.contentView viewWithTag:102];
//        phone.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
//    }
}

- (void)phoneBtnAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(didClickPhone)])
    {
        [self.delegate didClickPhone];
    }
}

- (void)qqBtnAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(didClickQQ)])
    {
        [self.delegate didClickQQ];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
