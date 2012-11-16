#import <UIKit/UIKit.h>

@class StudentDB;

@interface StudentListViewController : UITableViewController
{
    StudentDB *db;
    NSMutableArray *students;
}

@end
