//
//  HYRedpacketInfo.m
//  Teshehui
//
//  Created by HYZB on 15/1/27.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYRedpacketInfo.h"

@implementation HYRedpacketInfo

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.rpID    = [GETOBJECTFORKEY(data, @"id", [NSString class]) intValue];
        self.code = GETOBJECTFORKEY(data, @"code", [NSString class]);
        self.receive_code = GETOBJECTFORKEY(data, @"receive_code", [NSString class]);
        self.total_amount   = [GETOBJECTFORKEY(data, @"total_amount", [NSString class]) intValue];
        self.greetings    = GETOBJECTFORKEY(data, @"greetings", [NSString class]);
        self.created  = GETOBJECTFORKEY(data, @"created", [NSString class]);
        self.title  = GETOBJECTFORKEY(data, @"title", [NSString class]);
        self.short_title  = GETOBJECTFORKEY(data, @"short_title", [NSString class]);
        //self.is_receive = [GETOBJECTFORKEY(data, @"is_receive", [NSString class]) integerValue];
        self.is_luck = [GETOBJECTFORKEY(data, @"is_luck", [NSString class]) integerValue];
        self.luck_quantity = [GETOBJECTFORKEY(data, @"luck_quantity", [NSString class]) integerValue];
        self.luck_quantuty_used = [GETOBJECTFORKEY(data, @"luck_quantity_used", [NSString class]) integerValue];
        self.luck_password = GETOBJECTFORKEY(data, @"luck_password", NSString);
        
        self.packet_type = [GETOBJECTFORKEY(data, @"packet_type", NSString) integerValue];
        self.luck_amount_used = [GETOBJECTFORKEY(data, @"luck_amount_used", NSString) integerValue];
        self.receive_user_name = GETOBJECTFORKEY(data, @"receive_user_name", NSString);
        self.send_user_name = GETOBJECTFORKEY(data, @"send_user_name", NSString);
        self.phone_mob = GETOBJECTFORKEY(data, @"phone_mob", NSString);
        
        self.status = [GETOBJECTFORKEY(data, @"status", NSString) intValue];
        
        self.receive_total_amount = [GETOBJECTFORKEY(data, @"receive_total_amount", NSString) integerValue];
    }
    
    return self;
}


@end
