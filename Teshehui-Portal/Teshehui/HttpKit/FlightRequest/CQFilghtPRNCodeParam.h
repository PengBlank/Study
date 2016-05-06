//
//  CQFilghtPRNCodeParam.h
//  ComeHere
//
//  Created by ChengQian on 13-11-27.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQFilghtBaseRequest.h"
#import "CQPassengers.h"
#import "CQFilghtRoute.h"

@interface CQFilghtPRNCodeParam : CQFilghtBaseRequest
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) CQFilghtRoute *routes;
@property (nonatomic, strong) NSArray *passengers;
@property (nonatomic, copy) NSString *osimobile;
@property (nonatomic, copy) NSString *officeid;
@end
