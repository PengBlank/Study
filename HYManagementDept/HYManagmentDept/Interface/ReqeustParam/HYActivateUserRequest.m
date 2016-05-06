//
//  HYActivateUserRequest.m
//  Teshehui
//
//  Created by ichina on 14-3-1.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYActivateUserRequest.h"
#import "HYActivateUserReponse.h"

@implementation HYActivateUserRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
     self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/member_card_activate_step"];
        self.httpMethod = @"POST";
        self.postType = KeyValue;
        self.activate_type = 1;
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.agency_id length] > 0)
        {
            [newDic setObject:self.agency_id forKey:@"agency_id"];
        }
        
        if ([self.number length] > 0)
        {
            [newDic setObject:self.number forKey:@"number"];
        }
        
        if ([self.number_id length] > 0)
        {
            [newDic setObject:self.number_id forKey:@"number_id"];
        }

        if ([self.phone_mob length] > 0)
        {
            [newDic setObject:self.phone_mob forKey:@"phone_mob"];
        }

        if ([self.user_name length] > 0)
        {
            [newDic setObject:self.user_name forKey:@"user_name"];
        }

        if ([self.password length] > 0)
        {
            [newDic setObject:self.password forKey:@"password"];
        }

        if ([self.check_code length] > 0)
        {
            [newDic setObject:self.check_code forKey:@"check_code"];
        }
  
        if ([self.id_card length] > 0)
        {
            [newDic setObject:self.id_card forKey:@"id_card"];
        }
  
        if ([self.real_name length] > 0)
        {
            [newDic setObject:self.real_name forKey:@"real_name"];
        }

        if ([self.number_password length] > 0)
        {
            [newDic setObject:self.number_password forKey:@"number_password"];
        }
        
        if ([self.eamil length] > 0) {
            [newDic setObject:self.eamil forKey:@"eamil"];
        }
        
        NSString *cardType = nil;
        if (self.cardType == 1)
        {
            cardType = @"01";
        }
        else if (self.cardType == 2)
        {
            cardType = @"02";
        }
        else if (self.cardType == 3)
        {
            cardType = @"03";
        }
        else if (self.cardType == 5)
        {
            cardType = @"05";
        }
        else if (self.cardType == 6)
        {
            cardType = @"06";
        }
        else
        {
            cardType = [NSString stringWithFormat:@"%ld", (long)self.cardType];
        }
        
        [newDic setObject:cardType forKey:@"card_type"];
        
        if ([self.birthday length] > 0)
        {
            [newDic setObject:self.birthday forKey:@"birthday"];
        }
        
        if ([self.sex length] > 0)
        {
            [newDic setObject:self.sex forKey:@"gender"];
        }
        
        [newDic setObject:[NSNumber numberWithInteger:_activate_type]
                   forKey:@"activate_type"];
    }
    return newDic;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYActivateUserReponse *respose = [[HYActivateUserReponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
