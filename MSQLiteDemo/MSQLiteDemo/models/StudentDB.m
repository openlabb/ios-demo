#import "StudentDB.h"
#import "Student.h"

@implementation StudentDB

- (id)init
{
    self = [super init];
    if (self) {
        [self opendb];
    }
    
    return self;
}

//打开数据库，数据库不存在的时候自己创建一个啰
-(void)opendb{
    NSArray *docPathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *databasePath = [[NSString alloc] initWithString: [[docPathArray objectAtIndex:0] stringByAppendingPathComponent: @"school.db"]];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath:databasePath] == NO) 
    {
        if (sqlite3_open([databasePath UTF8String], &db)==SQLITE_OK) 
        {
            char *szError;
            /*根据路径创建数据库并创建一个表school(id name age birth)*/    
            const char *sqlUTF8 = "CREATE TABLE IF NOT EXISTS  student (key integer primary key, name text, age integer, birth date)";
            if (sqlite3_exec(db, sqlUTF8, NULL, NULL, &szError)!=SQLITE_OK) {
                NSLog(@"failed to create table\n");
            }
        }
        else 
        {
            NSLog(@"failed to create/open d");
        }
    }else {
        if (sqlite3_open([databasePath UTF8String], &db) != SQLITE_OK) {
            NSLog(@"failed to open db.");
        }
    }
}



//获取所有的学生记录
- (NSMutableArray *)getAllStudent
{
    //1，要生成一个sqlite3_stmt对象，类似command
    sqlite3_stmt *pStmt;
    
    NSMutableArray *studentArray = [[NSMutableArray alloc] init];
    
    NSString *sql = @"SELECT * FROM student;";
    //2,sqlite3_prepare_v2预编译要执行的Sql指令，类似初始化这个command。
    sqlite3_prepare_v2(db, [sql UTF8String], -1, &pStmt, nil);
    //3,sqlite3_step执行对应的command了。
    while (SQLITE_ROW == sqlite3_step(pStmt)) {
        //取得第一列的id，是个int
        int uniqueId = sqlite3_column_int(pStmt, 0);
        //取得第二列的name,是个字符串
        NSString *name = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(pStmt, 1)];
        //取得第三列的age，是个int
        int age = sqlite3_column_int(pStmt, 2);
        //取得第四列的date,是个日期格式的字符串。
        NSDateFormatter *formate = [[NSDateFormatter alloc] init];
        [formate setDateFormat:@"yyyy-MM-dd"];
        NSDate *birth= [formate dateFromString:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(pStmt, 3)]];
        //根据前面取到的四列数据生成一个Student实例。
        Student *student = [[Student alloc] initWithUniqueId:uniqueId name:name age:age birth:birth];
        //把新生成的实例加入到数据数组studentArray中
        [studentArray addObject:student];
        //释放不要了的内存。
        [formate release];
        [name release];
        [student release];
    }
    //4,sqlite3_finalize释放command好么。
    sqlite3_finalize(pStmt);
    
    return studentArray;
}

//获取学生记录个数。
-(int)getStudentsCount
{
    NSString *sql = @"SELECT COUNT(*) FROM student";
    //1,生成一个sqlite3_stmt，靠自己;
    sqlite3_stmt *pStmt;
    //2,初始化这个sqlite3_stmt，靠sqlite3_prepare_v2搭上sqlite3对象db
    sqlite3_prepare_v2(db, [sql UTF8String], -1, &pStmt, nil);
    if (SQLITE_ROW == sqlite3_step(pStmt)) {
        //3，执行这个sqlite3_stmt,靠sqlite3_step去做，一般产生SQLITE_ROW的结果
        return sqlite3_column_int(pStmt, 0);
    }
    //4，释放这个sqlite3_stmt，靠sqlite3_finalize了。
    sqlite3_finalize(pStmt);

    return 0;
}
//删除一条学生记录
- (void)removeStudent:(Student *)person
{
    if (nil != person) {
        char *szError = 0;
        NSString *sql = [[NSString alloc] initWithFormat:@"delete from student where key = %d;", person.uniqueId];
        int nResult = sqlite3_exec(db, [sql UTF8String], 0, 0, &szError);
        if (nResult != SQLITE_OK) {
            NSLog(@"delete failed.");
        }
        
        [sql release];
    }
}

//添加一条学生记录
- (void)addStudent:(Student *)person
{
    if (nil != person) {
        char *szError = 0;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *sql = [[NSString alloc]
                         initWithFormat:@"INSERT INTO student (name, age, birth) VALUES ('%@', %d, '%@');", 
                         person.name,
                         person.age,
                         [dateFormatter stringFromDate:person.birth]];
        
        int nResult = sqlite3_exec(db, [sql UTF8String], 0, 0, &szError);
        if (nResult != SQLITE_OK) {
            NSLog(@"add failed");
        }
        [sql release];
    }
}

- (void)dealloc
{
    sqlite3_close(db);
    [super dealloc];
}

@end
