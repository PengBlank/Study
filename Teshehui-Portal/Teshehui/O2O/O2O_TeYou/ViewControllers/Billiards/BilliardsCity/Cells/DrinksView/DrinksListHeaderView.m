//
//  DrinksListHeaderView.m
//  zuoqiu
//
//  Created by wujianming on 15/11/5.
//  Copyright © 2015年 teshehui. All rights reserved.
//

#define kSreenH [UIScreen mainScreen].bounds.size.height
#define IS_IPHONE_6  (kSreenH == 667.0)
#define IS_IPHONE_6S  (kSreenH > 667.0)

#import "DrinksListHeaderView.h"
#import "Masonry.h"

@implementation DrinksListHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
        __weak typeof(self) weakSelf = self;
        
        // 总计控件载体
        UIView *totalView = [[UIView alloc] init];
        [self addSubview:totalView];
        totalView.backgroundColor = [UIColor whiteColor];
        
        [totalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.mas_left);
            make.right.mas_equalTo(weakSelf.mas_right);
            make.top.mas_equalTo(weakSelf.mas_top);
            make.height.mas_equalTo(frame.size.height * 0.5);
        }];
        
//        // 现金券标题
//        UILabel *coupTitle = [[UILabel alloc] init];
//        [totalView addSubview:coupTitle];
//        coupTitle.font = [UIFont systemFontOfSize:15.0];
//        coupTitle.text = @"现金券";
//        
//        [coupTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(weakSelf.mas_right).offset(-10);
//            make.centerY.mas_equalTo(totalView.mas_centerY).offset(-5);
//        }];
        
        // 总计金额
        _totalPrice = [[UILabel alloc] init];
        [totalView addSubview:_totalPrice];
        _totalPrice.font = [UIFont systemFontOfSize:15.0];
        _totalPrice.textColor = [UIColor colorWithRed:185/255.0 green:62/255.0 blue:66/255.0 alpha:1.0];
        _totalPrice.text = @"￥0.00";
        
        [_totalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weakSelf.mas_right).offset(-10);
            make.centerY.mas_equalTo(totalView.mas_centerY).offset(-5);
        }];
        
        // 总计标题
        _totalPriceTitle = [[UILabel alloc] init];
        [totalView addSubview:_totalPriceTitle];
        _totalPriceTitle.font = [UIFont systemFontOfSize:15.0];
        _totalPriceTitle.text = @"商品总计：";
        
        [_totalPriceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weakSelf.totalPrice.mas_left);
            make.centerY.mas_equalTo(totalView.mas_centerY).offset(-5);
        }];
        

        
        // 间隔条
        UIView *marginView = [[UIView alloc] init];
        [totalView addSubview:marginView];
        marginView.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
        
        [marginView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.mas_left);
            make.right.mas_equalTo(weakSelf.mas_right);
            make.height.mas_equalTo(10);
            make.bottom.mas_equalTo(totalView.mas_bottom);
        }];
        
        // 商品名称
        _CommodityName = [[UILabel alloc] init];
        [self addSubview:_CommodityName];
        _CommodityName.numberOfLines = 0;
        _CommodityName.font = [UIFont systemFontOfSize:15];
        _CommodityName.text = @"商品名称";
        
        [_CommodityName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.mas_left).offset(10);
            make.bottom.mas_equalTo(weakSelf.mas_bottom);
            make.width.mas_equalTo(IS_IPHONE_6? @100 : IS_IPHONE_6S ? @120 : @70);
            make.top.mas_equalTo(totalView.mas_bottom);
        }];
        
        // 原价
        _OriginalPrice = [[UILabel alloc] init];
        [self addSubview:_OriginalPrice];
        _OriginalPrice.numberOfLines = 0;
        _OriginalPrice.textAlignment = NSTextAlignmentCenter;
        _OriginalPrice.font = [UIFont systemFontOfSize:15];
        _OriginalPrice.text = @"原价";
        
        [_OriginalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
          //  make.left.mas_equalTo(weakSelf.CommodityName.mas_right).offset(5);
            make.centerX.equalTo(weakSelf);
            make.bottom.mas_equalTo(weakSelf.mas_bottom);
            make.width.mas_equalTo(@40);
            make.top.mas_equalTo(totalView.mas_bottom);
        }];
        
        // 数量
        _count = [[UILabel alloc] init];
        [self addSubview:_count];
        _count.text = @"数量";
        _count.font = [UIFont systemFontOfSize:15.0];
        _count.textAlignment = NSTextAlignmentCenter;
        
        [_count mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weakSelf.mas_right).offset(-10);
            make.bottom.mas_equalTo(weakSelf.mas_bottom);
            make.top.mas_equalTo(totalView.mas_bottom);
            make.width.mas_equalTo(IS_IPHONE_6 ? @90 : @80);
        }];
        
//        // 特奢汇价
//        _TSHPrice = [[UILabel alloc] init];
//        [self addSubview:_TSHPrice];
//        _TSHPrice.numberOfLines = 0;
//        _TSHPrice.textAlignment = NSTextAlignmentCenter;
//        _TSHPrice.font = [UIFont systemFontOfSize:15];
//        _TSHPrice.text = @"会员价";
//        
//        [_TSHPrice mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(weakSelf.OriginalPrice.mas_right).offset(IS_IPHONE_6S ? 20 : 0);
//            make.right.mas_equalTo(weakSelf.count.mas_left).offset(IS_IPHONE_6 ? -10 : 0);
//            make.bottom.mas_equalTo(weakSelf.mas_bottom);
//            make.top.mas_equalTo(totalView.mas_bottom);
//        }];
    }
    
    return self;
}


@end
