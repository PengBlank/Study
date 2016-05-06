//
//  HYExpensiveResultView.h
//  Teshehui
//
//  Created by apple on 15/4/3.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYExpensiveResultView : UIView

typedef void (^ShowCompletionHandler)(void);

@property (nonatomic, assign) BOOL success;
@property (nonatomic, copy) void (^dismissCallback)(void);
@property (nonatomic, copy) ShowCompletionHandler showCompletionHandler;

@property (nonatomic, copy) NSString *desc;


- (void)show;
- (void)dismiss;
+ (instancetype)instance;
- (void)showWithCallback:(void (^)(void))callback;
- (void)showWithDuration:(CGFloat)duration
       completionHanlder:(ShowCompletionHandler) completion;

@end
