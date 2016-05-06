//
//  HYCustomerServiceCell.m
//  Teshehui
//
//  Created by HYZB on 15/4/28.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCustomerServiceCell.h"
#import <TencentOpenAPI/TencentApiInterface.h>

@implementation HYCustomerServiceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        if ([TencentApiInterface isTencentAppInstall:kIphoneQQ])
        if (YES)
        {
            UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(TFScalePoint(159.5), 0, 1, 44)];
            lineView.image = [[UIImage imageNamed:@"Line_InCell"] stretchableImageWithLeftCapWidth:0
                                                                                      topCapHeight:2];
            [self.contentView addSubview:lineView];
            
            UIButton *onlineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            onlineBtn.frame = CGRectMake(0, 0, TFScalePoint(159), 44);
            [onlineBtn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.0]
                            forState:UIControlStateNormal];
            [onlineBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [onlineBtn setTitleColor:[UIColor colorWithRed:18.0/255.0
                                                     green:146.0/255.0
                                                      blue:203.0/255.0
                                                     alpha:1.0]
                            forState:UIControlStateNormal];
            [onlineBtn setTitle:@"小秘书"
                       forState:UIControlStateNormal];
            [onlineBtn setImage:[UIImage imageNamed:@"customer_online"]
                       forState:UIControlStateNormal];
            [onlineBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 60)];
            [onlineBtn addTarget:self
                          action:@selector(connectCustomerService:)
                forControlEvents:UIControlEventTouchUpInside];
            onlineBtn.tag = 10;
            [self addSubview:onlineBtn];
            
            UIButton *telphoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            telphoneBtn.frame = CGRectMake(TFScalePoint(161), 0, TFScalePoint(159), 44);
            [telphoneBtn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.0]
                              forState:UIControlStateNormal];
            [telphoneBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [telphoneBtn setTitleColor:[UIColor colorWithRed:18.0/255.0
                                                       green:146.0/255.0
                                                        blue:203.0/255.0
                                                       alpha:1.0]
                              forState:UIControlStateNormal];
            [telphoneBtn setImage:[UIImage imageNamed:@"customer_call"]
                         forState:UIControlStateNormal];
            [telphoneBtn setTitle:@"客服电话" forState:UIControlStateNormal];
            [telphoneBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 60)];
            [telphoneBtn addTarget:self
                            action:@selector(connectCustomerService:)
                  forControlEvents:UIControlEventTouchUpInside];
            telphoneBtn.tag = 11;
            [self addSubview:telphoneBtn];
        }
        else
        {
            UIButton *telphoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            telphoneBtn.frame = CGRectMake(0, 0, TFScalePoint(320), 44);
            [telphoneBtn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.0]
                              forState:UIControlStateNormal];
            [telphoneBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [telphoneBtn setTitleColor:[UIColor colorWithRed:18.0/255.0
                                                       green:146.0/255.0
                                                        blue:203.0/255.0
                                                       alpha:1.0]
                              forState:UIControlStateNormal];
            [telphoneBtn setImage:[UIImage imageNamed:@"customer_call"]
                         forState:UIControlStateNormal];
            [telphoneBtn setTitle:@"客服电话" forState:UIControlStateNormal];
            [telphoneBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 60)];
            [telphoneBtn addTarget:self
                            action:@selector(connectCustomerService:)
                  forControlEvents:UIControlEventTouchUpInside];
            telphoneBtn.tag = 11;
            [self addSubview:telphoneBtn];
        }
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark private methods
- (void)connectCustomerService:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didConnectCustomerServiceWithTpye:)])
    {
        CustomerServiceType type = (sender.tag == 10) ? OnlineService : callService;
        
        [self.delegate didConnectCustomerServiceWithTpye:type];
    }
}

@end
