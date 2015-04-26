//
//  DTCAnnotationsViewController.m
//  HackerBooks_v2
//
//  Created by David de Tena on 26/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "DTCAnnotationsViewController.h"
#import "DTCAnnotation.h"
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


#pragma mark - Actions

// Añadimos nueva libreta en una nueva celda de la tabla
-(void) addNewAnnotation:(id) sender{
    
    // Al crear una nueva nota en el modelo, CoreData manda una notificación de cambio
    // por KVO a FetchedResultsController, que avisa a la tabla y le dice que se refresque
//    [DTCNote noteWithName:@"Nueva nota"
//                 notebook:self.notebook
//                  context:self.notebook.managedObjectContext];
}

@end
