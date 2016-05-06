//
//  SceneListInfo.h
//  Teshehui
//
//  Created by apple_administrator on 16/4/9.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SceneListInfo : NSObject
@property (nonatomic,strong) NSString   *packId;
@property (nonatomic,strong) NSString   *packageName;
@property (nonatomic,strong) NSString   *merId;
@property (nonatomic,strong) NSString   *merchantName;
@property (nonatomic,strong) NSString   *favorites;
@property (nonatomic,strong) NSString   *url;
@property (nonatomic,strong) NSString   *urlshare;

@property (nonatomic,assign) NSInteger   infoIndentifier; //0:美食  1：娱乐
@property (nonatomic,strong) UIImage    *tmpImage;
@end
