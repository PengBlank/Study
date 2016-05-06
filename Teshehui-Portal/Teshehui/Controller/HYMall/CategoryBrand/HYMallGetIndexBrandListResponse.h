//
//  HYMallGetIndexBrandListResponse.h
//  Teshehui
//
//  Created by Kris on 16/3/23.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYMallBrandModel.h"

@interface HYMallGetIndexBrandListResponse : CQBaseResponse

@property (nonatomic, copy) NSArray <HYMallBrandModel *> *dataList;

@end
