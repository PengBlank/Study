//
//  HYNumberHistoryView.h
//  Teshehui
//
//  Created by 成才 向 on 16/2/29.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYNumberHistoryView : UIView

@property (nonatomic, strong, readonly) UITableView *table;

/// {@"name": name, @"phone": phone}
@property (nonatomic, strong) NSArray *phoneInfos;

@property (nonatomic, copy) void (^didSelectInfo)(NSDictionary *info);
@property (nonatomic, copy) void (^didClear)(void);

@property (nonatomic, assign) BOOL showClear;

@end
