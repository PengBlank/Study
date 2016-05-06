//
//  HYFolwerShowDetailUIViewController.h
//  Teshehui
//
//  Created by ichina on 14-2-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYFolwerViewBaseController.h"
#import "HYFlowerDetailInfo.h"
#import "MWPhotoBrowser.h"
#import "HYLoadHubView.h"
#import "HYNullView.h"

@interface HYFlowerDetailViewController : HYFolwerViewBaseController
<
UITableViewDataSource,
UITableViewDelegate,
MWPhotoBrowserDelegate
>

@property (nonatomic, strong) NSString* produceID;
@property (nonatomic, strong) NSString* headImgUrl;
@property (nonatomic, strong) UIImageView* imageVC;
@property( nonatomic, strong) UILabel* moneyLab;
@property (nonatomic, strong) UILabel* vipmoneyLab;
@property (nonatomic, strong) UILabel* pointLab;
@property (nonatomic, strong) UILabel* floridLab;
@property (nonatomic, strong) UILabel* muchLab;


@end
