//
//  MyUITableView.m
//  UITableView-cocos2d
//
//  Created by Alexander Alemayhu on 14.11.11.
//  Copyright 2011 Flexnor. All rights reserved.
//

#import "DetailViewController.h"
#import "TableViewController.h"
#import "MyTableViewCell.h"
#import "AppDelegate.h"
#import "cocos2d.h"

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {

        //1.set backgroundColor property of tableView to clearColor, so that background image is visible
        [self.tableView setBackgroundColor:[UIColor clearColor]];
        
        //2.create an UIImageView that you want to appear behind the table
        UIImageView *tableBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"highscore_background1.png"]];
        
        //3.set the UIImageView’s frame to the same size of the tableView
        [tableBackgroundView setFrame: self.tableView.frame];
        
        //4.update tableView’s backgroundImage to the new UIImageView object
        [self.tableView setBackgroundView:tableBackgroundView];
        	
        [self.view bringSubviewToFront:self.tableView];
        

        _scored_date=[[NSMutableArray alloc]init];
        _total_score=[[NSMutableArray alloc]init];
        _sorted_score=[[NSMutableArray alloc]init];
        _sorted_total_score = [[NSArray alloc]init];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0];
        NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"questsPList.plist"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
        {
            plistPath = [[NSBundle mainBundle] pathForResource:@"questsPList" ofType:@"plist"];
        }

        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        arrayValues = [dict objectForKey:@"QuestsArray"];
        
        
        NSLog(@"%@",arrayValues);
        NSInteger value=0;
        
        while([arrayValues count]!= value){
            NSArray *items=[[NSArray alloc] initWithArray:[arrayValues objectAtIndex:value]];
            [_total_score addObject:[items objectAtIndex:0]];
            [_scored_date addObject:[items objectAtIndex:1]];
            value++;
        }
    }
    
//    _sorted_total_score = [_total_score sortedArrayUsingSelector:@selector(compare:)];
//    NSLog(@"sort : %@", _sorted_total_score);
    [self sortArrray];
    
    totalAry = [[NSMutableArray alloc] initWithArray:arrayValues copyItems:YES];

//    NSNumber *num = [NSNumber numberWithInt:1313654];
//    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:CACurrentMediaTime()];
//    [_total_score addObject:num];
//    [_scored_date addObject:date];
//    totalAry = [[NSMutableArray alloc] init];
//    for (int i = 0; i < _scored_date.count; i++) {
//        NSArray *items = [[NSArray alloc] initWithObjects:[_total_score objectAtIndex:i], [_scored_date objectAtIndex:i], nil];
//        [totalAry addObject:items];
//    }
    
    return self;
}

-(int) getTotalScore
{
    total = 0;
    for (NSNumber *score in _total_score) {
        total += [score intValue];
    }
    
    return total;
}

-(int) getPostion
{
    return _total_score.count;
}

-(int) getScoreOrder:(NSNumber *)scored_value
{
    NSInteger order = [_sorted_total_score indexOfObject:[NSNumber numberWithInt:scored_value]];
    NSLog(@"%d", (int)[NSNumber numberWithInt:scored_value]);
    return order;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) addThumbnail {
//    useThumbnail = !useThumbnail;
//    [[self tableView] reloadData];
}

-(void) sortArrray
{
    _sorted_score = [[NSMutableArray alloc] init];
    _sorted_total_score = [[NSArray alloc] init];
    
    _sorted_total_score = [[[_total_score sortedArrayUsingSelector:@selector(compare:)] reverseObjectEnumerator] allObjects];
    NSLog(@"reverse sort : %@", _sorted_total_score);
    
    for (int i = 0; i < _total_score.count; i++) {
        NSArray *sorted_items = [[NSArray alloc] initWithObjects:[_sorted_total_score objectAtIndex:i], [_scored_date objectAtIndex:[_total_score indexOfObject:[_sorted_total_score objectAtIndex:i]]], nil];
        [_sorted_score addObject:sorted_items];
    }
    
    NSLog(@"final sorted array : %@", _sorted_score);
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) addToHighscore:(NSNumber *)scored_value {
    
    NSNumber *num = [NSNumber numberWithInt:scored_value];
//    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:CACurrentMediaTime()];
    NSString *dateString = [self curentDateStringFromDate:[NSDate date] withFormat:@"yyyy-MM-dd"];
    NSLog(@"asdjfhas = %@, %@", dateString, dateString);
    
//    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *str = [dateFormatter stringFromDate:[NSDate date]];
//    NSDate *dt = [NSDate date];
//    dt = [dateFormatter dateFromString:str];
//    NSLog(@"dt = %@, %@", dateFormatter, dt);
    [_total_score addObject:num];
    NSLog(@"%@", [NSDate date]);
    [_scored_date addObject:dateString];
    NSArray *items = [[NSArray alloc] initWithObjects:num, dateString, nil];
    [totalAry addObject:items];
    
    [self sortArrray];

    // Open plist file
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"questsPList.plist"];
    
    NSString *errorDesc = nil;
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:path];
    NSPropertyListFormat format;
    
    // Load plist file into NSData
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"questsPList" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    if (!temp)
    {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    NSDictionary *saveData = [NSDictionary dictionaryWithObject:[NSArray arrayWithArray:totalAry] forKey:@"QuestsArray"];
    
    // check is savedata exists
    if(saveData)
    {
        // write plistData to our Data.plist file
        [saveData writeToFile:path atomically:YES];
        [self.tableView reloadData];
        NSLog(@"%@", totalAry);
        [[self tableView] reloadData];
    }
    else
    {
        NSLog(@"Error in saveData: %@", error);
        [error release];
    }
    
}

- (NSString *)curentDateStringFromDate:(NSDate *)dateTimeInLine withFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:dateFormat];
    
    NSString *convertedString = [formatter stringFromDate:dateTimeInLine];
    
    return convertedString;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [tableView registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyTableViewCell"];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _scored_date.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    cell.positionLbl.text = [NSString stringWithFormat:@"%d", indexPath.row+1];
//    cell.scoreLbl.text = [NSString stringWithFormat:@"%@", [_total_score objectAtIndex:indexPath.row]];
    cell.scoreLbl.text = [NSString stringWithFormat:@"%@", [[_sorted_score objectAtIndex:indexPath.row] objectAtIndex:0]];
    NSLog(@"%@", [_total_score objectAtIndex:indexPath.row]);
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    cell.usernameLbl.text = userName;
//    cell.dateLbl.text = [NSString stringWithFormat:@"%@", [_scored_date objectAtIndex:indexPath.row]];
    cell.dateLbl.text = [NSString stringWithFormat:@"%@", [[_sorted_score objectAtIndex:indexPath.row] objectAtIndex:1]];
    NSLog(@"%@", [_scored_date objectAtIndex:indexPath.row]);
    
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
//    NSString *title;
//    if (isGrouped == NO) {
//        title = [NSString stringWithFormat:@"Cell: %d", indexPath.row];       
//    }else{
//        title = [NSString stringWithFormat:@"Section: %d", indexPath.section];       
//    }
//    
//    // Navigation logic may go here. Create and push another view controller.
//    DetailViewController *detailViewController = [[DetailViewController alloc] initWitTitle:title]; 
//
//    //Get access to navigation controller from delegate
//    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
//    [delegate.navigationController pushViewController:detailViewController animated:YES];
//    
//    [detailViewController release];
}

@end
