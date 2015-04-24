//
//  AppDelegate.m
//  HackerBooks_v2
//
//  Created by David de Tena on 24/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "AppDelegate.h"
#import "AGTCoreDataStack.h"
#import "AGTCoreDataStack.h"
#import "DTCBook.h"
#import "DTCBookViewController.h"
#import "DTCAnnotation.h"
#import "DTCTag.h"
#import "BookSettings.h"
#import "InitSettings.h"
#import "DTCHelpers.h"
#import "DTCSandboxURL.h"
#import "DTCCoreDataQueries.h"
#import "DTCLibraryViewController.h"
#import "UIViewController+Navigation.h"
@import CoreData;


@interface AppDelegate ()

@property (strong, nonatomic) AGTCoreDataStack *stack;

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSLog(@"Estoy en RUTA: %@",[DTCSandboxURL URLToDocumentsFolder]);
    
    // Init CoreData stack with the model name
    self.stack = [AGTCoreDataStack coreDataStackWithModelName:@"Model"];
    
    // Comprobamos si hay último libro seleccionado
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:LAST_SELECTED_BOOK]) {
        
        // Cargar de JSON
        [self loadModelFromJSON];
    }
    
    // Data for first View => Fetch of all tags, each of them with their books
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[DTCTag entityName]];
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:DTCTagAttributes.name ascending:YES selector:@selector(caseInsensitiveCompare:)]];
    NSFetchedResultsController *results = [[NSFetchedResultsController alloc] initWithFetchRequest:req
                                                                              managedObjectContext:self.stack.context
                                                                                sectionNameKeyPath:DTCTagAttributes.name
                                                                                         cacheName:nil];
    
    // Controlador de tabla de libros con NSFetchedResultsController
    DTCLibraryViewController *libraryVC = [[DTCLibraryViewController alloc] initWithFetchedResultsController:results
                                                                                                       stack:self.stack
                                                                                                       style:UITableViewStyleGrouped];
    
    //DTCBook *lastSelectedBook = nil;
    if (!IS_IPHONE) {
        [self configureForPad:libraryVC];
    }
    else{
        [self configureForPhone:libraryVC];
    }

    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - App setup


-(void) configureForPad:(DTCLibraryViewController *) libraryVC{
    
    // Comprobamos si hay último libro seleccionado
    DTCBook *lastBook = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:LAST_SELECTED_BOOK]) {
        
        // Seleccionar primer libro que se verá (para iPad)
        // Realizo consulta para devolver el primer libro de la primera etiqueta
        DTCTag *firstTag = [libraryVC.fetchedResultsController.fetchedObjects objectAtIndex:0];
        lastBook = [firstTag.books.allObjects objectAtIndex:0];
        
        // Guardar primer libro como el seleccionado
        [self saveLastSelectedBook:lastBook];
    }
    else{
        lastBook = [self lastSelectedBook];
    }
    
    // Controlador primer libro
    DTCBookViewController *bookVC = [[DTCBookViewController alloc] initWithModel:lastBook];
    
    // Será el delegado de la tabla
    libraryVC.delegate = bookVC;
    
    // SplitView para combinar controlador de tabla y de libro
    UISplitViewController *splitVC = [[UISplitViewController alloc]init];
    splitVC.viewControllers = @[[libraryVC wrappedInNavigation],[bookVC wrappedInNavigation]];
    
    // Delegados => el libro será el delegado del split, ya que será el que muestre
    // el contenido de los elementos de la tabla
    splitVC.delegate = bookVC;
    
    // Controlador raíz: nuestra tabla embebida en un navigation controller
    self.window.rootViewController = splitVC;
}


-(void) configureForPhone:(DTCLibraryViewController *) libraryVC{
    // NOT IMPLEMENTED YET
}


-(DTCBook *) lastSelectedBook{
    // Recuperamos la clave del lastSelectedBook de NSUserDefaults, que será la URL al ObjectID
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *lastBookData = [defaults objectForKey:LAST_SELECTED_BOOK];
    
    // Obtenemos instancia del último libro
    DTCBook *book = [DTCBook bookWithArchivedURIRepresentation:lastBookData stack:self.stack];
    
    return book;
}

-(void) saveLastSelectedBook: (DTCBook *) book{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[book archiveURIRepresentation] forKey:LAST_SELECTED_BOOK];
    [defaults synchronize];
}


#pragma mark - JSON
-(void) loadModelFromJSON{
    
    // Get data from a remote resource via JSON
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:JSON_API_URL]];
    
    // Get response from server dealing with errors
    NSURLResponse *response = [[NSURLResponse alloc]init];
    NSError *error;
    NSData *modelData = [NSURLConnection sendSynchronousRequest:request
                                              returningResponse:&response
                                                          error:&error];
    
    if (modelData!=nil) {
        id JSONObjects = [NSJSONSerialization JSONObjectWithData:modelData
                                                         options:kNilOptions
                                                           error:&error];
        
        if (JSONObjects!=nil) {
            if ([JSONObjects isKindOfClass:[NSArray class]]) {
                
                // Guardamos cada libro a partir de su diccionario en el JSON
                for (NSDictionary *dict in JSONObjects) {
                    [DTCBook bookWithDictionary:dict stack:self.stack];
                }
            }
        }
        NSLog(@"JSON successfully downloaded");
        // Save in CoreData
        [self save];
    }
    else{
        // No data or error
        NSLog(@"Error while downloading JSON from server: %@",error.localizedDescription);
    }
    
    [self autoSave];
}


#pragma mark - Utils



#pragma mark - CoreData

-(void) save{
    [self.stack saveWithErrorBlock:^(NSError *error) {
        NSLog(@"Error al guardar: %@",error.description);
    }];
    NSLog(@"Guardado");
}

-(void) autoSave{
    if (AUTO_SAVE) {
        NSLog(@"Autoguardando...");
        [self save];
        
        [self performSelector:@selector(autoSave)
                   withObject:nil
                   afterDelay:AUTO_SAVE_DELAY_IN_SECONDS];
    }
}


@end
