//
//  MainHeaderView.h
//  Teshehui
//
//  Created by apple_administrator on 16/4/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//


typedef void (^topicBtnClick)(UIButton *btn);

#import <UIKit/UIKit.h>



@interface MainHeaderView : UIView

@property (nonatomic,strong) NSMutableArray *topicArray;

@property (nonatomic,copy)topicBtnClick btnClickBlock;

@end
