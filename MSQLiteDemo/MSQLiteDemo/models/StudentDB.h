#import <Foundation/Foundation.h>
#import "sqlite3.h"

@class Student;

@interface StudentDB : NSObject
{
    sqlite3 *db;
}

- (int)getStudentsCount;
- (NSMutableArray *)getAllStudent;
- (void)removeStudent:(Student *)person;
- (void)addStudent:(Student *)person;

@end
