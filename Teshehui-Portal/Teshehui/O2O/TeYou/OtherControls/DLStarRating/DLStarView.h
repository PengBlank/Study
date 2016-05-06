

#import <UIKit/UIKit.h>

#define kEdgeInsetBottom 0

@interface DLStarView : UIButton {
    
}

- (id)initWithDefault:(UIImage*)star highlighted:(UIImage*)highlightedStar position:(NSInteger)index allowFractions:(BOOL)fractions;
- (void)centerIn:(CGRect)_frame with:(NSInteger)numberOfStars;
- (void)setStarImage:(UIImage*)starImage highlightedStarImage:(UIImage*)highlightedImage;
- (UIImage *)croppedImage:(UIImage*)image;
@end
