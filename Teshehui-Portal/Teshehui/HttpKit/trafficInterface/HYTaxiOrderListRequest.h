//
//  HYTaxiOrderListRequest.h
//  Teshehui
//
//  Created by HYZB on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYTaxiOrderListRequest : CQBaseRequest

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *pageNo;
@property (nonatomic, copy) NSString *pageSize;

@end
