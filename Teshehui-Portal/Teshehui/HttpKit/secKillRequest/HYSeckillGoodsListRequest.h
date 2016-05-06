//
//  HYSeckillGoodsListRequest.h
//  Teshehui
//
//  Created by HYZB on 15/12/9.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYSeckillGoodsListRequest : CQBaseRequest

@property (nonatomic, copy) NSString *activityId;
@property (nonatomic, copy) NSString *pageNo;
@property (nonatomic, copy) NSString *pageSize;

@end
