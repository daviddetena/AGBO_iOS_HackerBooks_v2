//
//  DTCLibraryViewController.m
//  HackerBooks_v2
//
//  Created by David de Tena on 24/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    NSLog(@"pulso en una celda");
    
    // Present bookVC with the book selected by pushing
    DTCBook *currentBook = [self bookAtIndexPath:indexPath];   
    
    // Tell the delegate the user did select a book
    if ([self.delegate respondsToSelector:@selector(libraryTableViewController:didSelectBook:)]) {
        [self.delegate libraryTableViewController:self didSelectBook:currentBook];
        NSLog(@"El delegado entiende el método");
    }
    
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


@end
