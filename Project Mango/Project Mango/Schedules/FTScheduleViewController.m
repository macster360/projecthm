//
//  FTScheduleViewController.m
//  Project Mango
//
//  Created by Jeffrey Barg on 7/24/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTScheduleViewController.h"
#import "JMClassDetailViewController.h"
#import "Student.h"
#import "Course.h"

@interface FTScheduleViewController () {
    NSInteger _day;
    BOOL _isAnimatingDayChange;
}
    
@property (nonatomic, strong) NSDictionary * periodToCourseDict;

@end

@implementation FTScheduleViewController

@synthesize managedObjectContext;
@synthesize student;
@synthesize periodToCourseDict;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kViewBackgroundColor;
    
    _isAnimatingDayChange = FALSE;
    
    self.tableView.rowHeight = 64.0f;
    
    _day = 8;
    
    NSString * dayStr = @"8";
    self.title = [NSString stringWithFormat:@"Day %@", dayStr];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIBarButtonItem *leftArrow = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [leftButton addTarget:self action:@selector(backDay:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftButton setShowsTouchWhenHighlighted:YES];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 7.0)];
    
    self.navigationItem.leftBarButtonItem = leftArrow;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIBarButtonItem *rightArrow = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightButton addTarget:self action:@selector(forwardDay:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"forward.png"] forState:UIControlStateNormal];
    [rightButton setShowsTouchWhenHighlighted:YES];
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, 7.0, 0.0, 0.0)];
    
    self.navigationItem.rightBarButtonItem = rightArrow;

    [self refreshSchedule];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) refreshSchedule {
    NSString * dayStr = [NSString stringWithFormat:@"%i", _day];
    self.title = [NSString stringWithFormat:@"Day %i", _day==0?10:_day];

    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Student"];
    NSString *idCard = [[NSUserDefaults standardUserDefaults] objectForKey:kIDCardBarcodeDefault];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"unitID == %s", @"12120"]];
    student = [[self.managedObjectContext executeFetchRequest:request error:nil] lastObject];
    NSLog(@"STudent: %@", student);
    NSLog(@"%@", self.managedObjectContext);
    
    NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
    for (Course *course in student.courses) {
        if ([course.days rangeOfString:dayStr].location != NSNotFound) {
            [mDict setObject:course forKey:course.period];
        }
    }
    
    self.periodToCourseDict = [[NSDictionary alloc] initWithDictionary:mDict];
}

- (void) backDay:(UIButton *) leftButton {
    _day = (_day+9)%10; // weird negative mod thing -- however 9 === -1 in mod 10
    
    if (_isAnimatingDayChange) return;
    
    _isAnimatingDayChange = TRUE;
    
    [self refreshSchedule];

    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:8];
    for (int i = 0; i < 8; i ++)
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    
    [self.tableView beginUpdates];
    
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.tableView endUpdates];
    
    [self performSelector:@selector(finishDayChangeAnimation) withObject:nil afterDelay:0.42];
}

- (void) forwardDay:(UIButton *) leftButton {
    _day = (_day+11)%10; // Add 11 to deal with the - modular funny business.
    
    if (_isAnimatingDayChange) return;
    
    _isAnimatingDayChange = TRUE;
    
    [self refreshSchedule];

    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:8];
    for (int i = 0; i < 8; i ++)
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    [self.tableView beginUpdates];
    
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.tableView endUpdates];
    
    [self performSelector:@selector(finishDayChangeAnimation) withObject:nil afterDelay:0.5];
}

- (void) finishDayChangeAnimation {
    _isAnimatingDayChange = FALSE;
    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:8];
    for (int i = 0; i < 8; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return INTERFACE_IS_PAD;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _isAnimatingDayChange?0:8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)  {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSArray *periods = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", nil];
    
    Course *course = [self.periodToCourseDict objectForKey:[periods objectAtIndex:indexPath.row]];
    if (course == nil) {
        //Deal with free
        
        [cell.textLabel setTextColor:[UIColor grayColor]];
        [cell.detailTextLabel setTextColor:[UIColor grayColor]];
        
        [cell.textLabel setFont:[UIFont italicSystemFontOfSize:[UIFont labelFontSize]]];
        [cell.detailTextLabel setFont:[UIFont italicSystemFontOfSize:[UIFont labelFontSize]]];
        
        [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@", [periods objectAtIndex:indexPath.row], @"Free"]];
        [cell.detailTextLabel setText:@"Go Study!"];
        
    } else {
        [cell.textLabel setTextColor:[UIColor blackColor]];
        [cell.detailTextLabel setTextColor:[UIColor blackColor]];
        
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:[UIFont labelFontSize]]];
        [cell.detailTextLabel setFont:[UIFont boldSystemFontOfSize:[UIFont labelFontSize]]];
        
        [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@", course.period, course.name]];
        [cell.detailTextLabel setText:course.room];
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *periods = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", nil];
    
    Course *course = [self.periodToCourseDict objectForKey:[periods objectAtIndex:indexPath.row]];
    
    if (course == nil) return;
    
    JMClassDetailViewController *detailViewController = [[JMClassDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [detailViewController setManagedObjectContext:self.managedObjectContext];
    [detailViewController setCourse:course];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissModal)];
    [detailViewController.navigationItem setLeftBarButtonItem:doneButton];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    [self presentViewController:navController animated:YES completion:nil];
    
    
}

- (void) dismissModal {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
