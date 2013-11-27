//
//  MainTableViewController.m
//  mifd
//
//  Created by 이종현 on 2013. 11. 20..
//  Copyright (c) 2013년 belhyun. All rights reserved.
//

#import "MainTableViewController.h"
#import "MainTableViewCell.h"
#import "HttpClient.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 20.0f

@interface MainTableViewController ()
@property(nonatomic,assign) NSUInteger selectedRow;
@property(nonatomic,assign) Boolean isExpand;
@property (nonatomic, retain) NSArray *tweets;
@end
@implementation MainTableViewController

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
    NSLog(@"#####MainTableViewController load");
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.separatorColor = [UIColor yellowColor];
    self.selectedRow = -1;
    self.isExpand = false;
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    self.HUD.delegate = self;
    [self fetchTweets];
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
    return self.tweets.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (Boolean)isDefinedEle:(NSArray *)array :(NSInteger)tag{
    NSEnumerator *enumerator = [array objectEnumerator];
    id anObject;
    if([array count] == 0) return false;
    while (anObject = [enumerator nextObject]) {
        if(((UIView *)anObject).tag == tag){
            return  true;
        }
    }
    return false;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

-(void) expandRow:(UITapGestureRecognizer *)gr{
    MainTableViewCell *view = (MainTableViewCell *)gr.view;
    self.selectedRow = view.itemId;
    if(self.isExpand){
        self.isExpand = false;
    }else{
        self.isExpand = true;
    }
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

-(void) fetchTweets{
    [self.HUD show:YES];
    HttpClient *httpClient = [HttpClient sharedClient];
    [httpClient GET:RANK parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.HUD hide:YES];
        NSMutableArray *results = [NSMutableArray array];
        for(id tweetDictionary in responseObject){
            Tweet *tweet = [[Tweet alloc] initWithDictionary:tweetDictionary];
            [results addObject:tweet];
        }
        self.tweets = results;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.HUD hide:YES];
        NSLog(@"Error: %@", error);
    }];
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tweet";
    UITableViewCell *cell = nil;
    MainTableViewCell *subCell = nil;
    Tweet *tweet = [self.tweets objectAtIndex:indexPath.section];
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(![self isDefinedEle:cell.contentView.subviews:1]){
        subCell = [[MainTableViewCell alloc]init];
        subCell.itemId = indexPath.section;
        [subCell setFrame:CGRectMake(10, 0, cell.contentView.bounds.size.width-18, cell.bounds.size.height)];
        subCell.backgroundColor = [UIColor yellowColor];
        [subCell setTag:1];
        [cell addSubview:subCell];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandRow:)];
        [subCell addGestureRecognizer:tap];
    }
    
    if(![self isDefinedEle:cell.contentView.subviews:2]){
        UILabel *text = [[UILabel alloc]init];
        [text setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        text.attributedText = [self getText:tweet];
        [text setNumberOfLines:0];
        [text setFrame:CGRectMake(60, 0, cell.contentView.bounds.size.width-85, cell.bounds.size.height)];
        [text setTag:2];
        [[subCell contentView] addSubview:text];
    }
    
    if(![self isDefinedEle:cell.contentView.subviews:2]){
        UIImage * image = [UIImage imageNamed: @"twitter_thumb.png"];
        UIImageView * imageView = [[UIImageView alloc] initWithImage: image];
        [imageView setFrame:CGRectMake(0, 0, 50.0, 50.0)];
        [imageView setTag:3];
        [[subCell contentView]addSubview:imageView];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setSelected:NO animated:NO];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;{
    Tweet *tweet = [self.tweets objectAtIndex:indexPath.section];
    NSString *text = [[self getText:tweet] string];
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGRect boundingRect = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FONT_SIZE]} context:nil];
    CGSize size = boundingRect.size;
    return size.height + (CELL_CONTENT_MARGIN * 2);
}

-(NSMutableAttributedString *)getText:(Tweet *)tweet{
    NSString *needToChangeStr = tweet.user.name;
    NSString *displayString = [NSString stringWithFormat:@"%@ %@\n\n%@", tweet.user.name,tweet.user.screenName,tweet.text];
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc]initWithString:displayString];
    NSUInteger begin = 0;
    NSUInteger end = [needToChangeStr length];
    [attriStr addAttribute:NSFontAttributeName value:[UIFont  fontWithName:@"HelveticaNeue-Bold" size:20] range:NSMakeRange(begin, end)];
    return attriStr;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(self.isExpand && section == self.selectedRow){
       return 50.0;
    }
    return 0.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
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
