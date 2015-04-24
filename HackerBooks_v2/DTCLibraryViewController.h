//
//  DTCLibraryViewController.h
//  HackerBooks_v2
//
//  Created by David de Tena on 24/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "AGTCoreDataTableViewController.h"
@class DTCLibraryViewController;
@class AGTCoreDataStack;
@class DTCBook;

#pragma mark - Protocol definition
// Custom protocol
@protocol DTCLibraryTableViewControllerDelegate <NSObject>


@optional
// Custom method to let the BookVC know the user has tapped a cell
// so it change the model in BookBC
- (void) libraryTableViewController:(DTCLibraryViewController *) libraryVC
                      didSelectBook:(DTCBook *) aBook;

@end

@interface DTCLibraryViewController : AGTCoreDataTableViewController


#pragma mark - Properties

// TableVC delegate
@property (weak, nonatomic) id<DTCLibraryTableViewControllerDelegate>delegate;


#pragma mark - Init
// Designated
-(id) initWithFetchedResultsController:(NSFetchedResultsController *)aFetchedResultsController
                                 stack:(AGTCoreDataStack *) stack
                                 style:(UITableViewStyle)aStyle;

@end
