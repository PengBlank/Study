//
//  SceneConsumDetailTabButtonsController.h
//  Teshehui
//
//  Created by LiuLeiMacmini on 16/4/6.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneDeatilInfo.h"

//定义协议，用来触发点击事件
@protocol SceneConsumDetailTabButtonsControllerDelegae <NSObject>
- (void) SceneConsumDetailTabButtonsControllerLikeButtonClick;
@end

@interface SceneConsumDetailTabButtonsController : UIViewController

@property ( nonatomic , strong) NSString *cityName;
@property ( nonatomic , strong) UIImage *shareImage;

@property (nonatomic, assign) BOOL isShare;
@property (nonatomic , strong ) SceneDeatilInfo *detailInfo;
@property (nonatomic , strong) NSString *FavoriteCount;
@property ( nonatomic , weak) id<SceneConsumDetailTabButtonsControllerDelegae>buttonDelegate;

@end
