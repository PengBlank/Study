//
//  HYAnalyticsBaseReq.m
//  Teshehui
//
//  Created by HYZB on 15/11/24.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYAnalyticsBaseReq.h"
#import "HYLocationManager.h"
#import <sys/sysctl.h>
#import "HYAnalyticsBaseParams.h"

@implementation HYAnalyticsBaseReq

- (NSDictionary *)getJsonDictionary
{
    [(HYAnalyticsBaseParams *)self.requestParams setApp_ver:self.clientVersion];
    NSString *jsonString = [self.requestParams toJSONString];
    DebugNSLog(@"analytics data: %@", jsonString);
    return [NSDictionary dictionaryWithObjectsAndKeys:jsonString, @"data", nil];
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = @"http://xres.teshehui.com/xclk/vo";
        self.httpMethod = @"POST";
        
        self.site_id = @"1001";
        self.channel_id = @"1002";
        self.device_type = @"1";
        self.app_ver = self.clientVersion;
        self.phone_model = [self platformString];
        self.os_msg = [self systemVersion];
        
        //经纬度
        HYLocationManager *manager = [HYLocationManager sharedManager];
        HYLocateResultInfo *addrInfo = [manager getCacheAddress];
        
        if (addrInfo)
        {
            self.longitude = [NSString stringWithFormat:@"%lf", addrInfo.lon];
            self.latitude = [NSString stringWithFormat:@"%lf", addrInfo.lat];
            self.ll_type = @"1";
        }
        else
        {
            self.longitude = @"0";
            self.latitude = @"0";
            self.ll_type = @"1";
        }
    }
    
    return self;
}

- (NSString *)xres_uid
{
    if (!_xres_uid)
    {
        NSString *cache = [[NSUserDefaults standardUserDefaults] objectForKey:kXresUid];
        if (cache)
        {
            _xres_uid = cache;
        }
        else
        {
            NSMutableString *hexString = [NSMutableString string];
            for (int i=0; i<20; i++)
            {
                int begin = arc4random() % 4;
                switch (begin)
                {
                    case 0:
                    case 1:
                        begin = arc4random()%26+97;
                        break;
                    case 2:
                        begin = arc4random()%26+65;
                        break;
                    case 3:
                        begin = arc4random()%10+48;
                        break;
                    default:
                        break;
                }
                
                NSString *string =[NSString stringWithFormat:@"%c",begin]; //A
                [hexString appendString:string];
            }
            _xres_uid = [hexString copy];
            
            [[NSUserDefaults standardUserDefaults] setObject:_xres_uid
                                                      forKey:kXresUid];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    return _xres_uid;
}

- (NSString *)systemVersion
{
    return [NSString stringWithFormat:@"%@ %@", [[UIDevice currentDevice] systemName],
            [[UIDevice currentDevice] systemVersion]];
}

//查询终端型号;
- (NSString *) platform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

- (NSString *)platformString
{
    NSString *platform = [self platform];
    
    //iphone
    if ([platform isEqualToString:@"iPhone1,1"])
        return @"iPhone";
    if ([platform isEqualToString:@"iPhone1,2"])
        return @"iPhone3G";
    if ([platform isEqualToString:@"iPhone2,1"])
        return @"iPhone3GS";
    if ([platform isEqualToString:@"iPhone3,1"])
        return @"iPhone4";
    if ([platform isEqualToString:@"iPhone4,1"])
        return @"iPhone4S";
    if ([platform isEqualToString:@"iPhone5,1"] || [platform isEqualToString:@"iPhone5,2"])
        return @"iPhone5";
    if ([platform isEqualToString:@"iPhone5,3"] || [platform isEqualToString:@"iPhone5,4"])
        return @"iPhone5C";
    if ([platform isEqualToString:@"iPhone6"])
        return @"iPhone5s";
    if ([platform isEqualToString:@"iPhone7,2"])
        return @"iPhone6";
    if ([platform isEqualToString:@"iPhone7,1"])
        return @"iPhone6Plus";
    if ([platform isEqualToString:@"iPhone8,1"])
        return @"iPhone6s";
    if ([platform isEqualToString:@"iPhone8,2"])
        return @"iPhone6s Plus";
    
    //ipod
    if ([platform isEqualToString:@"iPod1,1"])
    {
        return @"iPod Touch 1";
    }
    if ([platform isEqualToString:@"iPod2,1"])
    {
        return @"iPod Touch 2";
    }
    if ([platform isEqualToString:@"iPod3,1"])
    {
        return @"iPod Touch 3";
    }
    if ([platform isEqualToString:@"iPod4,1"])
    {
        return @"iPod Touch 4";
    }
    if ([platform isEqualToString:@"iPod5,1"])
    {
        return @"iPod Touch 5";
    }
    
    //ipad
    if ([platform isEqualToString:@"iPad1,1"])
        return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])
        return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])
        return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])
        return @"iPad 2 (CDMA)";
    if([platform isEqualToString:@"iPad3,1"] || [platform isEqualToString:@"iPad3,2"] || [platform isEqualToString:@"iPad3,3"])
        return @"iPad 3";
    if([platform isEqualToString:@"iPad3,4"] || [platform isEqualToString:@"iPad3,5"] || [platform isEqualToString:@"iPad3,6"])
        return @"iPad 4";
    if([platform isEqualToString:@"iPad2,5"] || [platform isEqualToString:@"iPad2,6"] || [platform isEqualToString:@"iPad2,7"])
        return @"iPad Mini";
    if([platform isEqualToString:@"iPad4,4"] || [platform isEqualToString:@"iPad4,5"] || [platform isEqualToString:@"iPad4,6"])
        return @"iPad Mini2";
    if([platform isEqualToString:@"iPad4,7"] || [platform isEqualToString:@"iPad4,8"] || [platform isEqualToString:@"iPad4,9"])
        return @"iPad Mini3";
    if([platform isEqualToString:@"iPad4,1"] || [platform isEqualToString:@"iPad4,2"] || [platform isEqualToString:@"iPad4,3"])
        return @"iPad Air";
    if([platform isEqualToString:@"iPad5,1"] || [platform isEqualToString:@"iPad5,2"] || [platform isEqualToString:@"iPad5,3"])
        return @"iPad Air2";
        
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"])
    {
        return @"iPhone Simulator";
    }
    
    return platform;
}

@end
