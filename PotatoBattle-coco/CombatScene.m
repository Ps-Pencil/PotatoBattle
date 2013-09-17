//
//  CombatScene.m
//  PotatoBattle-coco
//
//  Created by pspencil on 7/9/13.
//  Copyright 2013 pspencil. All rights reserved.
//

#import "CombatScene.h"
#import "AIScene.h"
#import "PlayScene.h"
@implementation CombatScene

+ (CCScene *) sceneWithParameters: (NSMutableArray *)positions andHits:(NSMutableArray *)hits andOtherPositions: (NSMutableArray* )otherPositions andOtherHits: (NSMutableArray*) otherHits
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CombatScene *layer = [[[CombatScene alloc]initWithData:positions andHits:hits andOtherPositions:otherPositions andOtherHits: otherHits] autorelease];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) initWithData: (NSMutableArray *)positions andHits:(NSMutableArray *)hits andOtherPositions: (NSMutableArray *)otherPositions andOtherHits: (NSMutableArray*) otherHits{
    
    if((self = [super init]))
    {
        
        numOfHits = 0;
        
        prev = hits;
        rects = positions;
        otherpos = otherPositions;
        otherhits = otherHits;
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite* map = [CCSprite spriteWithFile:@"map.png"];
        map.position = ccp(size.width / 2.0f , size.height / 2.0f);
        [self addChild:map z:0 tag:0];
        
        CCSprite* turn = [CCSprite spriteWithFile:@"sun.png"];
        turn.position = ccp(size.width / 2.0f, map.position.y + map.boundingBox.size.height / 2.0f + turn.boundingBox.size.height / 2.0f + 5);
        [self addChild:turn];
        
        cellCover = [CCSprite spriteWithFile:@"touch.png"];
        cellCover.visible = NO;
        [self addChild:cellCover z:1];
        
        
        CCMenuItemFont* backBtn = [CCMenuItemFont itemWithString:@"Back" block:^(id sender){
            [[CCDirector sharedDirector] replaceScene:[PlayScene scene]];
        }];
        CCMenu* back = [CCMenu menuWithItems:backBtn, nil];
        back.position = ccp(size.width / 2.0f, 20);
        [self addChild:back];

        
        //hit position
        for(int i = 0 ; i < [prev count] ; i ++){
            bool success = false;
            for(int j = 0 ; j < 5 ; j ++)
            {
                if(CGRectContainsPoint([rects[j] CGRectValue], [prev[i] CGPointValue]))
                {
                    success = true;
                    break;
                }
            }
            CCSprite* hit;
            if(success){
                numOfHits ++;
                hit = [CCSprite spriteWithFile:@"success.png"];
                hit.position = [prev[i] CGPointValue];
                int x = (int) ((hit.position.x - map.boundingBox.size.width / 20.0f - map.boundingBox.origin.x) / (map.boundingBox.size.width / 10.0f ));
                int y = (int) ((hit.position.y - map.boundingBox.size.width / 20.0f - map.boundingBox.origin.y) / (map.boundingBox.size.width / 10.0f ));
              //  state[x][y] = 2; //successful hit
            }
            else{
                hit = [CCSprite spriteWithFile:@"fired.png"];
                hit.position = [prev[i] CGPointValue];
                int x = (int) ((hit.position.x - map.boundingBox.size.width / 20.0f - map.boundingBox.origin.x) / (map.boundingBox.size.width / 10.0f ));
                int y = (int) ((hit.position.y - map.boundingBox.size.width / 20.0f - map.boundingBox.origin.y) / (map.boundingBox.size.width / 10.0f ));
              //  state[x][y] = 1; //unsuccessful hit
            }
            [self addChild:hit];
        }
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];

    }
    return self;
}
-(CGPoint) boundPos:(CGPoint)newPos{
    CCSprite* map = (CCSprite *)[self getChildByTag:0];
    CGPoint retval = newPos;
    retval.x = MAX(retval.x, map.position.x - [map boundingBox].size.width / 2.0f + [cellCover boundingBox].size.width / 2.0f);
    retval.x = MIN(retval.x, map.position.x + [map boundingBox].size.width / 2.0f - [cellCover boundingBox].size.width / 2.0f);
    retval.y = MAX(retval.y, map.position.y - [map boundingBox].size.height / 2.0f + [cellCover boundingBox].size.height / 2.0f);
    retval.y = MIN(retval.y, map.position.y + [map boundingBox].size.height / 2.0f - [cellCover boundingBox].size.height / 2.0f);
    return retval;
    
}
-(void) panForTranslation: (CGPoint)translation lastTouch: (CGPoint) touchLocation{
        CGPoint newPos = ccpAdd(cellCover.position, translation);
        cellCover.position = newPos;
        
        
        float x,y;
        CCSprite *map = (CCSprite *)[self getChildByTag:0];
        for(int i = 0; i < 10 ; i++){
            x = map.position.x - map.boundingBox.size.width / 2.0f + cellCover.boundingBox.size.width / 2.0f + i * map.boundingBox.size.width / 10.0f;
            if(fabs(touchLocation.x - x) <= map.boundingBox.size.width / 20.0f)
            {
               // CCLOG(@"x: %d\n",i);
                break;
            }
        }
        for(int i = 0; i < 10 ; i++){
            y = map.position.y - map.boundingBox.size.height / 2.0f + cellCover.boundingBox.size.height / 2.0f + i * map.boundingBox.size.height / 10.0f;
            if(fabs(touchLocation.y - y) <= map.boundingBox.size.height / 20.0f)
            {
               // CCLOG(@"y: %d\n",i);
                break;
            }
        }
    CGPoint position = ccp(x,y);
    cellCover.position = [self boundPos:position];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
        
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    if(cellCover.visible == YES && CGRectContainsPoint(cellCover.boundingBox, touchLocation)){
        [self proceedWithHit:cellCover.position];
    }
    else{
    cellCover.visible = YES;
    cellCover.position = touchLocation;
    [self panForTranslation:ccp(0,0) lastTouch:touchLocation];
    }
    return TRUE;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
    [self panForTranslation:translation lastTouch:touchLocation];
    CCLOG(@"%f %f",cellCover.position.x, cellCover.position.y);
    
}


-(void)proceedWithHit: (CGPoint) hit
{
    bool ok = true;
    for (int i = 0 ; i < [prev count]; i++) {
        if (CGPointEqualToPoint([prev[i] CGPointValue] ,hit) ){
            //do something to notify?
            ok = false;
            break;
        }
    }
    if (ok) {
        bool success = false;
        for (int i = 0 ; i < [rects count]; i++) {
            if (CGRectContainsPoint([rects[i] CGRectValue], hit)) {
                success = true;
                break;
            }
        }
        if(!success){
            CCSprite* fire = [CCSprite spriteWithFile:@"fired.png"];
            fire.position = hit;
            [self addChild: fire z:2];
            id fadein = [CCFadeIn actionWithDuration:1.0];
            [fire runAction:fadein];
        }
        else{
            CCSprite* fire = [CCSprite spriteWithFile:@"success.png"];
            fire.position = hit;
            [self addChild: fire z:2];
            id fadein = [CCFadeIn actionWithDuration:1.0];
            [fire runAction:fadein];
            numOfHits++;
            

        }
        
    [prev addObject:[NSValue valueWithCGPoint:hit]];
        
        [[[CCDirector sharedDirector] touchDispatcher] removeAllDelegates];
     //   [self removeAllChildrenWithCleanup:YES];
        if (numOfHits == 17) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeBL transitionWithDuration:2.0 scene:[Result sceneWithWords:@"You Win!"]]];
        }
        else
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.5 scene:[AIScene sceneWithPositions:otherpos andHits:otherhits andOtherPositions: rects andOtherHits: prev]]];
   //         [[CCDirector sharedDirector] replaceScene:[AIScene sceneWithPositions:otherpos andHits:otherhits andOtherPositions: rects andOtherHits: prev]];
    }

}
-(void) dealloc{
    CCLOG(@"DEA");
    [super dealloc];
}
-(void) onExit{
    CCLOG(@"EXIT");
   // [self removeAllChildrenWithCleanup:YES];
    [super onExit];
}
@end
