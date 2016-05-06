//
//  CloseTableRequest.h
//  Teshehui
//
//  Created by apple_administrator on 15/11/11.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface CloseTableRequest : CQBaseRequest
@property (nonatomic,strong) NSString *merId; //商家ID
@property (nonatomic,strong) NSString *btId; //球台ID
@property (nonatomic,strong) NSString *uId; //球台ID
@property (nonatomic,strong) NSString *orId; //订单ID
@end
