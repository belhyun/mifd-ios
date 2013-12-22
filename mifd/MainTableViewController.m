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
#import "AppDelegate.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 5.0f
#define CELL_EXTRA_AREA 60.0f;

const int kLoadingCellTag = 1273;
@interface MainTableViewController ()
@property(nonatomic,assign) Boolean isExpand;
@property (nonatomic, retain) NSMutableArray *tweets;
-(void)pullToRefresh;
-(void)stopRefresh;
-(void)scrollToTop;
-(void)retweetButtonPressed:(id)sender;
-(void)favoriteButtonPressed:(id)sender;
-(void)retweetDelButtonPressed:(id)sender;
-(void)favoriteDelButtonPressed:(id)sender;
-(void)snsRequest:(NSString *)url :(id)sender :(NSMutableDictionary *)params :(NSString *)type :(void (^)(void))callbackBlock;
-(void)mifdRequest:(NSMutableDictionary *)params :(NSUInteger) rowId;
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
    self.tableView.separatorColor = [UIColor yellowColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    UITabBarItem *tabBarItem = [self.tabBarController.tabBar.items objectAtIndex:0];
    tabBarItem.image = [UIImage imageNamed:@"twitter_thumb.png"];
    self.tweets = [[NSMutableArray alloc]init];
    self.isExpand = false;
    self.curPage = 1;
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    self.HUD.delegate = self;
    [self.HUD show:YES];
    UIRefreshControl *refresh = [[UIRefreshControl alloc]init];
    refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"Pull to refresh" attributes:nil];
    [refresh addTarget:self action:@selector(pullToRefresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    self.tableView.dataSource = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchTweetsWithInit) name:@"fetchTweets" object:nil];
    [self fetchTweets];
}

-(void)pullToRefresh{
    self.curPage = 1;
    self.tweets = [[NSMutableArray alloc]init];
    [self fetchTweets];
    [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:1.5];
}

-(void)stopRefresh{
    [self.refreshControl endRefreshing];
}

-(void) scrollToTop
{
    if ([self numberOfSectionsInTableView:self.tableView] > 0)
    {
        NSIndexPath* top = [NSIndexPath indexPathForRow:NSNotFound inSection:0];
        [self.tableView scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:YES];
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

-(void)changeLoginView{
    [[[UIAlertView alloc] initWithTitle:@"MIFD" message:@"트위터 로그인이 필요합니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil] show];
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
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
    /*
     UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,30)];
     
     UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, headerView.frame.size.width-120.0, headerView.frame.size.height)];
     
     headerLabel.textAlignment = UITextAlignmentRight;
     headerLabel.backgroundColor = [UIColor clearColor];
     NSInteger tbHeight = 50;
     UIToolbar *tb = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, tbHeight)];
     tb.translucent = YES;
     UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
     UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"완료" style:UIBarButtonItemStyleBordered target:self action:@selector(completeSelect)];
     NSArray *barButton  =   [[NSArray alloc] initWithObjects:flexibleSpace,doneButton,nil];
     [tb setItems:barButton];
     [headerView addSubview:tb];
     barButton = nil;
     [headerView addSubview:headerLabel];
     
     return headerView;
     */
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

-(void) fetchTweetsWithInit{
    self.curPage = 1;
    self.tweets = [[NSMutableArray alloc]init];
    [self fetchTweets];
}

-(void) fetchTweets{
    HttpClient *httpClient = [HttpClient sharedClient];
    [httpClient GET:[NSMutableString stringWithFormat:@"%@?page=%d&user_desc=%@",RANK,self.curPage,[User getUserDesc]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

-(void)retweetButtonPressed:(id)sender{
    UIButton *clicked = (UIButton *) sender;
    if([User isLogged]){
        [self snsRequest:[NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/retweet/%@.json",((Tweet *)[self.tweets objectAtIndex:clicked.tag]).uuid] :sender :nil :@"R" :^(void){
            NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
            [params setObject:[MifdKeychainItemWrapper keychainStringFromMatchingIdentifier:@"desc"] forKey:@"user_desc"];
            [params setObject:((Tweet *)[self.tweets objectAtIndex:clicked.tag]).uuid forKey:@"tweet_uuid"];
            [params setObject:@"R" forKey:@"type"];
            [self mifdRequest:params :clicked.tag];
        }];
    }else{
        [self changeLoginView];
    }
}

-(void)favoriteButtonPressed:(id)sender{
    UIButton *clicked = (UIButton *) sender;
    if([User isLogged]){
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
        [dictionary setObject:((Tweet *)[self.tweets objectAtIndex:clicked.tag]).uuid forKey:@"id"];
        [self snsRequest:@"https://api.twitter.com/1.1/favorites/create.json" :sender :dictionary :@"F" :^(void){
            NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
            [params setObject:[MifdKeychainItemWrapper keychainStringFromMatchingIdentifier:@"desc"] forKey:@"user_desc"];
            [params setObject:((Tweet *)[self.tweets objectAtIndex:clicked.tag]).uuid forKey:@"tweet_uuid"];
            [params setObject:@"F" forKey:@"type"];
            [self mifdRequest:params :clicked.tag];
        }];
    }else{
        [self changeLoginView];
    }
}

-(void)retweetDelButtonPressed:(id)sender{
    if([User isLogged]){
        [[[UIAlertView alloc] initWithTitle:@"MIFD" message:@"이미 retweet 하셨네요!" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil] show];
    }else{
        [self changeLoginView];
    }
}

-(void)favoriteDelButtonPressed:(id)sender{
    if([User isLogged]){
        [[[UIAlertView alloc] initWithTitle:@"MIFD" message:@"이미 favorite 하셨네요!" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:nil, nil] show];
    }else{
        [self changeLoginView];
    }
}

-(void)mifdRequest:(NSMutableDictionary *)params :(NSUInteger)tag{
    HttpClient *httpClient = [HttpClient sharedClient];
    [httpClient POST:[NSMutableString stringWithFormat:@"%@",USER_TWEET] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.HUD hide:YES];
        if([[responseObject objectForKey:@"result"] integerValue] == 1){
            UserTweet *userTweet = [[UserTweet alloc]init];
            userTweet.tweetUuid = [params objectForKey:@"tweet_uuid"];
            userTweet.userDesc = [User getUserDesc];
            if([[params objectForKey:@"type"] isEqualToString:@"F"]){
                userTweet.type = @"F";
            }else if([[params objectForKey:@"type"] isEqualToString:@"R"]){
                userTweet.type = @"R";
            }
            [((Tweet *)[self.tweets objectAtIndex:tag]).userTweets addObject:userTweet];
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.HUD hide:YES];
        NSLog(@"Error: %@", error);
    }];
}


-(void)snsRequest:(NSString *)url :(id)sender :(NSMutableDictionary *)params :(NSString *)type :(void (^)(void))callbackBlock{
    ACAccountStore *accountStore = [[ACAccountStore alloc]init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [self.HUD show:YES];
    if([MifdKeychainItemWrapper keychainStringFromMatchingIdentifier:@"desc"] != nil){
        NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
        if ([accountsArray count] > 0) {
            ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
            NSURL *requestUrl = [NSURL URLWithString:url];
            SLRequest *posts = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:requestUrl parameters:params];
            [posts setAccount:twitterAccount];
            [posts performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                callbackBlock();
            }];
        }
    }else{
        //로그인이 되어있지 않을 때
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tweet";
    UITableViewCell *cell = nil;
    
    if(indexPath.section >= self.tweets.count){
        return [self loadingCell];
    }
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
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
    subCell.tag = 1;
    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandRow:)];
    //[subCell addGestureRecognizer:tap];
    [cell.contentView addSubview:subCell];
    
    TTTAttributedLabel *text = [[TTTAttributedLabel alloc] init];
    text.delegate = self;
    text.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    text.text = (NSString *)[[self getText:tweet] mutableCopy];
    [text setNumberOfLines:0];
    [text setFrame:CGRectMake(60, 0, cell.contentView.bounds.size.width-85, cell.bounds.size.height)];
    //[text setBackgroundColor:[UIColor redColor]];
    [text sizeToFit];
    [[subCell contentView] addSubview:text];
    
    UIImageView * imageView = [[UIImageView alloc] init];
    [imageView setFrame:CGRectMake(0, 0, 50.0, 50.0)];
    [[subCell contentView] addSubview:imageView];
    [HttpClient downloadingServerImageFromUrl:imageView AndUrl:tweet.user.image];
    
    
    UIButton *retweetBtn = [[UIButton alloc]initWithFrame:CGRectMake(55.0, text.frame.size.height+((cell.bounds.size.height-text.frame.size.height)/6.0), 30.0, 30.0)];
    [retweetBtn setReversesTitleShadowWhenHighlighted:YES];
    [retweetBtn setShowsTouchWhenHighlighted:YES];
    retweetBtn.tag = indexPath.section;
    [retweetBtn setBackgroundImage:[UIImage imageNamed:@"twitter_retweet"] forState:UIControlStateNormal];
    if(![self isAlreadyRetweet:tweet]){
        [retweetBtn addTarget:self action:@selector(retweetButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [retweetBtn addTarget:self action:@selector(retweetDelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    [subCell.contentView addSubview:retweetBtn];
    
    UIButton *favoriteBtn = [[UIButton alloc]initWithFrame:CGRectMake(110.0, text.frame.size.height+((cell.bounds.size.height-text.frame.size.height)/6.0), 30.0, 30.0)];
    [favoriteBtn setReversesTitleShadowWhenHighlighted:YES];
    [favoriteBtn setShowsTouchWhenHighlighted:YES];
    favoriteBtn.tag = indexPath.section;
    [favoriteBtn setBackgroundImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
    if(![self isAlreadyFavorite:tweet]){
        [favoriteBtn addTarget:self action:@selector(favoriteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [favoriteBtn addTarget:self action:@selector(favoriteDelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    [subCell.contentView addSubview:favoriteBtn];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setSelected:NO animated:NO];
    cell.userInteractionEnabled = YES;
    return cell;
}

-(Boolean)isAlreadyRetweet:(Tweet *)tweet{
    if(tweet.userTweets == nil){
        return false;
    }
    for(NSUInteger i=0;i<tweet.userTweets.count;i++){
        UserTweet *userTweet = [tweet.userTweets objectAtIndex:i];
        if([userTweet.type isEqualToString:@"R"]){
            return true;
        }
    }
    return false;
}

-(Boolean)isAlreadyFavorite:(Tweet *)tweet{
    if(tweet.userTweets == nil){
        return false;
    }
    for(NSUInteger i=0;i<tweet.userTweets.count;i++){
        UserTweet *userTweet = [tweet.userTweets objectAtIndex:i];
        if([userTweet.type isEqualToString:@"F"]){
            return true;
        }
    }
    return false;
}

-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url{
    [self.HUD hide:YES];
    UIViewController *webViewController = [[UIViewController alloc]init];
    UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 65, 320, self.view.frame.size.height)];
    webview.delegate = self;
    webview.scalesPageToFit = YES;
    webview.autoresizesSubviews = YES;
    webview.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    [webview setBackgroundColor:[UIColor clearColor]];
    webview.tag = 9999;
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webview loadRequest:request];
    
    NSInteger tbHeight = 65;
    UIToolbar *tb = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, tbHeight)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"닫기" style:UIBarButtonItemStyleBordered target:self action:@selector(closeWebView)];
    NSArray *barButton  =   [[NSArray alloc] initWithObjects:flexibleSpace,doneButton,nil];
    [tb setItems:barButton];
    tb.tag = 9998;
    [webview addSubview:self.HUD];
    [webViewController.view addSubview:webview];
    [webViewController.view addSubview:tb];
    [self presentViewController:webViewController animated:YES completion:nil];
}

-(void)closeWebView{
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == self.curPage*10) return 50.0;
    Tweet *tweet = [self.tweets objectAtIndex:indexPath.section];
    //NSString *text = (NSString *)[[self getText:tweet] mutableCopy];
    //CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), CGFLOAT_MAX);
    //CGRect boundingRect = [text boundingRectWithSize:constraint options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine) attributes:nil context:nil];
    //CGSize size = boundingRect.size;
    //return size.height + (CELL_CONTENT_MARGIN * 2) + CELL_EXTRA_AREA;
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), CGFLOAT_MAX);
    NSAttributedString *text = [self getText:tweet];
    CGRect boundingRect = [text boundingRectWithSize:constraint options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    CGSize size = boundingRect.size;
    return size.height + (CELL_CONTENT_MARGIN * 2) + CELL_EXTRA_AREA;
}

-(NSMutableAttributedString *)getText:(Tweet *)tweet{
    NSString *needToChangeStr = tweet.user.name;
    NSString *displayString = [NSString stringWithFormat:@"%@\n@%@\n\n%@", tweet.user.name,tweet.user.screenName,tweet.text];
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc]initWithString:displayString];
    NSUInteger begin = 0;
    NSUInteger end = [needToChangeStr length];
    [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FONT_SIZE] range:NSMakeRange(0, displayString.length)];
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

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.HUD hide:YES];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.HUD show:YES];
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
