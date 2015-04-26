//
//  DTCAnnotationsViewController.m
//  HackerBooks_v2
//
//  Created by David de Tena on 26/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "DTCAnnotationsViewController.h"
#import "DTCAnnotationViewController.h"
#import "DTCAnnotation.h"
#import "DTCNewAnnotationViewController.h"
#import "DTCPhoto.h"
#import "DTCBook.h"
#import "AGTCoreDataStack.h"

@interface DTCAnnotationsViewController ()

@property (strong,nonatomic) DTCBook *book;
@property (strong,nonatomic) AGTCoreDataStack *stack;

@end

@implementation DTCAnnotationsViewController



#pragma mark - Init
// Designated
-(id) initWithFetchedResultsController:(NSFetchedResultsController *)aFetchedResultsController
                                  book:(DTCBook *) book
                                 stack:(AGTCoreDataStack *) stack
                                 style:(UITableViewStyle)aStyle{

    if (self = [super initWithFetchedResultsController:aFetchedResultsController style:UITableViewStylePlain]) {
        _stack = stack;
        _book = book;
        self.title = [NSString stringWithFormat:@"Annotations for %@",book.title];
    }
    return self;
}


#pragma mark - View lifecycle

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Observe notifications of the book model
    [self setupNotifications];
    
    // Add button
    [self addNewAnnotationButton];
}


//-(void) viewWillDisappear:(BOOL)animated{
//    
//    [super viewWillDisappear:animated];
//    [self tearDownNotifications];
//}

-(void) dealloc{
    [self tearDownNotifications];
}


#pragma mark - Memory
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI
// Añadimos botón de nueva nota
-(void) addNewAnnotationButton{
    // Botón añadir del sistema en la derecha de la barra de navegación
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                  target:self
                                  action:@selector(addNewAnnotation:)];
    self.navigationItem.rightBarButtonItem = addButton;
}



#pragma mark - Notifications
// Suscribe to changes in model
-(void) setupNotifications{

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(notifyThatSelectedBookDidChange:)
               name:DTCLIBRARY_DID_SELECT_BOOK_NOTIFICATION
             object:nil];
}


// Unsuscribe from changes in model
- (void) tearDownNotifications{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}


// Update model when a new book is selected in the table
- (void) notifyThatSelectedBookDidChange:(NSNotification *) notification{
    
    // Take the book included in the notification
    self.book = [notification.userInfo objectForKey:DTCLIBRARY_BOOK_SELECTED_KEY];
    
    // Perform new request with the annotations of the received book
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[DTCAnnotation entityName]];
    request.predicate = [NSPredicate predicateWithFormat:@"book = %@", self.book];
    // We want the annotations order by name ASC, modificationDate DESC
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:DTCAnnotationAttributes.name ascending:YES selector:@selector(caseInsensitiveCompare:)],
                                [NSSortDescriptor sortDescriptorWithKey:DTCAnnotationAttributes.modificationDate ascending:NO]];
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:_stack.context sectionNameKeyPath:nil cacheName:nil];
    
    // Set fetchedResultsController with new data from the request
    [self setFetchedResultsController:frc];
    [self syncViewWithModel];
}


// Update the model by reloading table data
- (void) syncViewWithModel{
    self.title = [NSString stringWithFormat:@"Annotations for %@",self.book.title];
    [self.tableView reloadData];
}


#pragma mark - Table DataSource

// Content to be displayed in every cell
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    DTCAnnotation *annotation = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // The cell will display the name of the annotation and its modification date
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        // No cell to be reused. Create a new one
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    // Format for the modification date
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateStyle = NSDateFormatterFullStyle;
    
    cell.textLabel.text = annotation.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Last modified: %@",[fmt stringFromDate:annotation.modificationDate]];
    

//    cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width/2;
//    cell.imageView.clipsToBounds = YES;
    
    if (!annotation.photo.photoData) {
        cell.imageView.image = [UIImage imageNamed:@"noimageThumb"];
    }
    else{
        cell.imageView.image = annotation.photo.annotationImage;
    }
    
    return cell;
}


#pragma mark - Table Delegate
// Present annotation detail view in navigation controller
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Current annotation
    DTCAnnotation *annotation = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    DTCAnnotationViewController *annotationVC = [[DTCAnnotationViewController alloc]initWithModel:annotation stack:_stack];
    [self.navigationController pushViewController:annotationVC animated:YES];
}


#pragma mark - Actions

// Añadimos nueva libreta en una nueva celda de la tabla
-(void) addNewAnnotation:(id) sender{
    
    // Present newAnnotationVC modally
    DTCNewAnnotationViewController *newAnnotationVC = [[DTCNewAnnotationViewController alloc] initWithModel:self.book
                                                                                                      stack:self.stack];
    
    [self presentViewController:newAnnotationVC animated:YES completion:nil];
}

@end
