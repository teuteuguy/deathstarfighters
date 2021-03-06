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

@interface ThirdViewController ()

@end

@implementation ThirdViewController

@synthesize shus;
@synthesize shuStatuses;
@synthesize shuConfigs;

@synthesize activityView;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self.tableView setBackgroundView: nil];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:122.0 green:155.0 blue:207.0 alpha:1]];
    
    self.navigationItem.title = @"SHUs";
    
    activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    activityView.hidden = TRUE;
    [activityView startAnimating];

    UIBarButtonItem * activityButton = [[UIBarButtonItem alloc] initWithCustomView:activityView ];
    self.navigationItem.rightBarButtonItem = activityButton;
    
    shus = nil;//[[NSMutableArray alloc] init];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(forceUpdate) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
}



- (void)viewWillAppear:(BOOL)animated {

//    UIColor * backgroundcolor = [UIColor colorWithRed:119/255.0 green:153/255.0 blue:203/255.0 alpha:1];
//    [self.tableView setBackgroundColor:backgroundcolor];
//    [self.tableView setSeparatorColor:backgroundcolor];
//    [self.navigationController.navigationBar setBackgroundColor:backgroundcolor];
    
    [[SHUBaccaConnection sharedSHUBaccaConnection] setDelegate:self];
    
    [self forceUpdate];
}


- (void)forceUpdate {
    
    [[SHUBaccaConnection sharedSHUBaccaConnection] update];
    [self doneUpdating];
}

- (void)updating {

    activityView.hidden = FALSE;

}

- (void)foundSHUWithID:(int)id atIndex:(int)index {
    
//    [self.tableView insertRowsAtIndexPaths:<#(NSArray *)#> withRowAnimation:<#(UITableViewRowAnimation)#>]
    
}

- (void)doneUpdating {
    shus = [[NSArray alloc] initWithArray:[[SHUBaccaConnection sharedSHUBaccaConnection] shus]];
    shuConfigs = [[NSArray alloc] initWithArray:[[SHUBaccaConnection sharedSHUBaccaConnection] shuConfigs]];
//    shuStatuses = [[NSArray alloc] initWithArray:[[SHUBaccaConnection sharedSHUBaccaConnection] shuStatuses]];
    
    [self.tableView reloadData];
    
    NSLog(@"ThirdView: Done Updating");
    
    activityView.hidden = TRUE;
    [self.refreshControl endRefreshing];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return shus.count;
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
    UIProgressView * progressView = (UIProgressView *)[cell viewWithTag:104];
    UILabel * chargingLabel = (UILabel *)[cell viewWithTag:105];

    NSDictionary * shu = shus[indexPath.row];
    
    NSString * shu_id = [[shu valueForKey:@"id"] description];
    
    title.text = [[shu valueForKey:@"description"] description];
    telephone.text = [[shu valueForKey:@"telephone_number"] description];
    status_secs_ago.text = [Utils intervalInSecsAgo:[[shu valueForKey:@"last_known_status_datetime"] description] ];
    gps_secs_ago.text = [NSString stringWithFormat:@"GPS: %@", [Utils intervalInSecsAgo:[[shu valueForKey:@"last_known_gps_datetime"] description] ] ];
    
    dispatch_async( dispatch_queue_create( "com.shubacca.api.bgqueue_status_for_battery", NULL ), ^(void) {
        
        NSArray * tempArray = [[SHUBaccaConnection sharedSHUBaccaConnection] fetchLastStatusForId:[shu_id integerValue]];
        
        if ( tempArray != nil ) {
            
            NSLog(@"ThirdView: cellForRowAtIndexPath: found last status update for SHU %@", shu_id);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                float progress = [[[[tempArray objectAtIndex:0] valueForKey:@"fuel_battery_state"] description] floatValue];
                progressView.progress = progress / 100;
                
                bool charging = ( [[[[tempArray objectAtIndex:0] valueForKey:@"charge_state"] description] integerValue] == 1 );
                
                if ( charging ) {
                    chargingLabel.hidden = NO;
                    progressView.progressTintColor = [UIColor blueColor];
                } else if ( progress < 30 ) {
                    chargingLabel.hidden = YES;
                    progressView.progressTintColor = [UIColor redColor];
                } else {
                    chargingLabel.hidden = YES;
                    progressView.progressTintColor = [UIColor greenColor];
                }
                
            });
            
        }
        
    });

    
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
    
    if ([[segue identifier] isEqualToString:@"showMenu"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //[[segue destinationViewController] setStatusItems:[shuStatuses objectAtIndex:indexPath.row] ];
        //[[segue destinationViewController] setConfigItems:[shuConfigs objectAtIndex:indexPath.row] ];
        //[[segue destinationViewController] setConfigItems:[[[SHUBaccaConnection sharedSHUBaccaConnection] shuConfigs] objectAtIndex:indexPath.row] ];
        [[segue destinationViewController] setItemSHU:[shus objectAtIndex:indexPath.row] ];
    }

}


@end
