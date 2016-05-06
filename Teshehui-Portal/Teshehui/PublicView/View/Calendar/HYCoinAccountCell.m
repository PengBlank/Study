//
//  HYCoinAccountCell.m
//  Teshehui
//
//  Created by Kris on 15/5/7.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCoinAccountCell.h"
#import "NSDate+Addition.h"
#import "HYCoinAccountResponse.h"
#import "UIImageView+WebCache.h"

//typedef NS_ENUM(NSInteger, OperateTypeCode)
//{
//    Undefine,
//    MallOrderPurchase = 3,
//    Flower,
//    
//};

#define HYCoinAccountCellBorder 10
@interface HYCoinAccountCell ()

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *infoTextLabel;
@property (nonatomic, strong) UILabel *dateTextLabel;
@property (nonatomic, strong) UILabel *coinLabel;

@end

@implementation HYCoinAccountCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupCustomView];
        
//        [self setupCustomViewData];
    }
    return self;
}

//-(void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//    frame.size.width = [UIScreen mainScreen].bounds.size.width;
//    self.frame = frame;
//    NSLog(@"%f",frame.size.width);
//}

#pragma mark setter/getter
- (void)setCoinData:(HYCoinAccount *)coinData
{
    if (coinData != _coinData)
    {
        _coinData = coinData;
        
        [self setupCustomViewData:coinData];
    }
}

- (CGFloat)cellHeight
{
    if (_cellHeight<=0 && self.coinData)
    {
        return _cellHeight;
    }
    return _cellHeight;
}

- (void)setupCustomViewData:(HYCoinAccount *)obj
{
    [self.infoTextLabel setText:obj.tradeDescription];
    [self.dateTextLabel setText:obj.createdTime];
    
    if ([obj.tradeAmount integerValue] > 0)
    {
        NSString *str = [NSString stringWithFormat:@"+%@",obj.tradeAmount];
        [self.coinLabel setText:str];
        self.coinLabel.textColor = [UIColor redColor];
    }
    else
    {
        [self.coinLabel setText:[NSString stringWithFormat:@"%@",obj.tradeAmount]];
        self.coinLabel.textColor = [UIColor greenColor];
    }
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:obj.iconUrl]];
    
    _iconView.frame = obj.iconViewF;
    _infoTextLabel.frame = obj.inFoTextLabelF;
    _dateTextLabel.frame = obj.dateTextLabelF;
    _coinLabel.frame = obj.coinLabelF;
}

- (void)setupCustomView
{
    UIImageView *iconView = [[UIImageView alloc]init];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    UILabel *infoTextLabel = [[UILabel alloc]init];
    infoTextLabel.font = [UIFont systemFontOfSize:14];
    infoTextLabel.numberOfLines = 0;
    [self.contentView addSubview:infoTextLabel];
    self.infoTextLabel = infoTextLabel;
    
    UILabel *dateTextLabel = [[UILabel alloc]init];
    
    dateTextLabel.font = [UIFont systemFontOfSize:12];
    dateTextLabel.numberOfLines = 0;
    [self.contentView addSubview:dateTextLabel];
    self.dateTextLabel = dateTextLabel;
    
    UILabel *coinLabel = [[UILabel alloc]init];
    coinLabel.font = [UIFont systemFontOfSize:16];
//    coinLabel.numberOfLines = 0;
    coinLabel.textColor = [UIColor colorWithRed:255/255.0 green:86/255.0 blue:116/255.0 alpha:1];
    coinLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:coinLabel];
    self.coinLabel = coinLabel;
}

@end
