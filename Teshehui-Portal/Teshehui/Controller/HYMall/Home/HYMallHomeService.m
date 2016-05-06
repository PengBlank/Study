//
//  HYMallHomeService.m
//  Teshehui
//
//  Created by 成才 向 on 16/3/23.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallHomeService.h"
#import "HYMallHomePageRequest.h"
#import "HYMallMoreGoodsRequest.h"
#import "HYGetTranscationTypeRequest.h"

@implementation HYMallHomeService
{
    HYMallHomePageRequest *_homeBoardReq;
    HYMallMoreGoodsRequest *_moreGoodsReq;
    HYGetTranscationTypeRequest *_getSupportBsTypeReq;
}

- (void)dealloc
{
    [_homeBoardReq cancel];
    _homeBoardReq = nil;
}

/// 获取首页数据
- (void)loadHomeBoardsWithInterestTags:(NSArray *)tags
                             isChanged:(BOOL)changed
                              callback:(void (^)(NSArray *boards, NSError *err))callback
{
    if (_homeBoardReq) {
        [_homeBoardReq cancel];
        _homeBoardReq = nil;
    }
    
    _homeBoardReq = [[HYMallHomePageRequest alloc] init];
    NSArray *requestTypes = @[@(MallHomeAds),
                              @(MallHomeActive),
                              @(MallHomeMore),
                              @(MallHomeEspCheap),
                              @(MallHomeTextAds),
                              @(MallHomeBrand),
                              @(MallHomeBrandAds),
                              @(MallHomeShoppingPlace),
                              @(MallHomeImageAds),
                              @(MallHomeInterestTag)];
    NSMutableArray *typesStrs = [NSMutableArray array];
    for (NSNumber *type in requestTypes) {
        [typesStrs addObject:[NSString stringWithFormat:@"%02ld", (long)type.integerValue]];
    }
    NSString *boardtypestr = [typesStrs componentsJoinedByString:@","];
    _homeBoardReq.boardCodes = boardtypestr;
    _homeBoardReq.whetherChange = changed;
    
    if (tags.count > 0) {
        _homeBoardReq.tags = [tags componentsJoinedByString:@","];
    }
    
    [_homeBoardReq sendReuqest:^(id result, NSError *error) {
        HYMallHomePageResponse *response = nil;
        if (result && [result isKindOfClass:[HYMallHomePageResponse class]])
        {
            response = (HYMallHomePageResponse *)result;
        }
        
        if (response.homeItems.count > 0)
        {
            callback(response.homeItems, nil);
        }
        else if (error)
        {
            callback(nil, error);
        }
    }];
}

- (void)loadAllInterestTags:(void (^)(NSArray *items))callback
{
    if (_homeBoardReq) {
        [_homeBoardReq cancel];
        _homeBoardReq = nil;
    }
    
    _homeBoardReq = [[HYMallHomePageRequest alloc] init];
    NSArray *requestTypes = @[@(MallHomeInterestTag)];
    NSMutableArray *typesStrs = [NSMutableArray array];
    for (NSNumber *type in requestTypes) {
        [typesStrs addObject:[NSString stringWithFormat:@"%02ld", type.integerValue]];
    }
    NSString *boardtypestr = [typesStrs componentsJoinedByString:@","];
    _homeBoardReq.boardCodes = boardtypestr;
    _homeBoardReq.whetherChange = NO;
    
    _homeBoardReq.tags = @"-1";
    [_homeBoardReq sendReuqest:^(id result, NSError *error) {
        HYMallHomePageResponse *response = nil;
        if (result && [result isKindOfClass:[HYMallHomePageResponse class]])
        {
            response = (HYMallHomePageResponse *)result;
        }
        
        if (response.homeItems.count > 0)
        {
            HYMallHomeBoard *board = response.homeItems[0];
            callback(board.programPOList);
        }
        else if (error)
        {
            callback(nil);
        }
    }];
}

- (void)loadHomeBoardWithTypes:(NSArray *)requestTypes
                     isChanged:(BOOL)changed
                  interestTags:(NSIndexSet *)tags
                      callback:(void (^)(NSArray *boards, NSError *err))callback
{
    
}

- (void)loadRecmGoodsWithPage:(NSInteger)page callback:(void (^)(NSArray *goods))callback
{
    _moreGoodsReq = [[HYMallMoreGoodsRequest alloc] init];
    _moreGoodsReq.pageNo = page;
    
    [_moreGoodsReq sendReuqest:^(id result, NSError *error) {
        NSArray* array;
        if (result && [result isKindOfClass:[HYMallMoreGoodsResponse class]])
        {
            HYMallMoreGoodsResponse *response = (HYMallMoreGoodsResponse *)result;
            if (response.status == 200)
            {
                array = response.products;
            }
        }
        
        callback(array);
    }];
}

- (void)fetchTransactionTypes:(void (^)(NSArray *types))callback
{
    _getSupportBsTypeReq = [[HYGetTranscationTypeRequest alloc] init];
    
    [_getSupportBsTypeReq sendReuqest:^(id result, NSError *error) {
        if ([result isKindOfClass:[HYGetTranscationTypeResponse class]])
        {
            HYGetTranscationTypeResponse *resp = (HYGetTranscationTypeResponse *)result;
            if (resp.status == 200)
            {
                callback(resp.supportTypes);
            }
        }
    }];
}

@end
