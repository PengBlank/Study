//
//  CQflightDetail.m
//  Teshehui
//
//  Created by ChengQian on 13-11-25.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "HYFlightDetailInfo.h"
#import "HYFlightCity.h"
#import "NSDate+Addition.h"

@interface HYFlightDetailInfo ()

@property (nonatomic, strong) HYCabins *cheapCabins;
@property (nonatomic, copy) NSString *airlineDesc;

@end

@implementation HYFlightDetailInfo

- (id)initWithDictionary:(NSDictionary *)dict
{
    NSMutableDictionary *tempdec = [[NSMutableDictionary alloc]initWithDictionary:dict];
    NSDictionary *expand = [dict objectForKey:@"expandedResponse"];
    [tempdec addEntriesFromDictionary:expand];
    [tempdec removeObjectForKey:@"expandedResponse"];
    
    NSError *error = nil;
    self = [super initWithDictionary:tempdec error:&error];
    
    NSString *flightDate = [tempdec objectForKey:@"flightDate"];
    if (flightDate)
    {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:flightDate.floatValue];
        self.flightDate = [date timeDescription];
    }
    
    if (self)
    {
        NSArray *sku = GETOBJECTFORKEY(dict, @"productSKUArray", [NSArray class]);
        NSMutableArray *tempMuArr = [HYFlightSKU arrayOfModelsFromDictionaries:sku];
        self.productSKUArray = [tempMuArr copy];
        
    }
    return self;
}

@end
