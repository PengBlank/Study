//
//  SceneBookDetailTabController.h
//  Teshehui
//
//  Created by LiuLeiMacmini on 16/4/9.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneDeatilInfo.h"

//定义协议，用来触发点击事件
@protocol SceneBookDetailTabControllerControllerDelegae <NSObject>
- (void) SceneBookDetailTabControllerPayButtonClick;
@end


@interface SceneBookDetailTabController : UIViewController

@property (nonatomic , strong ) SceneDeatilInfo *detailInfo;

@property (weak, nonatomic) IBOutlet UIButton *btnPay;

@property ( nonatomic , weak) id<SceneBookDetailTabControllerControllerDelegae>buttonDelegate;

@end

