//
//  CQBaseNavViewController.h
//  Teshehui
//
//  Created by ChengQian on 13-10-25.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CQBaseNavViewControllerDelegate <NSObject>

@required
- (UIImage *)captureScreen;

@end

@interface HYNavigationController : UINavigationController
{
    CGFloat startBackViewX;
}

@property (nonatomic,assign) BOOL canDragBack;
@property (nonatomic, weak) id<CQBaseNavViewControllerDelegate> captrueDelegate;
@property (nonatomic,strong) UIPanGestureRecognizer *recognizer;

- (void)setEnableSwip:(BOOL)enable;
- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer;

@end
