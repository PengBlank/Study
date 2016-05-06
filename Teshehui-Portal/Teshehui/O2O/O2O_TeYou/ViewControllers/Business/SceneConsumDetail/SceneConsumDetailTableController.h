//
//  SceneConsumDetailTableController.h
//  Teshehui
//
//  Created by LiuLeiMacmini on 16/4/6.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneDeatilInfo.h"

//定义协议，用来将滚动事件传递到上一层
@protocol SceneConsumDetailTableControllerDelegae <NSObject>
- (void) SceneConsumDetailTableControllerDidScroll:(CGFloat)contentOffset_Y;
@end


@interface SceneConsumDetailTableController : UITableViewController

@property (nonatomic , strong ) SceneDeatilInfo *detailInfo;

@property ( nonatomic , assign) CGFloat navigationbarHeight;
@property ( nonatomic , weak) id<SceneConsumDetailTableControllerDelegae>scrollDelegate;

@end
