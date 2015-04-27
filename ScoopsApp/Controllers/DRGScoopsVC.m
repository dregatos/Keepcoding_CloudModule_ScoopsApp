//
//  DRGScoopsVC.m
//  ScoopsApp
//
//  Created by David Regatos on 27/04/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGScoopsVC.h"
#import "DRGAzureManager.h"
#import "DRGScoop.h"
#import "DRGReader.h"
#import "DRGScoopCell.h"
#import "UIImageView+AsyncDownload.h"
#import "UIViewController+Alert.h"

@interface DRGScoopsVC ()

@property (nonatomic, strong) DRGReader *reader;

@end

@implementation DRGScoopsVC

- (void)setReader:(DRGReader *)reader {
    _reader = reader;
    
    self.userNameLbl.text = reader.name;
    [self.userImageView asyncDownloadFromURL:reader.pictureURL];
}

- (NSMutableArray *)model  {
    if  (!_model) _model = [[NSMutableArray alloc] init];
    return _model;
}

#pragma mark - Init

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        self.title = @"Scoops";
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
    
    self.tableView.delegate = self;
    
    [self loadDummyData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self fetchCurrentUserInfo];
}

#pragma mark - IBActions

- (IBAction)logOut:(UIButton *)sender {
    [[DRGAzureManager sharedInstance].client logout];
    [[DRGAzureManager sharedInstance] resetAuthInfo];
    [self presentLoginStoryboard];
}

# pragma mark - TableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.model count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get data
    DRGScoop *scoop = (DRGScoop *)[self.model objectAtIndex:indexPath.row];

    // Custom Cell
    DRGScoopCell *cell = [tableView dequeueReusableCellWithIdentifier:[DRGScoopCell cellId]];
    if(cell == nil) {
        cell = [[DRGScoopCell alloc] init];
    }
        
    // Configure the cell...
    [cell configure:scoop];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [DRGScoopCell height];
}

#pragma mark - API

- (void)fetchCurrentUserInfo {
    [[DRGAzureManager sharedInstance].client invokeAPI:@"getCurrentUserInfo"
                                                  body:nil
                                            HTTPMethod:@"GET"
                                            parameters:nil
                                               headers:nil
                                            completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
                                                
                                                if (error) {
                                                    NSLog(@"Error -->> %@", error.localizedDescription);
                                                    [self showAlertWithMessage:error.localizedDescription];
                                                }
                                                
                                                NSLog(@"getCurrentUserInfo ->> %@", result);
                                                self.reader = [DRGReader readerFromFacebook:result];
                                                NSLog(@"Reader -->> %@", self.reader);
                                            }];
}

#pragma mark - Navigation

- (void)presentLoginStoryboard {
    // Log in success
    UIViewController *nextVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
    nextVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nextVC animated:YES completion:nil];
}

#pragma mark - Helpers 

- (void)loadDummyData {
    
    DRGScoop *scoop = [[DRGScoop alloc] initWithHeadline:@"My fucking awesome headline\nWith two lines"
                                                    lead:@"We need a lead"
                                                    body:@"This will be the body of the scoop."
                                                  author:@"David Regatos"
                                                    date:[NSDate date]
                                                andPhoto:[UIImage imageNamed:@"alejandra.jpg"]];
    for (int i=0; i<16; i++) {
        [self.model addObject:scoop];
    }
    
    [self.tableView reloadData];
}


@end
