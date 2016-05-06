

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (nonatomic,copy)NSString *latitude;
@property (nonatomic,copy)NSString *longitude;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *subtitle;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end