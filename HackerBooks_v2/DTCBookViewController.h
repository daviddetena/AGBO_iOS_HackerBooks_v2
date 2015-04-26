//
//  DTCBookViewController.h
//  HackerBooks_v2
//
//  Created by David de Tena on 24/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTCLibraryViewController.h"
@class DTCBook;

@interface DTCBookViewController : UIViewController<DTCLibraryTableViewControllerDelegate, UISplitViewControllerDelegate>

#pragma mark - Properties
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorsLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UILabel *annotationsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

// Model
@property (strong,nonatomic) DTCBook *model;

#pragma mark - Init
-(id) initWithModel:(DTCBook *) model stack:(AGTCoreDataStack *) stack;

#pragma mark - Actions
- (IBAction)didToggleFavoriteStatus:(id)sender;
- (IBAction)readBook:(id)sender;

@end
