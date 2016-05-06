

#import "DLStarView.h"
#import "DLStarRatingControl.h"

@implementation DLStarView

#pragma mark -
#pragma mark Initialization

- (id)initWithDefault:(UIImage*)star highlighted:(UIImage*)highlightedStar position:(NSInteger)index allowFractions:(BOOL)fractions {
	self = [super initWithFrame:CGRectZero];
    
	if (self) {
        [self setTag:index];
        if (fractions) {
            highlightedStar = [self croppedImage:highlightedStar];
            star = [self croppedImage:star];
        }
        self.frame = CGRectMake((star.size.width*index), 0, star.size.width, star.size.height+kEdgeInsetBottom);
        [self setStarImage:star highlightedStarImage:highlightedStar];
		[self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, kEdgeInsetBottom, 0)];
		[self setBackgroundColor:[UIColor clearColor]];
        if (index == 0) {
   	        [self setAccessibilityLabel:@"1 star"];
        } else {
   	        [self setAccessibilityLabel:[NSString stringWithFormat:@"%@", @(index+1)]];
        }
        
      
	}
	return self;
}


- (UIImage *)croppedImage:(UIImage*)image {
    
    CGFloat partWidth = image.size.width/kNumberOfFractions * image.scale;
    NSInteger part = (self.tag+kNumberOfFractions)%kNumberOfFractions;
    CGFloat xOffset = partWidth*part;
    CGRect newFrame = CGRectMake(xOffset, 0, partWidth , image.size.height * image.scale);
    CGImageRef resultImage = CGImageCreateWithImageInRect([image CGImage], newFrame);
    UIImage *result = [UIImage imageWithCGImage:resultImage scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(resultImage);
    return result;
}



#pragma mark -
#pragma mark UIView methods

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	return self.superview;
}

#pragma mark -
#pragma mark Layouting

- (void)centerIn:(CGRect)_frame with:(NSInteger)numberOfStars {
	CGSize size = self.frame.size;
	
	CGFloat height = self.frame.size.height;
	CGFloat frameHeight = _frame.size.height;
	CGFloat newY = (frameHeight-height)/2;
	
	CGFloat widthOfStars = self.frame.size.width * numberOfStars;
	CGFloat frameWidth = _frame.size.width;
	CGFloat gapToApply = (frameWidth-widthOfStars)/2;
	
	self.frame = CGRectMake((size.width*self.tag) + gapToApply, newY, size.width, size.height);	
}

- (void)setStarImage:(UIImage*)starImage highlightedStarImage:(UIImage*)highlightedImage {
    [self setImage:starImage forState:UIControlStateNormal];
    [self setImage:highlightedImage forState:UIControlStateSelected];
    [self setImage:highlightedImage forState:UIControlStateHighlighted];
}

@end
