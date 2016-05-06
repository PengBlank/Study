//
//  CQPopoverItem.h
//  Putao
//
//  Created by ChengQian on 12-10-19.
//  Copyright (c) 2012年 so.putao. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CQPopoverItem : UIControl

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, retain) UIView *accessoryView;

- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
        normalImage:(UIImage *)normalImage
        selectImage:(UIImage *)selectImage;

@end
