//
//  HYPolicy.m
//  Teshehui
//
//  Created by HYZB on 15/3/31.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYPolicy.h"

@implementation HYPolicy

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

- (id) initWithCoder: (NSCoder *) coder
{
    self = [super init];
    
    if (self) {
        
        self.renewal = [coder decodeObjectForKey:@"renewal"];
        self.expiredDay = [coder decodeObjectForKey:@"expiredDay"];
        self.renewalFee  = [coder decodeObjectForKey:@"renewalFee"];
        self.points  = [coder decodeObjectForKey:@"points"];
        self.policyType = [coder decodeObjectForKey:@"policyType"];
       
    }
    
    return self;
}

-(void) encodeWithCoder:(NSCoder *)encoder
{
    if (self.renewal)
    {
        [encoder encodeObject:self.renewal
                       forKey:@"user_id"];
    }
    if (self.expiredDay)
    {
        [encoder encodeObject:self.expiredDay
                       forKey:@"expiredDay"];
    }
    if (self.renewalFee)
    {
        [encoder encodeObject:self.renewalFee
                       forKey:@"renewalFee"];
    }
    if (self.policyType)
    {
        [encoder encodeObject:self.policyType
                       forKey:@"policyType"];
    }
    if (self.points)
    {
        [encoder encodeObject:self.points
                       forKey:@"points"];
    }
}

@end
