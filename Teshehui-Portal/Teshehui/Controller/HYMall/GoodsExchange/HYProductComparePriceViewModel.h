//
//  HYProductComparePriceViewModel.h
//  Teshehui
//
//  Created by Kris on 16/2/25.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYComparePriceResponse.h"
#import "HYMallGoodsDetail.h"

@interface HYProductComparePriceViewModel : NSObject

@property (nonatomic, strong) HYComparePriceModel *priceModel;
@property (nonatomic, strong) HYMallGoodsDetail *detailModel;

@end
