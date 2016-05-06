
#import <MapKit/MapKit.h>
//#import <BaiduMapAPI/BMapKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#define  Arror_height 15

@protocol CallOutAnnotationViewDelegate;
@interface CallOutAnnotationView : BMKAnnotationView

@property (nonatomic,strong)UIView *contentView;


- (id)initWithAnnotation:(id<BMKAnnotation>)annotation
         reuseIdentifier:(NSString *)reuseIdentifier
                delegate:(id<CallOutAnnotationViewDelegate>)delegate;
@end

@protocol CallOutAnnotationViewDelegate <NSObject>

- (void)didSelectAnnotationView:(CallOutAnnotationView *)view;

@end


