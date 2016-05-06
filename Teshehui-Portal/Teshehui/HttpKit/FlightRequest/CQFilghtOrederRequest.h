//
//  CQFilghtOreder.h
//  ComeHere
//
//  Created by ChengQian on 13-11-25.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQFilghtBaseRequest.h"
#import "CQFlightOrderString.h"
#import "CQPassengers.h"

@interface CQFilghtOrederRequest : CQFilghtBaseRequest

//必须参数
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *UserID;
@property (nonatomic, copy) NSString *IsChild;
@property (nonatomic, copy) NSString *FlightString;

@property (nonatomic, strong) CQFlightOrderString *filght;
@property (nonatomic, strong) NSArray *passengers;

@end

