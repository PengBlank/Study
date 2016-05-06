//
//  SceneBookDetailTableController.h
//  Teshehui
//
//  Created by LiuLeiMacmini on 16/4/9.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneDeatilInfo.h"

@interface SceneBookDetailTableController : UITableViewController

@property (nonatomic , strong ) SceneDeatilInfo *detailInfo;

@property (weak, nonatomic    ) IBOutlet UITextField *txtContacts;
@property (weak, nonatomic    ) IBOutlet UITextField *txtPhone;
@property (nonatomic , strong ) NSString    *strDate;
@property (nonatomic , assign ) BOOL        dateSelected;

@end
