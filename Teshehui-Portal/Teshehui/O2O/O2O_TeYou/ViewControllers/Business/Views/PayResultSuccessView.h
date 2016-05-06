//
//  PayResultSuccessView.h
//  Teshehui
//
//  Created by apple_administrator on 16/4/6.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//
typedef void (^btnClickBlock)(UIButton *btn);

#import <UIKit/UIKit.h>
#import "DefineConfig.h"
@interface PayResultSuccessView : UIView
{
    NSString *_timeStr;
}
@property (nonatomic,copy)btnClickBlock  checkBtnBlock;
@property (nonatomic,copy)NSString       *orderID;


@property (nonatomic,strong) NSString *money;
@property (nonatomic,strong) NSString *coupon;
@property (nonatomic,strong) UILabel *storeLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *desLabel;


- (instancetype)initWithFrame:(CGRect)frame payType:(O2OPayType)type;
/**
 *  绑定数据
 *
 *  @param title    店名
 *  @param money    支付现金
 *  @param coupon   支付现金券
 *  @param packName 套餐名
 *  @param paycode  消费码
 */
- (void)bindData:(NSString *)title
           money:(NSString *)money
          coupon:(NSString *)coupon
        packName:(NSString *)packName
         payCode:(NSString *)paycode;
@end
