//
//  TYAnalyseScenePageReq.m
//  Teshehui
//
//  Created by apple_administrator on 16/4/20.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "TYAnalyseScenePageReq.h"
#import "JSONKit_HY.h"
@implementation TYAnalyseScenePageReq
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.interfaceURL = @"http://xres.teshehui.com/xclk/pv2";
        self.site_id = @"1002";
    }
    return self;
}

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
    
    
    //私有参数
    
    if (self.goods_id) {
        [newDict setObject:self.goods_id forKey:@"goods_id"];
    }
    
    if (self.obj_type)
    {
        [newDict setObject:@(self.obj_type) forKey:@"obj_type"];
    }
    
    if (self.ref_page_id)
    {
        [newDict setObject:self.ref_page_id forKey:@"ref_page_id"];
    }
    
    if (self.nowt)
    {
        [newDict setObject:self.nowt forKey:@"nowt"];
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
