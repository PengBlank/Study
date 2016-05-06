//
//  HYMallSearchView.h
//  Teshehui
//
//  Created by HYZB on 16/3/31.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYMallSearchViewDelegate <NSObject>

@optional
- (void)getSuggestWithString:(NSString *)str;
- (void)hiddenSuggestController;
- (void)searchWithKey:(NSString *)key;


- (void)hiddenSuggestview;
- (void)filterViewControllerIsShow;


@end

@interface HYMallSearchView : UIView

@property (nonatomic, strong) UITextField *search;


@property (nonatomic, weak) id <HYMallSearchViewDelegate>delegate;


@end
