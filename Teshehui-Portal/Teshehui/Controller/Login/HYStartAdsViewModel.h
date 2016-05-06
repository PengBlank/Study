//
//  HYStartAdsViewModel.h
//  Teshehui
//
//  Created by Kris on 16/1/5.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"
#import "HYMallHomeItem.h"
#import "HYMallHomeBoard.h"

@interface HYStartAdsViewModel : JSONModel

@property (nonatomic, copy) NSURL *picUrl;
@property (nonatomic, copy) NSURL *tapUrl;
@property (nonatomic, strong) HYMallHomeItem *item;
@property (nonatomic, assign) NSUInteger adSecs;//广告的时间

+ (instancetype)viewModelWithSubjects:(NSArray <HYMallHomeItem *>*)subjects;

@end
