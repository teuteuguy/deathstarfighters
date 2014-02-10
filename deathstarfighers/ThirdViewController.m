//
//  ThirdViewController.m
//  deathstarfighers
//
//  Created by Timothee Cruse on 08/02/14.
//  Copyright (c) 2014 TC. All rights reserved.
//

#import "ThirdViewController.h"

#import "SHUMenuTableViewController.h"
#import "Utils.h"

#define shubaccaQueue1 dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ) //1
#define shubaccaGetIDsUrl @"http://api.shubacca.com/shu?consumer_key=4a8e628392a504eb746c37e1b0044f0f&sort=id,desc" //2

@interface ThirdViewController () {
}
@end

@implementation ThirdViewController

@synthesize shus;


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    //shubaccaConnection = [SHUBaccaConnection sharedSHUBaccaConnection];
    //[shubaccaConnection update];
    
    [super viewDidLoad];
    
    [self.tableView setBackgroundView: nil];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:122.0 green:155.0 blue:207.0 alpha:1]];
    
    self.navigationItem.title = @"SHUs";

    dispatch_async(shubaccaQueue1, ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:shubaccaGetIDsUrl]];
        [self performSelectorOnMainThread:@selector(fetchedIDs:) withObject:data waitUntilDone:YES];
    });
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)viewWillAppear:(BOOL)animated {
    //    UIView * bview = [[UIView alloc] init];
    //    bview.backgroundColor = [UIColor colorWithRed:119/255.0 green:153/255.0 blue:203/255.0 alpha:1];
    //    [self.tableView setBackgroundView:bview];
    UIColor * backgroundcolor = [UIColor colorWithRed:119/255.0 green:153/255.0 blue:203/255.0 alpha:1];
    [self.tableView setBackgroundColor:backgroundcolor];
    [self.tableView setSeparatorColor:backgroundcolor];
    [self.navigationController.navigationBar setBackgroundColor:backgroundcolor];
}


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
    
    NSArray * responseArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
    if ( error != Nil ) {
        NSLog( @"Could not make connection with server" );
    } else {
        
        if ( shus == Nil ) {
            shus = [[NSMutableArray alloc] init];
        }
        [shus removeAllObjects];

        for( NSDictionary * object in responseArray ) {
//
//            NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.shubacca.com/shu/%@/status?consumer_key=4a8e628392a504eb746c37e1b0044f0f&sort=id,desc&limit=2", [object valueForKey:@"id"]]];
//            
//            NSData* data = [NSData dataWithContentsOfURL:url];
//            NSArray * statusArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//            
//            if ( error != Nil ) {
//                NSLog( @"Could not make status connection with server" );
//            } else {
//                
//                NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                              [object valueForKey:@"id"], @"id",
//                                              [[NSDictionary alloc] initWithDictionary:object], @"array",
//                                              nil];
            [shus insertObject:object atIndex:0];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//
//            }
//            
        }
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
    //NSLog( @"numberOfSectionsInTableView" );
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int nb_of_rows = [shus count];
    //NSLog( @"%i", nb_of_rows );
    return nb_of_rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SHUIDCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    UILabel * title = (UILabel *)[cell viewWithTag:100];
    UILabel * telephone = (UILabel *)[cell viewWithTag:101];
    UILabel * status_secs_ago = (UILabel *)[cell viewWithTag:102];
    UILabel * gps_secs_ago = (UILabel *)[cell viewWithTag:103];

    title.text = [shus[indexPath.row] valueForKey:@"description"];
    telephone.text = [shus[indexPath.row] valueForKey:@"telephone_number"];
    //status_secs_ago.text = [shus[indexPath.row] valueForKey:@"last_known_status_datetime"];
    //gps_secs_ago.text = [shus[indexPath.row] valueForKey:@"last_known_gps_datetime"];
    status_secs_ago.text = [Utils intervalInSecsAgo:[shus[indexPath.row] valueForKey:@"last_known_status_datetime"]];
    gps_secs_ago.text = [Utils intervalInSecsAgo:[shus[indexPath.row] valueForKey:@"last_known_gps_datetime"]];
//    
//    int interval = (int)[[NSDate date] timeIntervalSinceDate:[formatter dateFromString: [shus[indexPath.row] valueForKey:@"last_known_gps_datetime"]]];
//    if ( interval < 60 ) {
//        secs_ago.text = [NSString stringWithFormat:@"%.02is ago", interval];
//    } else if ( interval < 60 * 60 ) {
//        secs_ago.text = [NSString stringWithFormat:@"%.02im:%.02i ago", (int)(interval / 60), (interval % 60) ];
//    } else if ( interval < 60 * 60 * 24 ) {
//        secs_ago.text = [NSString stringWithFormat:@"%.02i:%.02i:%.02i ago", (int)(interval / 3600), (int)((interval % 3600) / 60), (interval % 60) ];
//    } else {
//        secs_ago.text = [NSString stringWithFormat:@"%id %.02i:%.02i:%.02i ago", (int)(interval / (3600 * 24)), (int)((interval % (3600 * 24)) / 3600), (int)((interval % 3600) / 60), (interval % 60) ];
//    }
    
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
    //NSLog([sender description]);
    
    if ([[segue identifier] isEqualToString:@"showMenu"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        //NSDate *object = _objects[indexPath.row];
        //[[segue destinationViewController] navigationItem].title = [shus[indexPath.row] valueForKey:@"id"];
        //NSLog( @"%@", [shus[indexPath.row] valueForKey:@"id"] );
        [[segue destinationViewController] setItemSHU:shus[indexPath.row]];
    }
}


@end
