

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
//#import <BaiduMapAPI/BMapKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface BasicMapAnnotation : NSObject <BMKAnnotation>

@property (nonatomic,assign) CLLocationDegrees latitude;
@property (nonatomic,assign) CLLocationDegrees longitude;
@property (nonatomic,assign) int tag;
@property (nonatomic,copy) NSString *title;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude
                   tag:(int)tag;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
- (CLLocationCoordinate2D)coordinate;
@end
