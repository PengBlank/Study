//
//  HYAfterSaleCancelRequest.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/15.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYAfterSaleCancelRequest : CQBaseRequest
@property (nonatomic, strong) NSString *flowCode;   //货单编号
@end
