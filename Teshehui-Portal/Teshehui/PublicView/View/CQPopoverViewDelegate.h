//
//  CQPopoverViewDelegate.h
//  Putao
//
//  Created by ChengQian on 12-10-19.
//  Copyright (c) 2012年 so.putao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CQPopoverViewDelegate <NSObject>

@optional

- (void)popoverDidSelectItem:(id)item;
- (void)popoverDidHidden;

@end
