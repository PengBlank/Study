//
//  HYMallOrderDetail.m
//  Teshehui
//
//  Created by HYZB on 14-9-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallOrderDetail.h"

@implementation HYMallOrderDetail

//- (id)initWithDataInfo:(NSDictionary *)data
//{
//    self = [super initWithDataInfo:data];
//    
//    if (self)
//    {
//        NSDictionary *addr = [data objectForKey:@"order_extm"];
//        if ([addr count] > 0)
//        {
//            self.address = [[HYAddressInfo alloc] initWithDataInfo:addr];
//        }
//        
//        NSArray *refounds = GETOBJECTFORKEY(data,@"order_refund",[NSArray class]);
//        
//        NSMutableArray *muTempArray = [[NSMutableArray alloc] init];
//        
//        for (NSDictionary *obj in refounds)
//        {
//            HYMallReturnsInfo *item = [[HYMallReturnsInfo alloc] initWithDataInfo:obj];
//            [muTempArray addObject:item];
//        }
//        
//        self.refoundsList = [muTempArray copy];
//    }
//    
//    return self;
//}

@end
