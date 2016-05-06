//
//  GetOrderListRequest.h
//  Teshehui
//
//  Created by apple_administrator on 15/9/25.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface GetOrderListRequest : CQBaseRequest
@property (nonatomic,strong) NSString       *UserId;
@property (nonatomic,assign) NSInteger      PageIndex;
@property (nonatomic,assign) NSInteger      PageSize;
@property (nonatomic,assign) NSInteger      Status;
@end
