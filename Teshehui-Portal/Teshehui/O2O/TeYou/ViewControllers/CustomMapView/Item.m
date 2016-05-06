

#import "Item.h"

@implementation Item
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.latitude = [dictionary objectForKey:@"latitude"];
        self.longitude = [dictionary objectForKey:@"longitude"];
        self.title = [dictionary objectForKey:@"title"];
        self.subtitle = [dictionary objectForKey:@"subtitle"];
    }
    return self;
}
@end
