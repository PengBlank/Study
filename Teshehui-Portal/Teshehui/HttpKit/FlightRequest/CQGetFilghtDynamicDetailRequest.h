//
//  CQGetFilghtDynamicDetailRequest.h
//  ComeHere
//
//  Created by ChengQian on 13-11-12.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQFilghtBaseRequest.h"

//http://dynamic.bnx6688.com/DynamicDetail/?DynamicID=2013-09-27MU5271SHASZX
@interface CQGetFilghtDynamicDetailRequest : CQFilghtBaseRequest

@property (nonatomic, copy) NSString *DynamicID;  //航班动态ID

@end
