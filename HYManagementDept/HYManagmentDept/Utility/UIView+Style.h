//
//  UIView+Coners.h
//  hpiWeibo
//
//  Created by 成才 向 on 12-8-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface  UIView (Style) 

-(void)addCorner:(CGFloat)corner;
-(void)addBorder:(CGFloat)borderWidth borderColor:(UIColor*)borderColor;
-(void)addShadow:(CGSize)offsetSize;
-(void)addGrident:(NSArray*)colors;
@end
