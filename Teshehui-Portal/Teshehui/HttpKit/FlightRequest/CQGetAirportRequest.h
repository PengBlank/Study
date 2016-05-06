//
//  CQGetAirportRequest.h
//  ComeHere
//
//  Created by ChengQian on 13-11-17.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQBaseRequest.h"

@interface CQGetAirportRequest : CQBaseRequest

//http://app.bnx6688.com/airport/?Cmd=SearchPortName&PortCode=PEK

//必须参数
@property (nonatomic, copy) NSString *Cmd;
@property (nonatomic, copy) NSString *PortCode;

@end
