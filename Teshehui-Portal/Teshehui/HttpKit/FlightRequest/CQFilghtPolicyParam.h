//
//  CQFilghtPolicyParam.h
//  ComeHere
//
//  Created by ChengQian on 13-11-25.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQFilghtBaseRequest.h"

@interface CQFilghtPolicyParam : CQFilghtBaseRequest

//必须参数
@property (nonatomic, copy) NSString *offDate;
@property (nonatomic, copy) NSString *orgCity;
@property (nonatomic, copy) NSString *dstCity;

@property (nonatomic, copy) NSString *routeType;
@property (nonatomic, copy) NSString *week;
@property (nonatomic, copy) NSString *airCom;
@property (nonatomic, copy) NSString *flightNo;
@property (nonatomic, copy) NSString *flightCab;
@property (nonatomic, copy) NSString *contype;

@end
