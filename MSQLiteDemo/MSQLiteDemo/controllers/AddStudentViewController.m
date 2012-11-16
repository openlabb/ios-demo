#import "AddStudentViewController.h"
#import "Student.h"
#import "StudentDB.h"

@implementation AddStudentViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setupNavButtons
{
    //右上角添加按钮和按钮的触法事件。doneButtonPushed:
    UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc] 
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                   target:self 
                                   action:@selector(doneButtonPushed:)] autorelease];
    [self.navigationItem setRightBarButtonItem:doneButton];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavButtons];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    if (0 == [indexPath section]) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (0 == indexPath.row) {
            cell.textLabel.text = @"姓名";
            txtName = [[UITextField alloc] initWithFrame:CGRectMake(110, 12, 160, 24)];
            txtName.placeholder = @"输入中文名";
            [cell addSubview:txtName];
        }
        if (1 == indexPath.row) {
            cell.textLabel.text = @"年龄";
            txtAge = [[UITextField alloc] initWithFrame:CGRectMake(110, 12, 160, 24)];
            txtAge.placeholder = @"请输入数字";
            [cell addSubview:txtAge];
        }
        if (2 == indexPath.row) {
            cell.textLabel.text = @"出生日期";
            txtBirth = [[UITextField alloc] initWithFrame:CGRectMake(110, 12, 160, 24)];
            txtBirth.placeholder = @"1900-01-01";
            [cell addSubview:txtBirth];
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)doneButtonPushed:(id)sender
{
    StudentDB *db = [[StudentDB alloc] init];
    NSString *strName = txtName.text;
    int age = [txtAge.text intValue];
    NSString *strBirth = txtBirth.text;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    Student *student = [[Student alloc] initWithUniqueId:0 name:strName age:age birth:[dateFormatter dateFromString:strBirth]];
    [db addStudent:student];
    [student release];
    [db release];
    [dateFormatter release];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [txtName release];
    [txtAge release];
    [txtBirth release];
    [super dealloc];
}





@end
