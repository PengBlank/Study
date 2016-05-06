//
//  TYAnalyticsManager.m
//  Teshehui
//
//  Created by apple_administrator on 16/4/20.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "TYAnalyticsManager.h"

@implementation TYAnalyticsManager
+ (instancetype)sharedManager
{
    static TYAnalyticsManager *__sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedManager = [[TYAnalyticsManager alloc] init];
    });
    return __sharedManager;
}


- (void)sendAnalyseForSceneDetailPage:(O2OScenePageType)pageType
                               packId:(NSString *)packId
                       pageIdentifier:(NSString *)pageIdentifier
                     toPageIdentifier:(NSString *)toPageIdentifier
{

    TYAnalyseScenePageReq *req = [[TYAnalyseScenePageReq alloc] init];
    req.obj_type    = pageType;
    req.ref_page_id = pageIdentifier;
    req.nowt        = toPageIdentifier;
    [req sendReuqest:nil];
}

- (void)sendAnalyseForSceneBtnClick:(O2OSceneButtonType)buttonType
{
    TYAnalyseSceneBtnReq *req = [[TYAnalyseSceneBtnReq alloc] init];
    req.cid    = buttonType;
    [req sendReuqest:nil];
}

- (void)sendAnalyseForSceneShareType:(O2OSceneShareType)shareType
{
    
    TYAnalyseSceneShareBtnReq *req = [[TYAnalyseSceneShareBtnReq alloc] init];
    req.s_type    = shareType;
    [req sendReuqest:nil];
}


@end
