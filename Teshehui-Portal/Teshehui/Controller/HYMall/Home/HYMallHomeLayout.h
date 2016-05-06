//
//  HYMallHomeLayout.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/3.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYMallHomeLayout : UICollectionViewFlowLayout

@property (assign, nonatomic) CGFloat leftY; // 左侧起始Y轴
@property (assign, nonatomic) CGFloat rightY; // 右侧起始Y轴
@property (assign, nonatomic) NSInteger cellCount; // cell个数
@property (assign, nonatomic) CGFloat itemWidth; // cell宽度
@property (assign, nonatomic) CGFloat insert; // 间距

@property (nonatomic, assign) NSInteger moreSection;

@end
