#import "Student.h"

@implementation Student

@synthesize uniqueId, name, age, birth;

- (id)initWithUniqueId:(int)paramuniqueId name:(NSString *)paramname age:(int)paramage birth:(NSDate *)parambirth
{
  
    self = [super init];
    if (self) {
        self.uniqueId = paramuniqueId;
        self.name = paramname;
        self.age = paramage;
        self.birth = parambirth;
    }
    
    return self;
}

- (void)dealloc
{
    self.name = nil;
    self.birth = nil;
    [super dealloc];
}

@end
