//
//  CQPopoverView.h
//  Putao
//
//  Created by ChengQian on 12-10-19.
//  Copyright (c) 2012年 so.putao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CQPopoverItem.h"
#import "CQPopoverViewDelegate.h"

@interface CQPopoverView : UIView

@property (nonatomic, retain) UIImage *selectImage;
@property (nonatomic, assign) id<CQPopoverViewDelegate>delegate;

- (id)initWithPoint:(CGPoint)point
            bgImage:(UIImage *)bgImage
        popoverItem:(NSArray *)items;

- (void)setCurrentSelectItem:(NSInteger)itemTag;

- (void)addItemWithView:(CQPopoverItem *)item;
- (void)showWithAnimation:(BOOL)animation;

@end