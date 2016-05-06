//
//  HYMallBrandStory.h
//  Teshehui
//
//  Created by Kris on 16/4/13.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYMallBrandStory : JSONModel

/*
"brandBo":{"brandId":4180,"brandName":"艾乐果","brandCode":"CN04180","brandStory":""}
 */
@property (nonatomic, copy) NSString *brandId;
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, copy) NSString *brandCode;
@property (nonatomic, copy) NSString *brandCountry;
@property (nonatomic, copy) NSString *brandStory;
@property (nonatomic, copy) NSString *logoUrl;
@property (nonatomic, copy) NSString *bannerImage;

@end
