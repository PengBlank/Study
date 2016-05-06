//
//  HYMallChannelBoard.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/12.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"
#import "HYMallChannelItem.h"
#import "HYMallHomeSections.h"


@interface HYMallChannelBoard : JSONModel

@property (nonatomic, copy) NSString *channelBoardName;
@property (nonatomic, copy) NSString *channelBoardCode;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *totalChannelBanner;
@property (nonatomic, strong) NSArray <HYMallChannelItem>* channelBannerList;
@property (nonatomic, assign, readonly) HYMallChannelBoardType boardType;

@end
