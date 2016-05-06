//
//  BilliardsOrderListRequest.h
//  Teshehui
//
//  Created by apple_administrator on 15/11/3.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface BilliardsOrderListRequest : CQBaseRequest

@property (nonatomic,strong) NSString *merId;
@property (nonatomic,strong) NSString *UId;
@property (nonatomic, strong) NSString *orId;

@property (nonatomic,assign) NSInteger Status;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) NSInteger pageIndex;

@end
