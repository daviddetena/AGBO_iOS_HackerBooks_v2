//
//  DTCAnnotationsViewController.m
//  HackerBooks_v2
//
//  Created by David de Tena on 26/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "DTCAnnotationsViewController.h"
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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add button
    [self addNewAnnotationButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Añadimos botón de nueva nota
-(void) addNewAnnotationButton{
    // Botón añadir del sistema en la derecha de la barra de navegación
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                  target:self
                                  action:@selector(addNewAnnotation:)];
    self.navigationItem.rightBarButtonItem = addButton;
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
    
    
    return cell;
}


#pragma mark - Table Delegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

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
