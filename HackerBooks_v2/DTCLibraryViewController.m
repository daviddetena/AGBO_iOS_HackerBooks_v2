//
//  DTCLibraryViewController.m
//  HackerBooks_v2
//
//  Created by David de Tena on 24/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "AGTCoreDataStack.h"
#import "DTCCoreDataQueries.h"
#import "DTCLibraryViewController.h"
#import "DTCBookViewController.h"
#import "DTCBook.h"
#import "DTCHelpers.h"
#import "DTCPhoto.h"
#import "DTCTag.h"
#import "BookSettings.h"
#import "InitSettings.h"

@interface DTCLibraryViewController ()

@property (strong,nonatomic) AGTCoreDataStack *stack;

@end

@implementation DTCLibraryViewController

#pragma mark - Init
// Designated
-(id) initWithFetchedResultsController:(NSFetchedResultsController *)aFetchedResultsController
                                 stack:(AGTCoreDataStack *) stack
                                 style:(UITableViewStyle)aStyle{

    if (self = [super initWithFetchedResultsController:aFetchedResultsController style:aStyle]) {
        _stack = stack;
    }
    return self;
}


#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"HackerBooks2";
    
    [self setupNotifications];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self tearDownNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Notifications
// Suscribe to changes in model
-(void) setupNotifications{
    
    // Suscribe to changes in pdf data of books, and tags
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(notifyThatBookPdfDidChange:)
               name:DTCBOOK_DID_CHANGE_PDF_NOTIFICATION
             object:nil];
}


// Unsuscribe from changes in model
- (void) tearDownNotifications{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}


// Save in CoreData when changes in book
-(void) notifyThatBookPdfDidChange:(NSNotification *) notification{
    
    NSLog(@"La tabla se entera de que el PDF del libro ha cambiado");
    [self saveToCoreData];
}


// Reload the table when tags change and save data
-(void) notifyThatTagsDidChange:(NSNotification *) notification{
    [self.tableView reloadData];
    [self saveToCoreData];
}



#pragma mark - TableView DataSource
-(UITableViewCell *) tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Check out if there is any reusable cell
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        // No cell to be reused. Create a new one
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    // Get the book at index path
    
    // Sync UI with the book
    DTCBook *book = [self bookAtIndexPath:indexPath];
    cell.textLabel.text = book.title;
    cell.detailTextLabel.text = [book sortedListOfAuthors];
    cell.imageView.image = book.photo.bookImage;
    
    return cell;
}



#pragma mark - TableView delegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    // Present bookVC with the book selected by pushing
    DTCBook *currentBook = [self bookAtIndexPath:indexPath];   
    
    // Tell the delegate the user did select a book
    if ([self.delegate respondsToSelector:@selector(libraryTableViewController:didSelectBook:)]) {
        [self.delegate libraryTableViewController:self didSelectBook:currentBook];
    }
    
    // Send notification to let know a new cell has tapped
    NSNotification *notification = [NSNotification notificationWithName:DTCLIBRARY_DID_SELECT_BOOK_NOTIFICATION
                                                                 object:self
                                                               userInfo:@{DTCLIBRARY_BOOK_SELECTED_KEY:currentBook}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    NSLog(@"Libro seleccionado ha cambiado");
    
    // Guardamos en NSUserDefaults el id de este libro como el último seleccionado
    [self saveLastSelectedBook:currentBook];
}



#pragma mark - Utils
- (DTCBook *) bookAtIndexPath:(NSIndexPath *) indexPath{
    
    DTCTag *tag = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.section];
    DTCBook *book = [[tag.books allObjects] objectAtIndex:indexPath.row];
    
    return book;
}


#pragma mark - NSUserDefaults
-(void) saveLastSelectedBook:(DTCBook *) book{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:book.archiveURIRepresentation forKey:LAST_SELECTED_BOOK];
    [defaults synchronize];
}

#pragma mark - CoreData
-(void) saveToCoreData{
    // Save model when a change in books happens
    [self.stack saveWithErrorBlock:^(NSError *error) {
        if (error) {
            NSLog(@"Error al guardar: %@",error.description);
        }
        else{
            NSLog(@"Guardado en CoreData");
        }
    }];
}


@end
