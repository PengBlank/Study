//
//  HYMallParamItemView.h
//  Teshehui
//
//  Created by HYZB on 14-9-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYMallParamItemView : UIControl

- (id)initWithFrameAndGoodsParamDescription:(CGRect)frame
                                       desc:(NSString *)desc
                                       font:(UIFont *)font;

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign, readonly) CGSize itemSize;

@end
