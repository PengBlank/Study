//
//  HYCategoryView.h
//  HYManagmentDept
//
//  Created by apple on 14/12/16.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleSelectForm.h"

struct HYCategoryViewMetrics {
    CGFloat categoryx, categorywidth;
    CGFloat categoryspace;
    CGFloat font;
};
typedef struct HYCategoryViewMetrics HYCategoryViewMetrics;

@interface HYCategoryView : UIView
{
    HYCategoryViewMetrics _metrics;
    NSArray *_titles;
    UIScrollView *_contentScroll;
}
@property (nonatomic, strong, readonly) SingleSelectForm *form;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

@end
