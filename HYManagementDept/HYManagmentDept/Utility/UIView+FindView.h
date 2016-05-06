//
//  UIView+FindView.h
//  DaXueBao
//
//  Created by Ray on 14-3-9.
//  Copyright (c) 2014年 souvi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FindView)

//从该视图向上寻找给定类的视图,若未找到返回nil
- (id)findSuperViewForClass:(Class)superViewClass;

@end
