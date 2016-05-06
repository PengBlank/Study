//
//  HYGetTranscationTypeResponse.m
//  Teshehui
//
//  Created by Kris on 15/7/21.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYGetTranscationTypeResponse.h"

@implementation HYBusinessType

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

@implementation HYGetTranscationTypeResponse
- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSArray *data = GETOBJECTFORKEY(dictionary, @"data", [NSArray class]);
        
        self.supportTypes = [[HYBusinessType arrayOfModelsFromDictionaries:data] copy];
    }
    return self;
}
@end
