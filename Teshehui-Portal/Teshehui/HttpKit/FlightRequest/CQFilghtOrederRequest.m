//
//  CQFilghtOreder.m
//  ComeHere
//
//  Created by ChengQian on 13-11-25.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQFilghtOrederRequest.h"
#import "CQFilghtOrederResponse.h"

@implementation CQFilghtOrederRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = @"http://app.bnx6688.com/airorder/";
        self.httpMethod = @"POST";
        
        //固定值
        self.uid = @"bnxapp";
        self.key = @"8g92f8e0-65b9-45aa-a2d2-1c4b9e2bd587";
        self.IsChild = @"0";
    }
    
    return self;
}


- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.uid length] > 0)
        {
            [newDic setObject:self.uid
                       forKey:@"uid"];
        }
        
        if ([self.key length] > 0)
        {
            [newDic setObject:self.key
                       forKey:@"key"];
        }
        
        if ([self.UserID length] > 0)
        {
            [newDic setObject:self.UserID
                       forKey:@"userid"];
        }
        
        self.FlightString = [self.filght flightOrderString];
        if ([self.FlightString length] > 0)
        {
            [newDic setObject:self.FlightString
                       forKey:@"FlightString"];
        }
        
        NSMutableArray *mupass = [[NSMutableArray alloc] init];
        for (CQPassengers *p in self.passengers)
        {
            if (!p.Mobile)
            {
                p.Mobile = self.filght.Mobile;
            }
            NSString *pstr = [p passengersString];
            
            if ([pstr length] > 0)
            {
                [mupass addObject:pstr];
            }
        }
        NSString *p = [mupass componentsJoinedByString:@"$"];
        if ([p length] > 0)
        {
            [newDic setObject:p
                       forKey:@"passengers"];
        }
        
        if (self.IsChild)
        {
            [newDic setObject:self.IsChild
                       forKey:@"IsChild"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    CQFilghtOrederResponse *respose = [[CQFilghtOrederResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
