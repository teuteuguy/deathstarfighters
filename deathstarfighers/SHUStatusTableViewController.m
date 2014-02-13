//
//  SHUStatusTableViewController.m
//  deathstarfighers
//
//  Created by Timothee Cruse on 08/02/14.
//  Copyright (c) 2014 TC. All rights reserved.
//

#import "SHUStatusTableViewController.h"

#define shubaccaQueue2 dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ) //1
#define shubaccaGetStatusesForIDUrl(value) [NSURL URLWithString:[NSString stringWithFormat:@"http://api.shubacca.com/shu/%@/status?consumer_key=4a8e628392a504eb746c37e1b0044f0f&fields=id&sort=id,desc", value]] //2

@interface SHUStatusTableViewController () {
}
@end

@implementation SHUStatusTableViewController

@synthesize statuses;


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    //shubaccaConnection = [SHUBaccaConnection sharedSHUBaccaConnection];
    //[shubaccaConnection update];
    
    [super viewDidLoad];
    
    dispatch_async(shubaccaQueue2, ^{
        //NSLog([shubaccaGetStatusesForIDUrl(@"toto") description]);
//        NSData* data = [NSData dataWithContentsOfURL:shubaccaGetStatusesForIDUrl];
//        [self performSelectorOnMainThread:@selector(fetchedIDs:) withObject:data waitUntilDone:YES];
    });
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    //    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //    self.navigationItem.rightBarButtonItem = addButton;
}

//- (void)setDetailItem:(id)newDetailItem
//{
//    if (_detailItem != newDetailItem) {
//        _detailItem = newDetailItem;
//        
//        // Update the view.
//        [self configureView];
//    }
//}
//- (void)configureView
//{
//    // Update the user interface for the detail item.
//    
//    if (self.detailItem) {
//        self.navigationItem.title = [self.detailItem description];
//        self.detailDescriptionLabel.text = [self.detailItem description];
//    }
//}

//- (void)insertNewObject:(id)sender
//{
//    if (!_objects) {
//        _objects = [[NSMutableArray alloc] init];
//    }
//    [_objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}


- (void)fetchedIDs:(NSData *)responseData {
    //parse out the json data
    NSError * error;
    
    //NSArray * responseArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
    if ( error != Nil ) {
        NSLog( @"Could not make connection with server" );
    } else {
        //NSLog( [responseArray description] );
//        if ( shus == Nil ) {
//            shus = [[NSMutableArray alloc] init];
//        }
//        [shus removeAllObjects];
//        
//        for( NSArray * object in responseArray ) {
//            //
//            //            NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.shubacca.com/shu/%@/status?consumer_key=4a8e628392a504eb746c37e1b0044f0f&sort=id,desc&limit=2", [object valueForKey:@"id"]]];
//            //
//            //            NSData* data = [NSData dataWithContentsOfURL:url];
//            //            NSArray * statusArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//            //
//            //            if ( error != Nil ) {
//            //                NSLog( @"Could not make status connection with server" );
//            //            } else {
//            //
//            NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                          [object valueForKey:@"id"], @"id",
//                                          //                                              [[NSArray alloc] initWithArray:statusArray], @"array",
//                                          nil];
//            [shus insertObject:dict atIndex:0];
//            
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            //
//            //            }
//            //
//        }
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSInteger nb_of_rows = [statuses count];
    return nb_of_rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"STATUSESIDCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    //    if (cell == nil) {
    //        cell = [[UITableViewCell alloc] init];
    //    }
    //NSLog( @"%i", [indexPath row] );
    //    _objects[indexPath.row]
    cell.textLabel.text = [shus[indexPath.row] valueForKey:@"id"];//[[[shubaccaConnection shu_status] objectAtIndex:[indexPath row]] valueForKey:@"id"];
    
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
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //NSLog([segue identifier]);
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSLog( @"Prout" );
        //        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //        NSDate *object = _objects[indexPath.row];
        //        [[segue destinationViewController] setDetailItem:object];
    }
}


@end