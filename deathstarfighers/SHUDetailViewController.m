//
//  SHUDetailViewController.m
//  deathstarfighers
//
//  Created by Timothee Cruse on 09/02/14.
//  Copyright (c) 2014 TC. All rights reserved.
//

#import "SHUDetailViewController.h"

#define METERS_PER_MILE 1609.344

@interface SHUDetailViewController ()

@end

@implementation SHUDetailViewController

@synthesize map;
@synthesize tableView;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    // 1
    CLLocationCoordinate2D zoomLocation;
    NSDictionary * dict = [self.itemDetail valueForKey:@"gps"];
    int fix = [(NSNumber *)[dict valueForKey:@"fix"] integerValue];
    if ( fix > 1 ) {
        zoomLocation.latitude = [(NSNumber *)[dict valueForKey:@"latitude"] floatValue];
        zoomLocation.longitude= [(NSNumber *)[dict valueForKey:@"longitude"] floatValue];
        
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = zoomLocation;
        point.title = [self.itemSHU valueForKey:@"description"];
        point.subtitle = @"I'm here!!!";
        

        // 2
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 1.0*METERS_PER_MILE, 1.0*METERS_PER_MILE);
        
        // 3
        [map setRegion:viewRegion animated:YES];
        [map addAnnotation:point];
        [map selectAnnotation:point animated:NO];
    }
}

- (void)setItemDetail:(NSDictionary *)newItemDetail
{
    if (_itemDetail != newItemDetail) {
        _itemDetail = newItemDetail;
        
        // Update the view.
        [self configureView];
    }
}
- (void)setItemSHU:(NSDictionary *)newItemSHU
{
    if (_itemSHU != newItemSHU) {
        _itemSHU = newItemSHU;
        
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
    //NSLog( @"numberOfSectionsInTableView" );
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //NSLog( @"%i", self.itemArray.count );
    return self.itemDetail.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DetailCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    //    if (cell == nil) {
    //        cell = [[UITableViewCell alloc] init];
    //    }
    //    NSLog( @"%i", [indexPath row] );
    //    _objects[indexPath.row]
    //cell.detailTextLabel.text = [shus[indexPath.row] valueForKey:@"id"];//[[[shubaccaConnection shu_status] objectAtIndex:[indexPath row]] valueForKey:@"id"];
    //cell.textLabel.text = [[shus[indexPath.row] valueForKey:@"array"] valueForKey:@"description"];
    //NSLog(@"Prout");
    
    UILabel * labelTitle = (UILabel *)[cell viewWithTag:100];
    labelTitle.text = [self.itemDetail allKeys][indexPath.row];
    UILabel * labelDetail = (UILabel *)[cell viewWithTag:101];
    labelDetail.text = [[self.itemDetail allValues][indexPath.row] description];
    
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

@end
