//
//  DTCAnnotationsViewController.h
//  HackerBooks_v2
//
//  Created by David de Tena on 26/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "AGTCoreDataTableViewController.h"
@class AGTCoreDataStack;
@class DTCBook;

@interface DTCAnnotationsViewController : AGTCoreDataTableViewController

#pragma mark - Properties


#pragma mark - Init
// Designated
-(id) initWithFetchedResultsController:(NSFetchedResultsController *)aFetchedResultsController
                                  book:(DTCBook *) book
                                 stack:(AGTCoreDataStack *) stack
                                 style:(UITableViewStyle)aStyle;


#pragma mark - Instance methods

@end
