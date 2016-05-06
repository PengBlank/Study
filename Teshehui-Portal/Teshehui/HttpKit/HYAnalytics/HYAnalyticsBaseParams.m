//
//  HYAnalyticsBaseParams.m
//  Teshehui
//
//  Created by 成才 向 on 16/1/13.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYAnalyticsBaseParams.h"
#import "HYLocationManager.h"
#import <sys/sysctl.h>
#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <net/if.h>
#import <arpa/inet.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "HYUserInfo.h"
#import "GetIPAddress.h"
#import <AdSupport/AdSupport.h>

@implementation HYAnalyticsBaseParams

- (instancetype)init
{
    if (self = [super init])
    {
        self.site_id = @"1001";
        self.channel_id = @"1002";
        self.device_type = @"1";
        self.phone_model = [self platformString];
        self.os_msg = [self systemVersion];
        self.ip = [self getDeviceIPIpAddresses];
        self.user_id = [HYUserInfo getUserInfo].userId;
        self.qd_key = @"Channel ID";
        self.nk_type = [self getCurrNetworkStatusTo];
        self.nk_opt = [self getCurrCarrierName];
        
        //iOS的mac 用广告的idfa
        self.mac = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        
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


/*
 1：中国移动
 2：中国联通
 3：中国电信
 4：中国网通
 5：中国铁通
 6：中国卫通
 */
- (NSNumber *)getCurrCarrierName
{
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carr = networkInfo.subscriberCellularProvider;
    NSInteger code = [[carr mobileNetworkCode] integerValue];
    switch (code)
    {
        case 0:  //移动
        case 2:
        case 7:
            return [NSNumber numberWithInt:1];
            break;
        case 1:  //联通
        case 6:
            return [NSNumber numberWithInt:1];
            break;
        case 3:  //电信
        case 5:
            return [NSNumber numberWithInt:1];
            break;
        case 20:  //铁通
            return [NSNumber numberWithInt:5];
            break;
        default:
            break;
    }
    
    return nil;
}

- (NSNumber *)getCurrNetworkStatusTo
{
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"]subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews)
    {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]])
        {
            dataNetworkItemView = subview;
            break;
        }
    }
    switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"]integerValue]) {
        case 0:
            return [NSNumber numberWithInt:0];
            break;
        case 1:
            return [NSNumber numberWithInt:2];  //2G
            break;
        case 2:
            return [NSNumber numberWithInt:3];  //3G
            break;
        case 3:
            return [NSNumber numberWithInt:4];  //4G
            break;
        case 4:
            return [NSNumber numberWithInt:5];  //5G
            break;
        case 5:
            return [NSNumber numberWithInt:1];  //wifi
            break;
            
        default:
            break;
    }
    
    return nil;
}

- (NSString *)getDeviceIPIpAddresses
{
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    
    if (sockfd < 0)
        return nil;
    
    NSMutableArray *ips = [NSMutableArray array];
    
    int BUFFERSIZE = 4096;
    
    struct ifconf ifc;
    
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    
    struct ifreq *ifr, ifrcopy;
    
    ifc.ifc_len = BUFFERSIZE;
    
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0){
        
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            
            ifr = (struct ifreq *)ptr;
            
            int len = sizeof(struct sockaddr);
            
            if (ifr->ifr_addr.sa_len > len) {
                
                len = ifr->ifr_addr.sa_len;
                
            }
            
            ptr += sizeof(ifr->ifr_name) + len;
            
            if (ifr->ifr_addr.sa_family != AF_INET) continue;
            
            if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) *cptr = 0;
            
            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) continue;
            
            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            
            ifrcopy = *ifr;
            
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
            
            if ((ifrcopy.ifr_flags & IFF_UP) == 0) continue;
            
            NSString *ip = [NSString  stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            
            [ips addObject:ip];
        }
    }
    
    close(sockfd);
    
    NSString *deviceIP = nil;
    
    for (int i=0; i < ips.count; i++)
    {
        if (ips.count > 0)
        {
            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
        }
    }
    
    return deviceIP;
}

//查询终端型号;
- (NSString *)platform{
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
