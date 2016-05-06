//
//  HYPurchaseItemReq.m
//  Teshehui
//
//  Created by HYZB on 15/11/25.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYPurchaseItemReq.h"
#import "JSONKit_HY.h"

@implementation HYOrderItem
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end

@implementation HYPurchaseItemReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = @"http://xres.teshehui.com/xclk/pi";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    if (self.stg_id)  //wap
    {
        self.channel_id = @"1003";
        [newDict setObject:self.stg_id
                    forKey:@"stg_id"];
    }
    if (self.userId)
    {
        [newDict setObject:self.userId forKey:@"user_id"];
    }
    if (self.xres_uid)
    {
        [newDict setObject:self.xres_uid forKey:@"xres_uid"];
    }
    if (self.site_id)
    {
        [newDict setObject:self.site_id forKey:@"site_id"];
    }
    if (self.channel_id)
    {
        [newDict setObject:self.channel_id forKey:@"channel_id"];
    }
    if (self.device_no)
    {
        [newDict setObject:self.device_no forKey:@"device_no"];
    }
    if (self.device_type)
    {
        [newDict setObject:self.device_type forKey:@"device_type"];
    }
    if (self.app_ver)
    {
        [newDict setObject:self.app_ver forKey:@"app_ver"];
    }
    if (self.phone_model)
    {
        [newDict setObject:self.phone_model forKey:@"phone_model"];
    }
    if (self.os_msg)
    {
        [newDict setObject:self.os_msg forKey:@"os_msg"];
    }
    if (self.longitude)
    {
        [newDict setObject:self.longitude forKey:@"longitude"];
    }
    if (self.latitude)
    {
        [newDict setObject:self.latitude forKey:@"latitude"];
    }
    if (self.ll_type)
    {
        [newDict setObject:self.ll_type forKey:@"ll_type"];
    }
    if (self.oc) {
        [newDict setObject:self.oc forKey:@"oc"];
    }
    
    if ([self.order_detail count])
    {
        NSArray *dicArr = [HYOrderItem arrayOfDictionariesFromModels:self.order_detail];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:dicArr options:0 error:nil];
        NSString *json = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
        
        if (json)
        {
            [newDict setObject:json forKey:@"order_detail"];
        }
    }
    
    NSString *dataStr = [newDict JSONString];
    if (dataStr)
    {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:dataStr,
                              @"data", nil];
        return data;
    }
    
    return nil;
}

@end
