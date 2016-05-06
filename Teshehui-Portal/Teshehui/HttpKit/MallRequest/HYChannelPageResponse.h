//
//  HYChannelPageResponse.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/12.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYMallChannelBoard.h"
@class HYChannelCategory;

@interface HYChannelPageResponse : CQBaseResponse

@property (nonatomic, strong) NSArray *boardList;
@property (nonatomic, strong) NSArray<HYChannelCategory*> *cateList;
@property (nonatomic, copy) NSString *channelTitle;

@end


@interface HYChannelCategory : JSONModel

@property (nonatomic, copy) NSString *categoryCode;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSString *sortNumber;

@end
