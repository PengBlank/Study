//
//  HYGetPayNOResponse.h
//  Teshehui
//
//  Created by 回亿资本 on 14-3-12.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "WXApiObject.h"

@interface HYGetPayNOResponse : CQBaseResponse

@property (nonatomic, copy, readonly) NSString *tradeItemCode;
@property (nonatomic, copy, readonly) NSString *ylPrepayNo;
@property (nonatomic, copy, readonly) NSString *cashAmount;
@property (nonatomic, copy, readonly) NSString *notifyUrl;

@property (nonatomic, strong, readonly) PayReq *wxPayInfo;

@end
