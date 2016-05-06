//
//  HYCommentAddOneStepReq.h
//  Teshehui
//
//  Created by HYZB on 15/10/17.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYCommentAddOneStepReq : CQBaseRequest

@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, copy) NSString *pageNo;
@property (nonatomic, copy) NSString *pageSize;

@end
