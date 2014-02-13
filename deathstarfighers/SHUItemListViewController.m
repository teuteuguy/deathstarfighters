//
//  SHUItemListViewController.m
//  deathstarfighers
//
//  Created by Timothee Cruse on 08/02/14.
//  Copyright (c) 2014 TC. All rights reserved.
//

#import "SHUItemListViewController.h"

#import "SHUDetailViewController.h"
#import "Utils.h"

#define shubaccaQueue2 dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ) //1
#define shubaccaGetStatusesForIDUrl(shu,type) [NSString stringWithFormat:@"http://api.shubacca.com/shu/%@/%@?consumer_key=4a8e628392a504eb746c37e1b0044f0f&sort=id,desc", shu, [type lowercaseString]] //2

@interface SHUItemListViewController ()

@end

@implementation SHUItemListViewController

@synthesize listItems;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dispatch_async(shubaccaQueue2, ^{
        //NSString * temp = shubaccaGetStatusesForIDUrl([self itemSHU], [self itemType]);
        //NSLog(  );
        NSData * data = [ NSData dataWithContentsOfURL:[NSURL URLWithString:shubaccaGetStatusesForIDUrl( [self.itemSHU valueForKey:@"id"], [self itemType] ) ] ];
        [self performSelectorOnMainThread:@selector(fetchedList:) withObject:data waitUntilDone:YES];
    });


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)fetchedList:(NSData *)responseData {
    //parse out the json data
    NSError * error;
    
    NSArray * responseArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
    if ( error != Nil ) {
        NSLog( @"Could not make connection with server" );
    } else {
        
        if ( listItems == Nil ) {
            listItems = [[NSMutableArray alloc] init];
        }
        [listItems removeAllObjects];
        
        for( NSDictionary * object in responseArray ) {

//            NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                          [object valueForKey:@"id"], @"id",
//                                          [object valueForKey:@"created_at"], @"created_at",
//                                          [[NSDictionary alloc] initWithDictionary:object], @"array",
//                                          nil];
            [listItems addObject:object];
            
            //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[listItems count] inSection:0];
            //[self.tableView add
            //[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView reloadData];
            
        }
    }
}


- (void)setItemSHU:(id)newItemSHU
{
    if (_itemSHU != newItemSHU) {
        _itemSHU = newItemSHU;
        
        // Update the view.
        [self configureView];
    }
}
- (void)setItemType:(id)newItemType
{
    if (_itemType != newItemType) {
        _itemType = newItemType;
        
        // Update the view.
        [self configureView];
    }
}
- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.itemType) {
        self.navigationItem.title = [self.itemType description];
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
    return [listItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"STATUSESIDCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
//    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"SGT"]];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate * created_at = [formatter dateFromString: [listItems[indexPath.row] valueForKey:@"created_at"]];
//    NSDate * now = [NSDate date];
//    int interval = (int)[now timeIntervalSinceDate:created_at];

    cell.textLabel.text = [listItems[indexPath.row] valueForKey:@"id"];
//    if ( interval < 120 ) {
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.02i secs ago", interval];
//    } else  {
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.02i:%.02i secs ago", (int)(interval / 60), (interval % 60) ];
//    }
//    if ( interval < 60 ) {
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.02is ago", interval];
//    } else if ( interval < 60 * 60 ) {
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.02im:%.02i ago", (int)(interval / 60), (interval % 60) ];
//    } else if ( interval < 60 * 60 * 24 ) {
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.02i:%.02i:%.02i ago", (int)(interval / 3600), (int)((interval % 3600) / 60), (interval % 60) ];
//    } else {
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%id %.02i:%.02i:%.02i ago", (int)(interval / (3600 * 24)), (int)((interval % (3600 * 24)) / 3600), (int)((interval % 3600) / 60), (interval % 60) ];
//    }
    
    cell.detailTextLabel.text = [Utils intervalInSecsAgo:[listItems[indexPath.row] valueForKey:@"created_at"]];
    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    UIColor * backgroundcolor = [UIColor colorWithRed:119/255.0 green:153/255.0 blue:203/255.0 alpha:1];
    [self.tableView setBackgroundColor:backgroundcolor];
    [self.tableView setSeparatorColor:backgroundcolor];
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

    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [[segue destinationViewController] setItemDetail:listItems[indexPath.row]];
        [[segue destinationViewController] setItemSHU:self.itemSHU];
        //[[segue destinationViewController] setItemSHU:[self itemSHU]];
        //[[segue destinationViewController] setItemType:[[(UITableViewCell *)sender textLabel] text]];
        //[[segue destinationViewController] navigationItem].title = [[(UITableViewCell *)sender textLabel] text];//[[shus[indexPath.row] valueForKey:@"id"] description];
        //        //NSDate *object = _objects[indexPath.row];
    }
}

@end
