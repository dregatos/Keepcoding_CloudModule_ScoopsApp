//
//  DRGScoopsVC.m
//  ScoopsApp
//
//  Created by David Regatos on 28/04/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGScoopsVC.h"
#import "DRGScoopDetailVC.h"
#import "DRGAzureManager.h"
#import "DRGScoop.h"
#import "DRGPublishedCell.h"
#import "UIImageView+AsyncDownload.h"
#import "UIViewController+Alert.h"

@interface DRGScoopsVC ()

@end

@implementation DRGScoopsVC

- (NSMutableArray *)model  {
    if  (!_model) _model = [[NSMutableArray alloc] init];
    return _model;
}

#pragma mark - Init

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {

    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //after nib-loading
}

#pragma mark - view events

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // hidden rows if self.model.count = 0
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self setupRefreshController];
    [self setupNavBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self fetchScoops];
}

#pragma mark - Appearance 

- (void)setupNavBar {
    
    self.title = @"Scoops";

    UIBarButtonItem *logoutBtn = [[UIBarButtonItem alloc] initWithTitle:@"Log out"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(logOut:)];
    self.navigationItem.leftBarButtonItem = logoutBtn;
    
    UIBarButtonItem *editorBtn = [[UIBarButtonItem alloc] initWithTitle:@"Editor"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(showEditorMode:)];
    self.navigationItem.rightBarButtonItem = editorBtn;
}

- (void)displayMessageOnTableview:(UITableView *)tableView {
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:tableView.bounds];
    
    messageLabel.text = @"No data is currently available.\nPlease pull down to refresh.";
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
    [messageLabel sizeToFit];
    
    tableView.backgroundView = messageLabel;
}

#pragma mark - IBActions

- (IBAction)logOut:(UIButton *)sender {
    [[DRGAzureManager sharedInstance].client logout];
    [[DRGAzureManager sharedInstance] resetAuthInfo];
    [self presentLoginStoryboard];
}

- (IBAction)showEditorMode:(UIButton *)sender {
    [self presentEditorStoryboard];
}

# pragma mark - TableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if ([self.model count]) {
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.backgroundView = nil;
        return 1;
        
    } else {
        
        // Display a message when the table is empty
        [self displayMessageOnTableview:tableView];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.model count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get data
    DRGScoop *scoop = [self getScoopForIndexPath:indexPath];
    
    // Custom Cell
    DRGPublishedCell *cell = [tableView dequeueReusableCellWithIdentifier:[DRGPublishedCell cellId]];
    if(cell == nil) {
        cell = [[DRGPublishedCell alloc] init];
    }
    
    // Configure the cell...
    [cell configure:scoop];
    
    return cell;
}

# pragma mark - TableView delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Get data
    DRGScoop *scoop = [self getScoopForIndexPath:indexPath];
    
    [self performSegueWithIdentifier:@"showScoopDetailVC" sender:scoop];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [DRGPublishedCell height];
}

#pragma mark - Helpers

- (void)fetchScoops {
    
    [self.refreshControl beginRefreshing];

    [[DRGAzureManager sharedInstance] fetchAvailableScoopsWithCompletion:^(NSArray *result, NSError *error) {
        self.model = [result mutableCopy];
        [self reloadData];
    }];
    
    /*
    MSTable *table = [[DRGAzureManager sharedInstance].client tableWithName:AZURE_TABLE_SCOOPS_KEY];
    
    MSQuery *queryModel = [[MSQuery alloc]initWithTable:table];
    [queryModel readWithCompletion:^(MSQueryResult *result, NSError *error) {
        
        self.model = nil; // reset model
        
        for (id item in result.items) {
            NSLog(@"item -> %@", item);
            DRGScoop *scoop = [DRGScoop scoopFromDictionary:item];
            [self.model addObject:scoop];
        }
        [self reloadData];
    }];
     */
}

- (DRGScoop *)getScoopForIndexPath:(NSIndexPath *)indexPath {
    return [self.model objectAtIndex:indexPath.row];
}

#pragma mark - UIRefreshController

- (void) setupRefreshController {
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(fetchScoops)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)reloadData {
    // Reload table data
    [self.tableView reloadData];
    
    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showScoopDetailVC"]) {
        DRGScoopDetailVC *nextVC = (DRGScoopDetailVC *)[segue destinationViewController];
        nextVC.scoop = (DRGScoop *)sender;
    }
}

- (void)presentLoginStoryboard {
    // Log in success
    UIViewController *nextVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
    nextVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nextVC animated:YES completion:nil];
}

- (void)presentEditorStoryboard {
    // Log in success
    UIViewController *nextVC = [[UIStoryboard storyboardWithName:@"Editor" bundle:nil] instantiateInitialViewController];
    nextVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:nextVC animated:YES completion:nil];
}

@end
