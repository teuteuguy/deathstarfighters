//
//  SHUMenuTableViewController.m
//  deathstarfighers
//
//  Created by Timothee Cruse on 08/02/14.
//  Copyright (c) 2014 TC. All rights reserved.
//

#import "SHUMenuTableViewController.h"

#import "SHUItemListViewController.h"
#import "SHUSimpleListViewController.h"
#import "Utils.h"

//#define shubaccaQueue2 dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ) //1
////#define shubaccaQueue3 dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ) //1
//#define shubaccaGetConfigForIDUrl(shu) [NSString stringWithFormat:@"http://api.shubacca.com/shu/%@/config?consumer_key=4a8e628392a504eb746c37e1b0044f0f&sort=id,desc&limit=1", shu] //2
////#define shubaccaGetStatusesForIDUrl(shu) [NSString stringWithFormat:@"http://api.shubacca.com/shu/%@/status?consumer_key=4a8e628392a504eb746c37e1b0044f0f&sort=id,desc&limit=1", shu] //2

@interface SHUMenuTableViewController ()

@end

@implementation SHUMenuTableViewController {
    int shuIndex;
}

@synthesize itemSHU;
@synthesize configItems;
@synthesize statusItems;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


//- (void)fetchedConfigList:(NSData *)responseData {
//    NSError * error;
//    NSArray * responseArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
//    
//    if ( error != Nil ) {
//        NSLog( @"Could not make connection with server" );
//    } else {
//        
//        
//        
//        for( NSDictionary * object in responseArray ) {
//        
////            NSMutableDictionary * newDictionary = [[NSMutableDictionary alloc] init];
////            NSMutableDictionary * opDictionary = [[NSMutableDictionary alloc] init];
////            
////            for( NSString * key in [object allKeys] ) {
////                if ( [key isEqualToString:@"operators"] ) {
////                    for ( NSDictionary * operator in [object objectForKey:key] ) {
////                        [opDictionary addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[operator objectForKey:@"ezlink_pin"], [operator objectForKey:@"ezlink_can"], nil]];
////                    }
////                } else {
////                    [newDictionary addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[[object objectForKey:key] description], key, nil]];
////                }
////                
////            }
////            
////            [newDictionary addEntriesFromDictionary:opDictionary];
////            [configItems addObject:newDictionary];
//            configItems = [[NSDictionary alloc] initWithDictionary:object];
//            //[configItems addObject:object];
//            [self.tableView reloadData];
//        }
//    }
//}

//- (void)fetchedStatusList:(NSData *)responseData {
//    //parse out the json data
//    NSError * error;
//    
//    NSArray * responseArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
//    
//    if ( error != Nil ) {
//        NSLog( @"Could not make connection with server" );
//    } else {
//        
//
//        for( NSDictionary * object in responseArray ) {
//            
//            statusItems = [[NSDictionary alloc] initWithDictionary:object];
//            [self.tableView reloadData];
//            
//        }
//    }
//}



- (void)viewWillAppear:(BOOL)animated {
    UIColor * backgroundcolor = [UIColor colorWithRed:119/255.0 green:153/255.0 blue:203/255.0 alpha:1];
    [self.tableView setBackgroundColor:backgroundcolor];
    [self.tableView setSeparatorColor:backgroundcolor];
    
    //configItems = nil;
    //statusItems = nil;
    //[self.tableView reloadData];
    
    [[SHUBaccaConnection sharedSHUBaccaConnection] setDelegate:self];
    
//    dispatch_async(shubaccaQueue2, ^{
//        NSData * data = [ NSData dataWithContentsOfURL:[NSURL URLWithString:shubaccaGetConfigForIDUrl( [self.itemSHU valueForKey:@"id"] ) ] ];
//        [self performSelectorOnMainThread:@selector(fetchedConfigList:) withObject:data waitUntilDone:YES];
//    });
//    dispatch_async(shubaccaQueue3, ^{
//        NSData * data = [ NSData dataWithContentsOfURL:[NSURL URLWithString:shubaccaGetStatusesForIDUrl( [self.itemSHU valueForKey:@"id"] ) ] ];
//        [self performSelectorOnMainThread:@selector(fetchedStatusList:) withObject:data waitUntilDone:YES];
//    });
}


- (void)updating {
    [self.tableView reloadData];
}
- (void)doneUpdating {
    [self.tableView reloadData];
}

- (void)setConfigItems:(NSDictionary *)newConfigItems
{
    if (configItems != newConfigItems) {
        configItems = newConfigItems;
    }
}
- (void)setStatusItems:(NSArray *)newStatusItems
{
    if (statusItems != newStatusItems) {
        statusItems = newStatusItems;
    }
}
- (void)setItemSHU:(id)newItemSHU
{
    if (itemSHU != newItemSHU) {
        itemSHU = newItemSHU;

        // Update the view.
        [self configureView];
    }
}
- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.itemSHU) {
        self.navigationItem.title = [self.itemSHU valueForKey:@"description"];
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
    // 1st is detail view (with map)
    // 2nd is the menu to go to all status fields
    // 3rd is the config
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
//    if ( section <= 1 ) return 1;
//    else                return [configItems[0] count];
    switch (section) {
        case 0:
//            if ( [[SHUBaccaConnection sharedSHUBaccaConnection] shuStatuses][itemIndex.integerValue] != nil ) {
//                return 1 + [[[[SHUBaccaConnection sharedSHUBaccaConnection] shuStatuses] objectAtIndex:itemIndex.integerValue] count];
            if ( statusItems != nil ) {
                return 1 + [[statusItems objectAtIndex:0] count];
            } else {
                return 0;
            }
            break;
        case 1:
            return 1;
            break;
        case 2:
            return [configItems count];
            return 0;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            if ( indexPath.row == 0 ) {
                return 220;
            } else {
                return 30;
            }
            break;
        case 1:
            return 30;
            break;
        case 2:
            return 30;
            break;
        default:
            break;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Last Status";
            break;
        case 1:
            return @"All Status";
            break;
        case 2:
            return @"Config";
            break;
        default:
            return @"WTF";
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSString *CellIdentifier;
    
    switch (indexPath.section) {
        case 0:
            if ( indexPath.row == 0 ) {
                CellIdentifier = @"MapCell";
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
                //NSLog(@"%f", cell.frame.size.height);
                
                // 1
                CLLocationCoordinate2D zoomLocation;
                NSString * latlong = [self.itemSHU valueForKey:@"last_known_gps_coordinates"];
                if ( ! [latlong isEqual:[NSNull null]] ) {
                    NSArray * temp = [latlong componentsSeparatedByString:@","];
                    zoomLocation.latitude = [temp[0] floatValue];
                    zoomLocation.longitude = [temp[1] floatValue];
                    
                    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                    point.coordinate = zoomLocation;
                    point.title = [self.itemSHU valueForKey:@"description"];
                    point.subtitle = [Utils intervalInSecsAgo:[self.itemSHU valueForKey:@"last_known_gps_datetime"]];
                    
                    // 2
                    #define METERS_PER_MILE 1609.344
                    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 1.0*METERS_PER_MILE, 1.0*METERS_PER_MILE);
                    
                    // 3
                    CGRect frame = CGRectMake(cell.frame.origin.x, 0, cell.frame.size.width, 220);
                    MKMapView * map = [[MKMapView alloc] initWithFrame:frame];
                    [map setRegion:viewRegion animated:YES];
                    [map addAnnotation:point];
                    [map selectAnnotation:point animated:NO];
                    [cell addSubview:map];
                }
            } else {
                NSArray * allkeys = [[statusItems objectAtIndex:0] allKeys];
                NSArray * allvalues = [[statusItems objectAtIndex:0] allValues];
                NSString * title = [[allkeys objectAtIndex:indexPath.row-1] description];
                if ( [title isEqual:[NSNull null]] ) title = @"";
                if ( [[allvalues objectAtIndex:indexPath.row-1] isKindOfClass:[NSArray class]] ) {
                    CellIdentifier = @"ToSimpleListCell";
                    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
                    cell.textLabel.text = title;
                    cell.detailTextLabel.text = @"";
                } else {
                    CellIdentifier = @"InfoCell";
                    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
                    NSString * value = [[allvalues objectAtIndex:indexPath.row-1] description];
                    cell.textLabel.text = title;
                    if ( ! [value isEqual:[NSNull null]] ) cell.detailTextLabel.text = value;
                    else cell.detailTextLabel.text = @"";
                }
            }
            break;
        case 1:
            CellIdentifier = @"MenuCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.textLabel.text = @"Status";
            cell.detailTextLabel.text = [Utils intervalInSecsAgo:[self.itemSHU valueForKey:@"last_known_status_datetime"]];
            break;
        case 2:
        {
            NSArray * allkeys = [configItems allKeys];
            NSArray * allvalues = [configItems allValues];
            NSString * title = [[allkeys objectAtIndex:indexPath.row] description];
            if ( [title isEqual:[NSNull null]] ) title = @"";
            
            
            if ( [[allvalues objectAtIndex:indexPath.row] isKindOfClass:[NSArray class]] ) {
                NSString *CellIdentifier = @"ToSimpleListCell";
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
                
                cell.textLabel.text = title;
                cell.detailTextLabel.text = @"";
            } else {
                NSString *CellIdentifier = @"InfoCell";
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
                NSString * value = [[allvalues objectAtIndex:indexPath.row] description];
                
                cell.textLabel.text = title;
                if ( ! [value isEqual:[NSNull null]] ) cell.detailTextLabel.text = value;
                else cell.detailTextLabel.text = @"";
            }
        }
            break;
        default:
            break;
    }
    
//    if ( indexPath.section == 0 ) {
//        NSString *CellIdentifier = @"MenuCell";
//        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//        cell.textLabel.text = @"Status";
//        cell.detailTextLabel.text = [Utils intervalInSecsAgo:[self.itemSHU valueForKey:@"last_known_status_datetime"]];
//    } else if ( indexPath.section == 1 ) {
//        NSString *CellIdentifier = @"MenuCell";
//        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//        cell.textLabel.text = @"Status";
//        cell.detailTextLabel.text = [Utils intervalInSecsAgo:[self.itemSHU valueForKey:@"last_known_status_datetime"]];
//    } else {
//        NSArray * allkeys = [[configItems objectAtIndex:0] allKeys];
//        NSArray * allvalues = [[configItems objectAtIndex:0] allValues];
//        NSString * title = [[allkeys objectAtIndex:indexPath.row] description];
//        if ( [title isEqual:[NSNull null]] ) title = @"";
//        
//        
//        if ( [[allvalues objectAtIndex:indexPath.row] isKindOfClass:[NSArray class]] ) {
//            NSString *CellIdentifier = @"ToSimpleListCell";
//            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//
//            cell.textLabel.text = title;
//            cell.detailTextLabel.text = @"";
//        } else {
//            NSString *CellIdentifier = @"ConfigCell";
//            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//            NSString * value = [[allvalues objectAtIndex:indexPath.row] description];
//            
//            cell.textLabel.text = title;
//            if ( ! [value isEqual:[NSNull null]] ) cell.detailTextLabel.text = value;
//            else cell.detailTextLabel.text = @"";
//        }
//    }
    
    // Configure the cell...
    
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
 
    if ([[segue identifier] isEqualToString:@"showList"]) {
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [[segue destinationViewController] setItemSHU:[self itemSHU]];
        [[segue destinationViewController] setItemType:[[(UITableViewCell *)sender textLabel] text]];
        //[[segue destinationViewController] navigationItem].title = [[(UITableViewCell *)sender textLabel] text];//[[shus[indexPath.row] valueForKey:@"id"] description];
        //        //NSDate *object = _objects[indexPath.row];
    }
    if ([[segue identifier] isEqualToString:@"showSimpleList"]) {
        [[segue destinationViewController] setItemTitle:[[(UITableViewCell *)sender textLabel] text]];
        
        
        NSMutableDictionary * newDictionary = [[NSMutableDictionary alloc] init];

        for ( NSDictionary * object in [configItems valueForKey:[[(UITableViewCell *)sender textLabel] text]] ) {
            NSDictionary * temp;
            if ( [[[[(UITableViewCell *)sender textLabel] text] description] isEqualToString:@"operators"] ) {
                temp = [NSDictionary dictionaryWithObject:[object valueForKey:@"ezlink_pin"] forKey:[object valueForKey:@"ezlink_can"]];
            } else {
                temp = [NSDictionary dictionaryWithObject:@"" forKey:[object valueForKey:@"Not Handled yet"]];
                
            }
            [newDictionary addEntriesFromDictionary:temp];
        }
        
        [[segue destinationViewController] setItemList:newDictionary];
    }
}


@end
