//
//  HYStartAdsDataController.h
//  Teshehui
//
//  Created by Kris on 16/1/5.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

typedef void (^StartAdsDataCallback)(id board);
typedef void (^StartHomeAdsDataCallback)(id board);

@interface HYStartAdsDataController : JSONModel

@property(nonatomic, copy)StartAdsDataCallback callback1;
@property(nonatomic, copy)StartHomeAdsDataCallback callback2;

- (void)fetchStartAdsDataWithCallback:(StartAdsDataCallback)callback;
-(void)fetchAllAdsDataWithCallback:(StartAdsDataCallback)callback1
                       andSecBlock:(StartHomeAdsDataCallback)callback2;

@end
