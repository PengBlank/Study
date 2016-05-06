//
//  NSURL+HYURL.m
//  Teshehui
//
//  Created by HYZB on 15/1/29.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "NSURL+HYURL.h"

@implementation NSURL (HYURL)

- (NSDictionary *)queryParam
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    NSArray *array = [[self query] componentsSeparatedByString:@"&"];
    
    for (NSString *param in array)
    {
        NSArray *p = [param componentsSeparatedByString:@"="];
        
        if ([p count] >= 2)
        {
            NSString *key = [p objectAtIndex:0];
            NSString *value = [p objectAtIndex:1];
            
            [params setObject:value
                       forKey:key];
        }
    }
    
    return [params copy];
}

@end
