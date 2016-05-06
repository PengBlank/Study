//
//  HYVisitObjectReq.m
//  Teshehui
//
//  Created by HYZB on 15/11/24.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYVisitObjectReq.h"
#import "JSONKit_HY.h"

@implementation HYVisitObjectReq

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    
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
    if (self.obj_code) {
        [newDict setObject:self.obj_code forKey:@"obj_cod"];
    }
    if (self.obj_type)
    {
        [newDict setObject:self.obj_type forKey:@"obj_type"];
    }
    if (self.category_code)
    {
        [newDict setObject:self.category_code forKey:@"category_code"];
    }
    if (self.brand_code)
    {
        [newDict setObject:self.brand_code forKey:@"brand_code"];
    }
    if (self.tsh_price)
    {
        [newDict setObject:self.tsh_price forKey:@"tsh_price"];
    }
    if (self.ref_page_id)
    {
        [newDict setObject:self.ref_page_id forKey:@"ref_page_id"];
    }
    
    if (self.scene_id)
    {
        [newDict setObject:self.scene_id forKey:@"scene_id"];
    }
    if (self.algorithm_ind)
    {
        [newDict setObject:self.algorithm_ind forKey:@"algorithm_ind"];
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
