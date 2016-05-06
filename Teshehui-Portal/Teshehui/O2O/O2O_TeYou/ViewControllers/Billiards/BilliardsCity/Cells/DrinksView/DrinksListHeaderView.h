//
//  DrinksListHeaderView.h
//  zuoqiu
//
//  Created by wujianming on 15/11/5.
//  Copyright © 2015年 teshehui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrinksListHeaderView : UIView

/** 总计标题*/
@property (nonatomic, strong) UILabel *totalPriceTitle;

/** 总计金额*/
@property (nonatomic, strong) UILabel *totalPrice;

/** 商品名称*/
@property (nonatomic, strong) UILabel *CommodityName;

/** 原价*/
@property (nonatomic, strong) UILabel *OriginalPrice;

///** 特奢汇价*/
//@property (nonatomic, strong) UILabel *TSHPrice;

/** 计数器*/
@property (nonatomic, strong) UILabel *count;

@end
