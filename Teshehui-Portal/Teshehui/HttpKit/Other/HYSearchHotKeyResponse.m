//
//  HYSearchHotKeyResponse.m
//  Teshehui
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYSearchHotKeyResponse.h"

@implementation HYSearchHotKeyResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", NSDictionary);
        NSArray *hotkeys = GETOBJECTFORKEY(data, @"hotKwList", NSArray);
        self.hotKeys = [HYSearchHotKey arrayOfModelsFromDictionaries:hotkeys];
        
        NSArray *serviceKeys = GETOBJECTFORKEY(data, @"liveServiceKwList", NSArray);
        self.serviceKeys = [HYSearchHotKey arrayOfModelsFromDictionaries:serviceKeys];
    }
    return self;
}

@end

@implementation HYSearchHotKey

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
