//
//  HYMyDesirePoolRequest.h
//  Teshehui
//
//  Created by HYZB on 15/11/21.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYMyDesirePoolRequest : CQBaseRequest

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *pageNo;
@property (nonatomic, copy) NSString *pageSize;


@end
