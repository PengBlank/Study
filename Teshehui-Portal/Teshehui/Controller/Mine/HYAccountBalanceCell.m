//
//  HYAccountBalanceCell.m
//  Teshehui
//
//  Created by Kris on 15/8/21.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYAccountBalanceCell.h"
#import "UIImageView+WebCache.h"

@interface HYAccountBalanceCell ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *infoTextLabel;
@property (nonatomic, strong) UILabel *dateTextLabel;
@property (nonatomic, strong) UILabel *coinLabel;
@property (nonatomic, strong) UILabel *purchaseLabel;

@end

@implementation HYAccountBalanceCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setupCustomView];
        
    }
    return self;
}

- (void)setupCustomView
{
    UIImageView *iconView = [[UIImageView alloc]init];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    UILabel *purchaseLabel = [[UILabel alloc]init];
    purchaseLabel.font = [UIFont systemFontOfSize:10];
    purchaseLabel.numberOfLines = 0;
    [self.contentView addSubview:purchaseLabel];
    self.purchaseLabel = purchaseLabel;
    
    UILabel *infoTextLabel = [[UILabel alloc]init];
    infoTextLabel.font = [UIFont systemFontOfSize:12];
    infoTextLabel.numberOfLines = 1;
    [self.contentView addSubview:infoTextLabel];
    self.infoTextLabel = infoTextLabel;
    
    UILabel *dateTextLabel = [[UILabel alloc]init];
    dateTextLabel.font = [UIFont systemFontOfSize:12];
    dateTextLabel.numberOfLines = 1;
    [self.contentView addSubview:dateTextLabel];
    self.dateTextLabel = dateTextLabel;
    
    UILabel *coinLabel = [[UILabel alloc]init];
    coinLabel.font = [UIFont systemFontOfSize:16];
    //    coinLabel.numberOfLines = 0;
    coinLabel.textColor = [UIColor colorWithRed:255/255.0 green:86/255.0 blue:116/255.0 alpha:1];
    coinLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:coinLabel];
    self.coinLabel = coinLabel;
}

- (void)setData:(HYAccountBalance *)data
{
//    NSString *imagePath = nil;
    if (data)
    {
        /*
        if ([data.operateTypeCode length] > 0)
        {
            int typeCode = [data.operateTypeCode intValue];
            switch (typeCode)
            {
                case 0://其他
                    break;
                case 1://后台操作(后台充值)
                    break;
                case 2://退款
                    imagePath = @"balanceAccount_tuikuan";
                    break;
                case 3://购物消费
                case 4:
                    imagePath = @"balanceAccount_gouwu";
                    break;
                case 5://订单取消
                    
                    break;
                case 6://购物消费
                    imagePath = @"balanceAccount_gouwu";
                    break;
                case 7://其他
                    
                    break;
                case 8://退款
                case 9:
                case 10:
                    imagePath = @"balanceAccount_tuikuan";
                    break;
                case 11://购物消费
                    imagePath = @"balanceAccount_gouwu";
                    break;
                case 12://退款
                    imagePath = @"balanceAccount_tuikuan";
                    break;
                case 13://购物消费
                    imagePath = @"balanceAccount_gouwu";
                    break;
                case 14://退款
                    imagePath = @"balanceAccount_tuikuan";
                    break;
                case 15://购物消费
                    imagePath = @"balanceAccount_gouwu";
                    break;
                case 16://退款
                    imagePath = @"balanceAccount_tuikuan";
                    break;
                case 17://购物消费
                    imagePath = @"balanceAccount_gouwu";
                    break;
                case 18://退款
                    imagePath = @"balanceAccount_tuikuan";
                    break;
                case 19://其他
                    
                    break;
                case 20://活动返现
                    
                    break;
                case 21://贵就赔
                    imagePath = @"balanceAccount_guijiupei";
                    break;
                default:
                    break;
            }
        }
         */
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:data.iconUrl]];

        _iconView.frame = TFRectMake(20, 10, 20, 15);
        
        _purchaseLabel.text = data.operateTypeName;
        _purchaseLabel.frame = TFRectMake(20, 30, 30, 10);
        
        _infoTextLabel.text = data.tradeDescription;
        _infoTextLabel.frame = TFRectMake(50, 8, 200, 15);
        
        _dateTextLabel.text = data.createdTime;
        _dateTextLabel.frame = TFRectMake(50, 23, 150, 15);
        
        UIColor *color = nil;
        NSString *str = nil;
        if ([data.tradeAmount floatValue]>0)
        {
            color = [UIColor redColor];
            str = [NSString stringWithFormat:@"%@",data.tradeAmount];
        }else
        {
            color = [UIColor greenColor];
            str = [NSString stringWithFormat:@"%@",data.tradeAmount];
        }
        
        _coinLabel.textColor = color;
        _coinLabel.text = str;
        _coinLabel.frame = TFRectMake(240, 10, 70, 20);
    }
}
@end
