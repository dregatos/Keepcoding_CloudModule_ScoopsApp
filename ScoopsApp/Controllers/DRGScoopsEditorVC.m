//
//  DRGScoopsVC.m
//  ScoopsApp
//
//  Created by David Regatos on 27/04/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

@import QuartzCore;

#import "DRGScoopsEditorVC.h"
#import "DRGNewScoopVC.h"
#import "DRGAzureManager.h"
#import "DRGScoop.h"
#import "DRGUser.h"
#import "DRGPublishedCell.h"
#import "UIImageView+AsyncDownload.h"
#import "UIViewController+Alert.h"

#define PUBLISHED_SELECTED      0
#define UNPUBLISHED_SELECTED    1

@interface DRGScoopsEditorVC ()

@property (nonatomic, strong) DRGUser *user;

@end

@implementation DRGScoopsEditorVC

- (void)setUser:(DRGUser *)reader {
    _user = reader;
    
    UIImageView *imView = (UIImageView *)self.navigationItem.leftBarButtonItem.customView;
    [imView asyncDownloadFromURL:reader.pictureURL];
}

- (NSMutableArray *)published  {
    if  (!_published) _published = [[NSMutableArray alloc] init];
    return _published;
}

- (NSMutableArray *)unpublished  {
    if  (!_unpublished) _unpublished = [[NSMutableArray alloc] init];
    return _unpublished;
}

#pragma mark - Init

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        self.title = @"Editor";
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //after nib-loading
    [[DRGAzureManager sharedInstance] fetchCurrentUserInfoWithCompletion:^(DRGUser *user, NSError *error) {
        self.user = user;
    }];
}

#pragma mark - view events

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    
    [self setupNavBar];
    [self setupSegmentedController];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self fetchScoops];
}

#pragma mark - Segmented Controller
    
- (void)segmentedChanged:(UISegmentedControl *)sender {
    [self fetchScoops];
}

- (void)setupSegmentedController {
    // set up SegmentedController
    //    self.mySegmentedController.tag = …;
    //    self.mySegmentedController.tintColor = …;
    [self.segmentedControl setTitle:@"Published" forSegmentAtIndex:PUBLISHED_SELECTED];
    [self.segmentedControl setTitle:@"Unpublished" forSegmentAtIndex:UNPUBLISHED_SELECTED];
    
    self.segmentedControl.selectedSegmentIndex = PUBLISHED_SELECTED;
    
    [self.segmentedControl addTarget:self
                              action:@selector(segmentedChanged:)
                    forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Appearance

- (void)setupNavBar {
    
    self.title = @"Editor";
    
    // NOTE: User image assigned on setUser
    UIImageView *imView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    imView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.];
    imView.layer.cornerRadius = imView.bounds.size.height/2;
    imView.layer.masksToBounds = YES;
    
    UIBarButtonItem *userIm = [[UIBarButtonItem alloc] initWithCustomView:imView];
    self.navigationItem.leftBarButtonItem = userIm;
    
    UIBarButtonItem *readerBtn = [[UIBarButtonItem alloc] initWithTitle:@"Scoops"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(showReaderMode:)];
    self.navigationItem.rightBarButtonItem = readerBtn;
}

- (void)displayMessage:(NSString *)message onTableview:(UITableView *)tableView {
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:tableView.bounds];
    
    messageLabel.text = message;
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
    [messageLabel sizeToFit];
    
    tableView.backgroundView = messageLabel;
}

#pragma mark - IBActions

- (IBAction)showReaderMode:(UIButton *)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self presentMainStoryboard];
}

# pragma mark - TableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([[self modelForCurrentSegmentedControl] count]) {
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.backgroundView = nil;
        return 1;
        
    } else {
        
        // Display a message when the table is empty
        NSString *sms;
        if (self.segmentedControl.selectedSegmentIndex == PUBLISHED_SELECTED) {
            sms = @"Use the 'Add' button to create\n and publish your first scoop.";
        } else {
            sms = @"There are no scoops\npending to be published.";
        }
        [self displayMessage:sms onTableview:tableView];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self modelForCurrentSegmentedControl] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get data
    DRGScoop *scoop = (DRGScoop *)[[self modelForCurrentSegmentedControl] objectAtIndex:indexPath.row];

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
    DRGScoop *scoop = (DRGScoop *)[[self modelForCurrentSegmentedControl] objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"showScoopEditorVC" sender:scoop];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [DRGPublishedCell height];
}

#pragma mark - Navigation

- (void)presentMainStoryboard {
    // Log in success
    UIViewController *nextVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    nextVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nextVC animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showNewScoopVC"]) {
        DRGNewScoopVC *nextVC = (DRGNewScoopVC *)[segue destinationViewController];
        nextVC.scoop = nil;
        nextVC.user = self.user;
    } else if ([segue.identifier isEqualToString:@"showScoopEditorVC"]) {
        DRGNewScoopVC *nextVC = (DRGNewScoopVC *)[segue destinationViewController];
        nextVC.scoop = (DRGScoop *)sender;
        nextVC.user = self.user;
    }
}

#pragma mark - Helpers 

- (void)fetchScoops {
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        [[DRGAzureManager sharedInstance] fetchCurrentUserUnpublishedWithCompletion:^(NSArray *result, NSError *error) {
            self.unpublished = [result mutableCopy];
            [self.tableView reloadData];
        }];
    } else {
        [[DRGAzureManager sharedInstance] fetchCurrentUserPublishedWithCompletion:^(NSArray *result, NSError *error) {
            self.published = [result mutableCopy];
            [self.tableView reloadData];
        }];
    }
}

- (NSMutableArray *)modelForCurrentSegmentedControl {
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        return self.unpublished;
    }
    
    return self.published;
}

@end
