//
//  DTCBookViewController.m
//  HackerBooks_v2
//
//  Created by David de Tena on 24/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "DTCBook.h"
#import "DTCPhoto.h"
#import "DTCBookViewController.h"
#import "DTCLibraryViewController.h"

@interface DTCBookViewController ()

@end

@implementation DTCBookViewController


#pragma mark - Init
- (id) initWithModel:(DTCBook *) model{
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        _model = model;
        self.title = model.title;
    }
    
    return self;
}


#pragma mark - View lifecycle

- (void) viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    // Make sure the view not to use the whole screen when embeded in navs or tabbar
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Init display mode button on the left in Navigation Controller
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    
    [self syncViewWithModel];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Utils
- (void) syncViewWithModel{
    // Set model properties to UI elements
    self.titleLabel.text = self.model.title;
    self.authorsLabel.text = [self.model sortedListOfAuthors];
    self.tagsLabel.text = [self.model sortedListOfTags];
    self.coverImageView.image = self.model.photo.bookImage;
    
    NSUInteger annotationCounter = [self.model.annotations.allObjects count];
    
    if (!self.model.annotations || annotationCounter == 0) {
        self.annotationsLabel.text = @"No annotations yet";
    }
    else if(annotationCounter == 1){
        self.annotationsLabel.text = @"1 annotation for this book";
    }
    else{
        self.annotationsLabel.text = [NSString stringWithFormat:@"%lu annotations for this book",(unsigned long)annotationCounter];
    }
}


#pragma mark - Actions
- (IBAction)didToggleFavoriteStatus:(id)sender {
}



#pragma mark - DTCLibraryTableViewControllerDelegate
-(void) libraryTableViewController:(DTCLibraryViewController *)libraryVC
                     didSelectBook:(DTCBook *)aBook{

    NSLog(@"Soy el delegado de la tabla y he entendido el método");
    // Update model with the new selected book
    self.title = aBook.title;
    self.model = aBook;
    [self syncViewWithModel];
}



#pragma mark - UISplitViewControllerDelegate
-(void) splitViewController:(UISplitViewController *)svc
    willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode{

    if (displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        // Table hidden => show button on the left in navigation
        self.navigationItem.leftBarButtonItem = svc.displayModeButtonItem;
    }
    else{
        // Table visible => hide button in navigation
        self.navigationItem.leftBarButtonItem = nil;
    }
}
@end





