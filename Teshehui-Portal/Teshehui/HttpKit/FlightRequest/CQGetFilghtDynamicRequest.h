//
//  CQGetFilghtDynamic.h
//  ComeHere
//
//  Created by ChengQian on 13-11-12.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQFilghtBaseRequest.h"

//2、获取会员航班动态订制
//http://dynamic.bnx6688.com/DynamicList/?UserID=80000000001
@interface CQGetFilghtDynamicRequest : CQFilghtBaseRequest

@property (nonatomic, copy) NSString *UserID;  //会员帐号

@end
