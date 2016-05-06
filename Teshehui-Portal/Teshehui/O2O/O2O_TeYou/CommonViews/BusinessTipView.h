//
//  BusinessTipView.h
//  Teshehui
//
//  Created by apple_administrator on 15/11/19.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessTipView : UIView

@property (nonatomic,assign) BOOL isHidden;

- (id)initWithFrame:(CGRect)frame businessNum:(NSInteger)count;
- (void)show;
- (void)dismiss;
@end
