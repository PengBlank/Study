//
//  HYVisitAnalyticsParams.m
//  Teshehui
//
//  Created by 成才 向 on 16/1/13.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYVisitAnalyticsParams.h"

@implementation HYVisitAnalyticsParams

- (instancetype)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

+ (instancetype)homeVisitParam
{
    HYVisitAnalyticsParams *param = [[HYVisitAnalyticsParams alloc] init];
    param.obj_type = @"1";
    param.obj_code = @"APP";
    return param;
}
+ (instancetype)webpageVisitParamWithURL:(NSString *)url
{
    HYVisitAnalyticsParams *param = [[HYVisitAnalyticsParams alloc] init];
    param.obj_type = @"99";
    param.obj_code = url;
    return param;
}
+ (instancetype)productListPageVisitParam
{
    HYVisitAnalyticsParams *param = [[HYVisitAnalyticsParams alloc] init];
    
    return param;
}

+ (instancetype)listPageVisitParamWithType:(HYListPageFromType)type
                              withListCode:(NSString *)cateCode
                             withBoardCode:(NSString *)boardCode
                                bannerCode:(NSString *)bannerCode
                                bannerType:(NSString *)bt
                                  fromPage:(NSInteger)fromPage
                              additionInfo:(NSDictionary *)addition
                                     stgid:(NSString *)stgid
{
    NSDictionary *typeMapping = @{@(HYListPageFromCate): @"3",
                                  @(HYListPageFromBrand): @"4",
                                  @(HYListPageFromChannel): @"5",
                                  @(HYListPageFromActivity): @"6",
                                  @(HYListPageFromStore): @"7",
                                  @(HYListPageFromSearch): @"8"};
    
    HYVisitAnalyticsParams *param = [[HYVisitAnalyticsParams alloc] init];
    param.obj_type = [typeMapping objectForKey:@(type)];
    param.obj_code = cateCode;
    param.stg_id = stgid;
    
    if (boardCode && bannerCode) {
        NSString *bbxt = [NSString stringWithFormat:@"%@|%@|%@", boardCode, bannerCode, bt];
        param.bbxt = bbxt;
    }
    
    param.pt = [NSString stringWithFormat:@"%d", (int)fromPage];
    
    param.vt = @"2";
    
    if (addition)
    {
        @try {
            [param setValuesForKeysWithDictionary:addition];
        }
        @catch (NSException *exception) {
            DebugNSLog(@"%@", exception);
        }
    }
    
    return param;
}

#pragma mark setter/getter
- (void)setStg_id:(NSString *)stg_id
{
    if (stg_id != _stg_id)
    {
        _stg_id = stg_id;
        if (stg_id)
        {
            self.channel_id = @"1003";
        }
        else
        {
            self.channel_id = @"1002";
        }
    }
}

@end
