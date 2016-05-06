//
//  PTSearchBar.m
//  Putao
//
//  Created by ChengQian on 12-12-24.
//  Copyright (c) 2012年 so.putao. All rights reserved.
//

#import "PTSearchBar.h"

@interface PTSearchBar ()

@property (nonatomic, assign) BOOL needCustom;
@property (nonatomic, retain) UIImage *bgImage;

@end

@implementation PTSearchBar

@synthesize needCustom = _needCustom;
@synthesize bgImage = _bgImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSString *version = [[UIDevice currentDevice] systemVersion];
        _needCustom = [version compare:@"5.0" options:NSNumericSearch] == NSOrderedAscending;
    }
    return self;
}

- (void)setSearchBarLeftView:(UIView *)leftView
{
    UITextField *searchField = nil;

    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
    {
        if (leftView)
        {
            for (UIView *view in self.subviews)
            {
                for(UIView *subview in view.subviews)
                {
                    if ([subview isKindOfClass:[UITextField class]])
                    {
                        searchField = (UITextField *)subview;
                        goto find;
                    }
                }
            }
        }
    }
    else
    {
        if (leftView)
        {
            for (UIView *view in self.subviews)
            {
                if ([view isKindOfClass:[UITextField class]])
                {
                    searchField = (UITextField *)view;
                    goto find;
                }
                
            }
        }
    }
    
find:
    if(!(searchField == nil))
    {
        searchField.leftView = leftView;
    }
}

- (void)setCustomBackgroundImage:(UIImage *)backgroundImage
{
    if (self.needCustom)
    {
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.frame];
        bgImageView.image = backgroundImage;
        for (UIView *subview in [self subviews]) {
            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
            {
                [self insertSubview:bgImageView belowSubview:subview];
                [subview removeFromSuperview];
            }
            
            if ([subview isKindOfClass:NSClassFromString(@"UISegmentedControl") ] )
                subview.alpha = 0.0;
        }
    }
    else
    {
        self.backgroundImage = backgroundImage;
    }
}

@end
