//
//  HYMovieTicketOrderListRequest.h
//  Teshehui
//
//  Created by HYZB on 16/2/29.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYMovieTicketOrderListRequest : CQBaseRequest

@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;

@end
