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
#define CELL_EXTRA_AREA 30.0f;

const int kLoadingCellTag = 1273;
@interface MainTableViewController ()
@property(nonatomic,assign) Boolean isExpand;
@property (nonatomic, retain) NSMutableArray *tweets;
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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSLog(@"MainTableViewController View Load");
    self.tableView.separatorColor = [UIColor yellowColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    self.tweets = [[NSMutableArray alloc]init];
    self.isExpand = false;
    self.curPage = 1;
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    self.HUD.delegate = self;
    [self.HUD show:YES];
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
    if(self.curPage < self.totalPage){
        return self.tweets.count + 1;
    }
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
    /*
    MainTableViewCell *view = (MainTableViewCell *)gr.view;
    if(self.isExpand){
        self.isExpand = false;
    }else{
        self.isExpand = true;
    }
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    */
}

-(void) fetchTweets{
    //[self.HUD show:YES];
    HttpClient *httpClient = [HttpClient sharedClient];
    [httpClient GET:[NSMutableString stringWithFormat:@"%@?page=%d",RANK,self.curPage] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.HUD hide:YES];
        self.totalPage = [[responseObject objectForKey:@"total_page"] intValue];
        self.totalCount = [[responseObject objectForKey:@"total_count"] intValue];
        responseObject = [responseObject objectForKey:@"tweets"];
        for(id tweetDictionary in responseObject){
            Tweet *tweet = [[Tweet alloc] initWithDictionary:tweetDictionary];
             [self.tweets addObject:tweet];
        }
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
    cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if(indexPath.section < self.tweets.count){
        if ((([cell.contentView viewWithTag:1])))
        {
            [[cell.contentView viewWithTag:1]removeFromSuperview];
        }
        Tweet *tweet = [self.tweets objectAtIndex:indexPath.section];
        MainTableViewCell *subCell = [[MainTableViewCell alloc]init];
        subCell.itemId = indexPath.section;
        [subCell setFrame:CGRectMake(10, 0, cell.contentView.bounds.size.width-18, cell.bounds.size.height)];
        subCell.backgroundColor = [UIColor yellowColor];
        [subCell setTag:indexPath.section];
        //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandRow:)];
        //[subCell addGestureRecognizer:tap];
        subCell.tag = 1;
        [cell.contentView addSubview:subCell];
        
        TTTAttributedLabel *text = [[TTTAttributedLabel alloc] init];
        text.delegate = self;
        text.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        [text setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        text.text = [[self getText:tweet] mutableCopy];
        [text setNumberOfLines:0];
        [text setFrame:CGRectMake(60, 0, cell.contentView.bounds.size.width-85, cell.bounds.size.height)];
        [text sizeToFit];
        [[subCell contentView] addSubview:text];

        UIImageView * imageView = [[UIImageView alloc] init];
        [imageView setFrame:CGRectMake(0, 0, 50.0, 50.0)];
        [[subCell contentView] addSubview:imageView];
        [HttpClient downloadingServerImageFromUrl:imageView AndUrl:tweet.user.image];
        [subCell.contentView addSubview:imageView];
        
    }else{
       return [self loadingCell];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setSelected:NO animated:NO];
    cell.userInteractionEnabled = YES;
    return cell;
}

-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url{
    NSLog(@"didSelectLinkWithURL");
}

-(UITableViewCell *)loadingCell{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = cell.center;
    [cell addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    cell.tag = kLoadingCellTag;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;{
    if(indexPath.section == self.curPage*10) return 0.0;
    Tweet *tweet = [self.tweets objectAtIndex:indexPath.section];
    NSString *text = [[self getText:tweet] string];
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGRect boundingRect = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FONT_SIZE]} context:nil];
    CGSize size = boundingRect.size;
    return size.height + (CELL_CONTENT_MARGIN * 2);//+ CELL_EXTRA_AREA;
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
    /*
    if(self.isExpand && section == self.selectedRow){
       return 50.0;
    }
     */
    return 0.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.curPage <= self.totalPage && cell.tag == kLoadingCellTag){
        self.curPage++;
        [self fetchTweets];
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
