//
//  HYCheckReviewStatusReq.h
//  Teshehui
//
//  Created by HYZB on 15/5/20.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYCheckReviewStatusResp : CQBaseResponse

@property (nonatomic, copy) NSString *version;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval endTime;
@property (nonatomic, assign) BOOL reviewStatus;

@end

@interface HYCheckReviewStatusReq : CQBaseRequest

@end
