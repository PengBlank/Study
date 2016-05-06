//
//  UITextFieldEx.h
//  Sunight2.0
//
//  Created by Xiang Chengcai on 13-5-27.
//  Copyright (c) 2013年 Xiang Chengcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextFieldEx : UITextField {
    
}
@property (nonatomic, assign) float leftPadding;
@property (nonatomic, assign) float rightPadding;
@property (nonatomic, assign) float topPadding;
@property (nonatomic, assign) float bottomPadding;

@property (nonatomic, assign) BOOL isActive;

@end
