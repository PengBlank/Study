//
//  HYMallChannelItem.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/12.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"
#import "HYMallHomeSections.h"

@protocol HYMallChannelItem <NSObject>
@end

@interface HYMallChannelItem : JSONModel

@property (nonatomic, copy) NSString* bannerName;
@property (nonatomic, copy) NSString* bannerCode;
@property (nonatomic, copy) NSString* boardCode;
@property (nonatomic, copy) NSString* bannerType;
@property (nonatomic, copy) NSString* businessType;
@property (nonatomic, copy) NSString* code;
@property (nonatomic, copy) NSString* searchKey;
@property (nonatomic, copy) NSString* image;
@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) NSString* tshPrice;
@property (nonatomic, copy) NSString* tb;

//手动生成
@property (nonatomic, assign) HYHomeItemType itemType;
@property (nonatomic, copy) NSString *productId;
- (HYMallChannelBoardType)boardType;

@end
