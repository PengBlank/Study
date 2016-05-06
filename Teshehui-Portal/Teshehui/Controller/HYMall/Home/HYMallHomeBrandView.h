//
//  HYMallHomeBrandView.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/4.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMallHomeItem.h"

/**
 *  品牌助推产品页
 */
@interface HYMallHomeBrandView : UIControl

@property (nonatomic, strong) NSString *imgName;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *points;
// 标记
@property (nonatomic, assign) int nTag;

@property (nonatomic, strong) HYMallHomeItem *item;

@end
