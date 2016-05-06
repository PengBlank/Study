


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
//#import <BaiduMapAPI/BMapKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
@interface CalloutMapAnnotation : NSObject <BMKAnnotation>

@property (nonatomic,assign) CLLocationDegrees latitude;
@property (nonatomic,assign) CLLocationDegrees longitude;
@property (nonatomic,assign) int tag;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude
                   tag:(int)tag;

- (CLLocationCoordinate2D)coordinate;
@end
