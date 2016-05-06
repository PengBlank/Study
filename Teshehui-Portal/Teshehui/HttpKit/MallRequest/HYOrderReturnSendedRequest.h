//
//  HYOrderReturnSendedRequest.h
//  Teshehui
//
//  Created by RayXiang on 14-9-25.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYOrderReturnSendedResponse.h"

@interface HYOrderReturnSendedRequest : CQBaseRequest

@property (nonatomic, strong) NSString *request_id; //申请id，猜测是return_id
@property (nonatomic, strong) NSString *express_company;    //快递公司代码
@property (nonatomic, strong) NSString *invoice_no; //快递单号

@end
