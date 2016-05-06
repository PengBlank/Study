//
//  HYImageInfo.h
//  Teshehui
//
//  Created by HYZB on 15/5/27.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@protocol HYImageInfo <NSObject>@end

@interface HYImageInfo : JSONModel

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString* imageUrl;
@property (nonatomic, copy) NSString* imageName;
@property (nonatomic, copy) NSString* imageFileType;

- (NSString *)defaultURL;

@end
