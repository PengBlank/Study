//
//  HYMallApplyAfterSaleView.h
//  Teshehui
//
//  Created by Kris on 15/10/9.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYMallAfterSaleInfo;
#import "HYMallChildOrder.h"

typedef NS_ENUM(NSUInteger, AfterSaleType)
{
    NormalRefund = 1,
    ThunderRefund,
    Barter,
};

@protocol HYMallApplyAfterSaleHeaderViewDelegate <NSObject>

@optional
- (void)chooseAfteSaleWithType:(AfterSaleType)type;
- (void)applyAfterSaleQuantity:(NSUInteger)quantity;
- (void)applyAfterSaleProblemDescription:(NSString *)description;

@end

@interface HYMallApplyAfterSaleHeaderView : UIView

@property (nonatomic, weak) id<HYMallApplyAfterSaleHeaderViewDelegate> delegate;
@property (nonatomic, strong) HYMallOrderItem *returnGoodsInfo;

- (instancetype)initMyNib;

@property (nonatomic, assign) BOOL isChange;
@property (nonatomic, strong) HYMallAfterSaleInfo *saleInfo;


@end
