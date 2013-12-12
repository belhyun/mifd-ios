//
//  UserSnsTableViewController.m
//  mifd
//
//  Created by 이종현 on 2013. 12. 12..
//  Copyright (c) 2013년 belhyun. All rights reserved.
//

#import "UserSnsTableViewController.h"

@interface UserSnsTableViewController ()
@end

@implementation UserSnsTableViewController

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
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    self.HUD.delegate = self;
  
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if(indexPath.row == 0){
        if([[MifdKeychainItemWrapper sharedClient] objectForKey:(__bridge id)(kSecAttrAccount)] != nil){
            [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@",@"트위터 연동", [[MifdKeychainItemWrapper sharedClient] objectForKey:(__bridge id)(kSecAttrAccount)]]];
        }else{
            [cell.textLabel setText:@"트위터 연동"];
        }
    }else if(indexPath.row == 1){
        [cell.textLabel setText:@"페이스북 연동"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    // Configure the cell...
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [self.HUD show:YES];
        [appDelegate getTwitterAccountOnCompletion:^(ACAccount *twitterAccount){
            //If we successfully retrieved a Twitter account
            [self.HUD hide:YES];
            if(twitterAccount) {
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@",cell.textLabel.text, twitterAccount.accountDescription]];
                [[MifdKeychainItemWrapper sharedClient] setObject:twitterAccount.accountDescription forKey:(__bridge id)(kSecAttrAccount)];
            }
        }];
    }else{
    }
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
