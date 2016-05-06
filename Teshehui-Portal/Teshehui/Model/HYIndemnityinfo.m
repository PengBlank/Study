//
//  HYIndemntifyinfo.m
//  Teshehui
//
//  Created by HYZB on 15/4/2.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYIndemnityinfo.h"
#import "HYIndemnityProgress.h"

@implementation HYIndemnityinfo

//- (id)initWithDataInfo:(NSDictionary *)data
//{
//    self = [super init];
//    if (self)
//    {
//        self.indId = GETOBJECTFORKEY(data, @"id", [NSString class]);
//        self.compareURL = GETOBJECTFORKEY(data, @"compare_url", [NSString class]);
//        self.desc = GETOBJECTFORKEY(data, @"description", [NSString class]);
//        
//        self.imgs = GETOBJECTFORKEY(data, @"img_arr", [NSArray class]);
//        
//        // progress
//        NSArray *progress = GETOBJECTFORKEY(data, @"audit_arr", [NSArray class]);
//        if ([progress count] > 0)
//        {
//            NSMutableArray *muTempArr = [[NSMutableArray alloc] init];
//            for (id obj in progress)
//            {
//                HYIndemnityProgress *p = [[HYIndemnityProgress alloc] initWithDataInfo:obj];
//                [muTempArr addObject:p];
//            }
//            self.progressList = [muTempArr copy];
//        }
//    }
//    
//    return self;
//}
+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}


+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"orderLogPOList":@"progressList",
                                                      @"imageUrlList": @"imgs",
                                                      @"compareUrl": @"compareURL",
                                                      @"description": @"desc"}];
}
/*
@"progressList":@"orderLogPOList",
@"imgs": @"imageUrlList",
@"compareURL": @"compareUrl",
@"desc": @"description"}]
*/
@end
