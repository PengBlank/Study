
#import <UIKit/UIKit.h>
#import "DefineConfig.h"
#define kDefaultNumberOfStars 5
#define kNumberOfFractions    5

@protocol DLStarRatingDelegate;

@interface DLStarRatingControl : UIControl {
	NSInteger numberOfStars;
	NSInteger currentIdx;
	UIImage *star;
	UIImage *highlightedStar;
	//IBOutlet id<DLStarRatingDelegate> delegate;
    BOOL isFractionalRatingEnabled;

}

- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame andStars:(NSUInteger)_numberOfStars isFractional:(BOOL)isFract;
- (void)setStar:(UIImage*)defaultStarImage highlightedStar:(UIImage*)highlightedStarImage atIndex:(NSInteger)index;

@property (retain,nonatomic) UIImage *star;
@property (retain,nonatomic) UIImage *highlightedStar;
@property (nonatomic) CGFloat rating;
@property (assign,nonatomic) id<DLStarRatingDelegate> delegate;
@property (nonatomic,assign) BOOL isFractionalRatingEnabled;

@end

@protocol DLStarRatingDelegate

-(void)newRating:(DLStarRatingControl *)control :(CGFloat)rating;

@end
