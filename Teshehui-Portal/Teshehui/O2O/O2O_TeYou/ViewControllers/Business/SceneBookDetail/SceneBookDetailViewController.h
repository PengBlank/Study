//
//  SceneBookDetailViewController.h
//  Teshehui
//
//  Created by LiuLeiMacmini on 16/4/9.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

//#import <UIKit/UIKit.h>
//@interface SceneBookDetailViewController : UIViewController

#import "HYMallViewBaseController.h"
#import "SceneDeatilInfo.h"

@interface SceneBookDetailViewController : HYMallViewBaseController

@property (nonatomic , strong ) SceneDeatilInfo *detailInfo;
@property ( nonatomic , strong) NSString *cityName;

@end
