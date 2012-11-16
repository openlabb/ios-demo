#import <Foundation/Foundation.h>

@interface Student : NSObject

//值属性都是assign的啊。
@property (nonatomic, assign) int uniqueId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) int age;
@property (nonatomic, retain) NSDate *birth;

- (id)initWithUniqueId:(int)uniqueId name:(NSString *)name age:(int)age birth:(NSDate *)birth;

@end
