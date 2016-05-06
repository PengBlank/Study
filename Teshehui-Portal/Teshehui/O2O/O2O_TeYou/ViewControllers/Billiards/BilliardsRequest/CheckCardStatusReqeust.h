//
//  CheckCardStatusReqeust.h
//  Teshehui
//
//  Created by apple_administrator on 15/11/11.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface CheckCardStatusReqeust : CQBaseRequest
@property (nonatomic,strong) NSString *cardNo; //会员卡号
@property (nonatomic,strong) NSString *merId; //商家ID
@end
