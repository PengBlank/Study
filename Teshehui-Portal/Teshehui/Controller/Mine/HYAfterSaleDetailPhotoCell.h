//
//  HYAfterSaleDetailPhotoCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/9.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYMallAfterSaleInfo.h"

@interface HYAfterSaleDetailPhotoCell : HYBaseLineCell

@property (nonatomic, strong) NSArray *photos;  
@property (nonatomic, strong) HYMallAfterSaleInfo *saleInfo;

@property (nonatomic, copy) void (^photoClick)(NSInteger idx);

@end
