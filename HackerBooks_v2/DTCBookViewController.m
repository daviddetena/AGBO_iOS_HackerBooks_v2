//
//  DTCBookViewController.m
//  HackerBooks_v2
//
//  Created by David de Tena on 24/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "DTCBook.h"
#import "DTCPhoto.h"
#import "DTCAnnotation.h"
#import "DTCBookViewController.h"
#import "DTCLibraryViewController.h"
#import "DTCSimplePDFViewController.h"
#import "DTCAnnotationsViewController.h"
#import "DTCCoreDataQueries.h"
#import "AGTCoreDataStack.h"


@interface DTCBookViewController ()

@property (strong,nonatomic) AGTCoreDataStack *stack;

@end

@implementation DTCBookViewController


#pragma mark - Init
- (id) initWithModel:(DTCBook *) model
               stack:(AGTCoreDataStack *)stack{
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        _stack = stack;
        _model = model;
        self.title = model.title;
    }
    
    return self;
}


#pragma mark - View lifecycle

- (void) viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    // Observe notifications of the book model
    [self setupNotifications];
    
    
    // Setup UI
    [self setupUI];
    
    // Make sure the view not to use the whole screen when embeded in navs or tabbar
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Init display mode button on the left in Navigation Controller
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    
    [self syncViewWithModel];
    

}

-(void) viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self tearDownNotifications];
}


#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) setupUI{
    UIBarButtonItem *annotationButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks
                                                                                   target:self
                                                                                   action:@selector(presentBookAnnotations:)];
    self.navigationItem.rightBarButtonItem = annotationButton;
}


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
    
    /*
    // Portrait
    self.titleLabelPortrait.text = self.model.title;
    self.authorsLabelPortrait.text = [self.model sortedListOfAuthors];
    self.tagsLabelPortrait.text = [self.model sortedListOfTags];
    self.coverImageViewPortrait.image = self.model.photo.bookImage;

    if (!self.model.annotations || annotationCounter == 0) {
        self.annotationsLabelPortrait.text = @"No annotations yet";
    }
    else if(annotationCounter == 1){
        self.annotationsLabelPortrait.text = @"1 annotation for this book";
    }
    else{
        self.annotationsLabelPortrait.text = [NSString stringWithFormat:@"%lu annotations for this book",(unsigned long)annotationCounter];
    } 
     */
}



#pragma mark - Actions

// Create a new instance of AnnotationsVC and presents it by pushing in NavigationController
-(void) presentBookAnnotations:(id) sender{
    
    // Create a request for the annotations of the book
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[DTCAnnotation entityName]];    
    request.predicate = [NSPredicate predicateWithFormat:@"book = %@", self.model];
    // We want the annotations order by name ASC, modificationDate DESC
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:DTCAnnotationAttributes.name ascending:YES selector:@selector(caseInsensitiveCompare:)],
                                 [NSSortDescriptor sortDescriptorWithKey:DTCAnnotationAttributes.modificationDate ascending:NO]];
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                          managedObjectContext:_stack.context
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:nil];
    
    // AnnotationsVC with annotations for current book
    DTCAnnotationsViewController *annotationsVC = [[DTCAnnotationsViewController alloc]
                                                   initWithFetchedResultsController:frc
                                                   book:self.model
                                                   stack:_stack
                                                   style:UITableViewStylePlain];
    
    // Present view controller
    [self.navigationController pushViewController:annotationsVC animated:YES];
    
}


-(void) presentNewNoteVC{

}




#pragma mark - Notifications
// Suscribe to changes in model
-(void) setupNotifications{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(syncViewWithModel)
               name:DTCBOOK_DID_CHANGE_NOTIFICATION
             object:nil];
}


// Unsuscribe from changes in model
- (void) tearDownNotifications{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}


#pragma mark - Actions
- (IBAction)didToggleFavoriteStatus:(id)sender {
}

- (IBAction)readBook:(id)sender {
    // Load PDFViewController
    DTCSimplePDFViewController *pdfVC = [[DTCSimplePDFViewController alloc] initWithModel:self.model];
    [self.navigationController pushViewController:pdfVC animated:YES];    
}



#pragma mark - DTCLibraryTableViewControllerDelegate
-(void) libraryTableViewController:(DTCLibraryViewController *)libraryVC
                     didSelectBook:(DTCBook *)aBook{

    NSLog(@"DTCBookVC => Soy el delegado de la tabla y he entendido el método de toco una celda");
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





