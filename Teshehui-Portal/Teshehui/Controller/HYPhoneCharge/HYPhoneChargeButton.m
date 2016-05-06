//
//  HYPhoneChargeButton.m
//  Teshehui
//
//  Created by Kris on 16/2/29.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYPhoneChargeButton.h"
#import "Masonry.h"

@interface HYPhoneChargeButton ()

@property (nonatomic, strong) UILabel *feeLab;
@property (nonatomic, strong) UILabel *salePriceLab;
@property (nonatomic, strong) HYPhoneChargeModel *paramModel;

@end

@implementation HYPhoneChargeButton

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (instancetype)init
{
    if (self = [super init])
    {
        WS(weakSelf);
        
        UILabel *lab1 = [[UILabel alloc]init];
        lab1.text = @"50元";
        lab1.textAlignment = NSTextAlignmentCenter;
        lab1.font = [UIFont systemFontOfSize:14.0f];
        
        [self addSubview:lab1];
        self.feeLab = lab1;
        
        [self.feeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.mas_left).with.offset(5);
            make.right.equalTo(weakSelf.mas_right).with.offset(-5);
            make.bottom.equalTo(weakSelf.mas_bottom).with.offset(-35);
            make.top.equalTo(weakSelf.mas_top).with.offset(20);
   
        }];
        
        UILabel *lab2 = [[UILabel alloc]init];
        lab2.text = @"售价29.49元";
        lab2.textAlignment = NSTextAlignmentCenter;
        lab2.font = [UIFont systemFontOfSize:10.0f];
        
        [self addSubview:lab2];
        self.salePriceLab = lab2;
        
        [self.salePriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.mas_left).with.offset(5);
            make.right.equalTo(weakSelf.mas_right).with.offset(-5);
            make.bottom.equalTo(weakSelf.mas_bottom).with.offset(-8);
            make.top.equalTo(lab1.mas_bottom).with.offset(5);
        }];
        
//        self.titleEdgeInsets = UIEdgeInsetsMake(20, 5, 0, 5);
    }
    return self;
}

#pragma mark getter & setter
- (void)setTextColor:(UIColor *)color
{
    _feeLab.textColor = color;
    _salePriceLab.textColor = color;
}

- (void)setPhoneChargeButtonData:(HYPhoneChargeModel *)data
{
    if (data)
    {
        self.paramModel = data;
        
        _feeLab.text = [NSString stringWithFormat:@"%@元",data.parvalue];
        //get the first two nums
//        NSString *price = data.price;
//        if (data.price.length > 3)
//        {
//            price = [data.price substringWithRange:NSMakeRange(0, 4)];
//        }
        
        _salePriceLab.text = [NSString stringWithFormat:@"售价%.2f元",data.price.floatValue];
    }
}

@end
