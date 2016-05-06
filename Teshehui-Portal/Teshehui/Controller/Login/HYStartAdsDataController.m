//
//  HYStartAdsDataController.m
//  Teshehui
//
//  Created by Kris on 16/1/5.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYStartAdsDataController.h"
#import "HYMallHomePageRequest.h"
#import "HYMallHomePageResponse.h"
#import "HYMallAdsReq.h"
#import "HYMallAdsResponse.h"
#import "SDWebImageManager.h"

@interface HYStartAdsDataController ()
{
    HYMallAdsReq *_mallHomePageRequest;
}

@end

@implementation HYStartAdsDataController

-(void)dealloc
{
    [_mallHomePageRequest cancel];
}

- (void)fetchStartAdsDataWithCallback:(StartAdsDataCallback)callback
{
    _mallHomePageRequest = [[HYMallAdsReq alloc] init];
    _mallHomePageRequest.boardCodes = @"90";
    [HYLoadHubView show];
    
    [_mallHomePageRequest sendReuqest:^(HYMallAdsResponse *result, NSError *error)
     {
         [HYLoadHubView dismiss];
        
         if (result.homeItems.count > 0)
         {
             HYMallHomeBoard *board = result.homeItems[0];
             if (board.programPOList.count > 0)
             {
                 callback(board);
             }
         }
     }];
}

-(void)fetchAllAdsDataWithCallback:(StartAdsDataCallback)callback1
                       andSecBlock:(StartHomeAdsDataCallback)callback2
{
    if (!_mallHomePageRequest)
    {
         _mallHomePageRequest = [[HYMallAdsReq alloc] init];
    }
    [_mallHomePageRequest cancel];
    
    WS(weakSelf);
    _mallHomePageRequest.boardCodes = @"90,91";
    [HYLoadHubView show];
    
    [_mallHomePageRequest sendReuqest:^(HYMallAdsResponse *result, NSError *error)
     {
         [HYLoadHubView dismiss];

         BOOL hasBrand = NO;
         BOOL hasBrandAds = NO;
         
         if (result.homeItems.count > 0)
         {
             for (HYMallHomeBoard *board in result.homeItems)
             {
                 switch (board.boardType)
                 {
                     case MallHomeLaunchAds:
                     {
                         if (board.programPOList.count > 0)
                         {
                             //首页之前的广告
                             [weakSelf saveStartAdsCacheWithData:board.programPOList[0]];
//                              callback1(board.programPOList);
                             hasBrand = YES;
                         }
                     }
                         break;
                     case MallHomeHomeAds:
                         if (board.programPOList.count > 0)
                         {
                             hasBrandAds = YES;
                             [weakSelf setBoardOneDayShowMaxCount:board.oneDayShowMaxCount];
                             //如果bannerCode发生改变，就清空原来已经显示次数
                             if ([weakSelf checkBannerCodeIsChanged:board.programPOList])
                             {
                                 [weakSelf resetBoardOneDayShowMaxCount];
                             }
                             callback2(board);
                             
                         }
                         break;
                    default:
                         break;
                 }
             }
         }
         
         //清除缓存
         if (!hasBrand)
         {
             [[SDImageCache sharedImageCache]removeImageForKey:kAdsImage fromDisk:YES];
         }
         if (!hasBrandAds)
         {
             
         }
     }];
}

#pragma mark private methods
- (BOOL)checkBannerCodeIsChanged:(NSArray <HYMallHomeItem *>*)list
{
    NSMutableArray *array = [NSMutableArray array];
    for (HYMallHomeItem *item in list)
    {
        [array addObject:item.bannerCode];
    }
    NSMutableSet *set = [NSMutableSet setWithArray:array];
    
    NSMutableArray *cacheArray = [[[NSUserDefaults standardUserDefaults]objectForKey:kBannerCodeArray]mutableCopy];
    NSMutableSet *cacheSet = [NSMutableSet setWithArray:cacheArray];
    //没有缓存，就存本次的bannerCode
    if (!cacheArray)
    {
        if (array)
        {
            [self saveBoardBannerCodeWithRequestedArray:array];
            return YES;
        }
        else
        {
            return NO;
        }
    }
    //有缓存就比较bannerCode，忽略顺序
    else
    {
        [self saveBoardBannerCodeWithRequestedArray:array];
        return ![set isEqualToSet:cacheSet];
    }
}

//缓存启动页的广告
- (void)saveStartAdsCacheWithData:(HYMallHomeItem *)item
{
    //图片缓存到磁盘,还得缓存点击的url
    NSDictionary *itemDict = [item toDictionary];
    if (itemDict)
    {
        [[NSUserDefaults standardUserDefaults]setObject:itemDict forKey:kStartAdsItem];
    }
    
    NSString *urlStr = nil;
    //4s单独处理
    if (currentDeviceType() == iPhone4_4S)
    {
        urlStr = (item.pictureUrlFor4s.length > 0) ? item.pictureUrlFor4s : item.pictureUrl;
    }
    else
    {
        urlStr = item.pictureUrl;
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //这个控制器太冗余，留着以后改
    if (url)
    {
        [[SDWebImageManager sharedManager]downloadImageWithURL:url options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {
             
         } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
         {
             [[SDImageCache sharedImageCache]storeImage:image forKey:kAdsImage toDisk:YES];
         }];
    }
}

- (void)saveBoardBannerCodeWithRequestedArray:(NSArray *)array
{
    [[NSUserDefaults standardUserDefaults]setObject:array forKey:kBannerCodeArray];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)setBoardOneDayShowMaxCount:(NSString *)oneDayShowMaxCount
{
   [[NSUserDefaults standardUserDefaults]setValue:oneDayShowMaxCount forKey:kAdsShowMaxNum];
}

- (void)resetBoardOneDayShowMaxCount
{
    [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:kAdsHasShownTimes];
}

@end
