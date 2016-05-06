//
//  PTSearchBar.h
//  Putao
//
//  Created by ChengQian on 12-12-24.
//  Copyright (c) 2012年 so.putao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTSearchBar : UISearchBar
{
    UIImage *_bgImage;
}

- (void)setSearchBarLeftView:(UIView *)leftView;

- (void)setCustomBackgroundImage:(UIImage *)backgroundImage;

@end
