//
//  TQStarRatingView.h
//  TQStarRatingView
//
//  Created by fuqiang on 13-8-28.
//  Copyright (c) 2013年 TinyQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TQStarRatingView;

@protocol StarRatingViewDelegate <NSObject>

@optional
-(void)starRatingView:(TQStarRatingView *)view score:(float)score;

@end

@interface TQStarRatingView : UIView

- (instancetype)initWithStar:(UIImage *)star hilightedStar:(UIImage *)hStar numberOfStar:(NSInteger)number spaceOfStar:(CGFloat)space;

@property (nonatomic, readonly) NSInteger numberOfStar;
@property (nonatomic, weak) id <StarRatingViewDelegate> delegate;

@property (nonatomic, assign) CGFloat rating;

@property (nonatomic, assign) CGFloat space;

@property (nonatomic, strong) UIImage *starImage;
@property (nonatomic, strong) UIImage *starHilightedImage;

@property (nonatomic, assign) BOOL fraction;
@property (nonatomic, assign) BOOL enable;

@end
