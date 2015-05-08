//
//  DRGScoopsVC.h
//  ScoopsApp
//
//  Created by David Regatos on 27/04/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

@import UIKit;

@interface DRGScoopsEditorVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *published;    // of DRGScoop objects which published == YES
@property (nonatomic, strong) NSMutableArray *unpublished;  // of DRGScoop objects which published == NO

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end
