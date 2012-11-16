#import "StudentListViewController.h"
#import "StudentDB.h"
#import "Student.h"
#import "AddStudentViewController.h"

@implementation StudentListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        self.title = @"Students List";
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)setupNavButtons
{
    UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] 
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                   target:self 
                                   action:@selector(addButtonPushed:)] autorelease];
    [self.navigationItem setRightBarButtonItem:addButton];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self setupNavButtons];
    
    db = [[StudentDB alloc] init];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    students = [db getAllStudent];
    [self.tableView reloadData];
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return students.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    Student *student = [students objectAtIndex:indexPath.row];
    cell.textLabel.text = student.name;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strBirth = [dateFormatter stringFromDate:student.birth];
    NSString *strDescription = [[NSString alloc] initWithFormat:@"年龄:%d 生日:%s", student.age,
                                [strBirth UTF8String]];
    [cell.detailTextLabel setText:strDescription];
    [dateFormatter release];
    [strDescription release];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Student *student = [students objectAtIndex:indexPath.row];
        //删除数据库中的数据
        [db removeStudent:student];
        //删除数组中的数据
        [students removeObjectAtIndex:indexPath.row];
        //删除TableView中的数据
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)addButtonPushed:(id)sender
{
    AddStudentViewController *addStudentViewController = [[[AddStudentViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    
    [self.navigationController pushViewController:addStudentViewController animated:YES];
}

- (void)dealloc
{
    [students release];
    [db release];
    [super dealloc];
}

@end
