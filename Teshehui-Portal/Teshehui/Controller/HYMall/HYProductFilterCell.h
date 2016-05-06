//
//  HYProductFilterCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/9/4.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYProductFilterDataManeger.h"

@interface HYProductFilterCell : HYBaseLineCell

@property (nonatomic, copy) NSString *curSelectItem;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) NSInteger currSelectIndex;
@property (nonatomic, copy) void (^indexChange)(NSInteger index) ;

@end
