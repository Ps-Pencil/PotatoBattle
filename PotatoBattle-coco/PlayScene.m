//
//  PlayScene.m
//  PotatoBattle-coco
//
//  Created by pspencil on 6/9/13.
//  Copyright 2013 pspencil. All rights reserved.
//

#import "PlayScene.h"
#import "HelloWorldLayer.h"
#import "CombatScene.h"

@implementation PlayScene
+ (CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PlayScene *layer = [PlayScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
	// return the scene
	return scene;
}

- (id) init{
    if((self = [super initWithColor:ccc4(255, 255, 255, 255)])){
        CGSize size = [[CCDirector sharedDirector] winSize];
        scale = 0.5;
        if (size.width > 300) {
            scale = 1.0f;
        }
        float margin;
        CCSprite* map = [CCSprite spriteWithFile:@"map.png"];
        map.position = ccp(size.width / 2.0f , size.height / 2.0f);
        CCLOG(@"%f %f",size.width,map.boundingBox.size.width);
        map.scale = scale;
        margin = size.width - map.boundingBox.size.width;
        margin /= 2.0f;
        [self addChild:map z:0 tag:0];
        [CCMenuItemFont setFontName:@"Lato-Light"];
        [CCMenuItemFont setFontSize:19 ];
        CCSprite* topBar = [CCSprite spriteWithFile:@"button.png"];
        
       // CCSprite* separation = [CCSprite spriteWithFile:@"button.png"];
        topBar.scaleX = size.width / topBar.boundingBox.size.width;
        topBar.scaleY = ((map.position.y - map.boundingBox.size.height/2.0f - margin)) / topBar.boundingBox.size.height;
        topBar.position = ccp(topBar.boundingBox.size.width / 2.0f, - map.boundingBox.size.height / 2.0f + map.position.y - margin - topBar.boundingBox.size.height/2.0f);
        topBar.color = ccc3(255, 255,255);
        [self addChild:topBar z:2];
        
        CCSprite* topBar2 = [CCSprite spriteWithFile:@"button.png"];
        topBar2.scaleX = size.width / topBar2.boundingBox.size.width;
        topBar2.scaleY =topBar2.scaleY = (size.height - (map.position.y + map.boundingBox.size.height/2.0f + margin) - 20) / topBar2.boundingBox.size.height;
        topBar2.color = ccc3(255, 255,255);
        topBar2.position = ccp(topBar2.boundingBox.size.width/2.0f, map.boundingBox.size.height / 2.0f + map.position.y + margin + topBar2.boundingBox.size.height / 2.0f + 10);
        [self addChild:topBar2 z:2];
        
        //state = [CCSprite spriteWithFile:@"tick.png"];
        
        /*
        separation.scaleX = 1.0 / separation.boundingBox.size.width;
        separation.scaleY = topBar.boundingBox.size.height / separation.boundingBox.size.height;
        separation.position = topBar.position;
        separation.color = ccc3(185, 195, 199);

        [self addChild:separation z:2];
        
        
        CCSprite* statusBar = [CCSprite spriteWithFile:@"button.png"];
        statusBar.scaleX = size.width / statusBar.boundingBox.size.width;
        statusBar.scaleY = 20.0 / statusBar.boundingBox.size.height;
        statusBar.position = ccp(size.width/2.0f, size.height - statusBar.boundingBox.size.height/2.0f);
        statusBar.color = ccc3(149, 165, 166);
        [self addChild:statusBar z:2];
        
        CCSprite* borderTop = [CCSprite spriteWithFile:@"button.png"];
        borderTop.scaleX = (size.width -1.0) /borderTop.boundingBox.size.width;
        borderTop.scaleY = 1.0 / borderTop.boundingBox.size.height;
        borderTop.position = ccp(topBar.position.x, topBar.position.y + topBar.boundingBox.size.height / 2.0f);
        borderTop.color = separation.color;
        [self addChild:borderTop z:2];
        
        
        CCSprite* borderBtm = [CCSprite spriteWithFile:@"button.png"];
        borderBtm.scaleX = (size.width -1.0) /borderBtm.boundingBox.size.width;
        borderBtm.scaleY = 1.0 / borderBtm.boundingBox.size.height;
        borderBtm.position = ccp(topBar.position.x, topBar.position.y - topBar.boundingBox.size.height / 2.0f);
        borderBtm.color = borderTop.color;
        [self addChild:borderBtm z:2];
        */

        
        
        CCSprite* back = [CCSprite spriteWithFile:@"back.png"];
        //back.color = ccc3(44, 62, 80);
        CCSprite* backSelected = [CCSprite spriteWithFile:@"back.png"];
        backSelected.color = ccc3(192,57 , 43);
        
        CCSprite* proceed = [CCSprite spriteWithFile:@"proceed.png"];
       // proceed.color = ccc3(44, 62, 80);
        CCSprite* proceedSelected = [CCSprite spriteWithFile:@"proceed.png"];
        proceedSelected.color = ccc3(39,174,96);
        
        CCMenuItemSprite* backBtn = [CCMenuItemSprite itemWithNormalSprite:back selectedSprite:backSelected block:^(id sender){
            [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
        }];
        backBtn.anchorPoint = ccp(0.5,0.5);
        backBtn.scale = size.height * 0.08 / backBtn.boundingBox.size.height;
        backBtn.position = ccp(size.width/4.0f, topBar.position.y + 20.0);
        
        CCLabelTTF* backText = [CCLabelTTF labelWithString:@"Back" fontName:@"Lato-Light" fontSize:19];
        backText.position = ccp(backBtn.position.x,backBtn.position.y - backBtn.boundingBox.size.height / 2.0f - 20.0f);
        backText.color = ccc3(145, 165, 166);
        [self addChild:backText z:3];
        
        CCMenuItemSprite* proceedBtn = [CCMenuItemSprite itemWithNormalSprite:proceed selectedSprite:proceedSelected target:self selector:@selector(proceedBtnPressed)];
        proceedBtn.anchorPoint = ccp(0.5,0.5);
        proceedBtn.position = ccp(size.width/4.0f * 3.0f, topBar.position.y + 20.0);
        proceedBtn.scale = backBtn.scale;
        
        CCLabelTTF* proceedText = [CCLabelTTF labelWithString:@"Proceed" fontName:@"Lato-Light" fontSize:19];
        proceedText.position = ccp(proceedBtn.position.x,proceedBtn.position.y - proceedBtn.boundingBox.size.height / 2.0f - 20.0f);
        proceedText.color = ccc3(145, 165, 166);
        [self addChild:proceedText z:3];

        CCMenu* menu = [CCMenu menuWithItems:backBtn,proceedBtn, nil];
        menu.position = ccp(0,0);
        menu.anchorPoint = ccp(0,0);
        [self addChild:menu z:3];
        dragged = FALSE;
        
        map.position = ccp(map.position.x, map.position.y + 20.0);
        for(int i = 1; i <= 5 ; i++)
        {
            CCSprite* potato = [CCSprite spriteWithFile:[NSString stringWithFormat:@"potato%d.png",i]];
            potato.position = ccp(map.position.x - [map boundingBox].size.width / 2.0f + (i-1) * [potato boundingBox].size.width +[potato boundingBox].size.width / 2.0f,map.position.y - [map boundingBox].size.height / 2.0f+[potato boundingBox].size.height/2);
            potato.tag = i;
            [self addChild:potato z:2];
            potato.scale = scale;
            
            CCSprite* potato_shade = [CCSprite spriteWithFile:[NSString stringWithFormat:@"potato%d_shade.png",i]];
            potato_shade.position = ccp(map.position.x - [map boundingBox].size.width / 2.0f + (i-1) * [potato_shade boundingBox].size.width +[potato_shade boundingBox].size.width / 2.0f,map.position.y - [map boundingBox].size.height / 2.0f+[potato_shade boundingBox].size.height/2);
            potato_shade.tag = i+5;
            [self addChild:potato_shade z:1];
            potato_shade.scale = scale;
        }
        
        
        
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    }
    return self;
}
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self selectSpriteForTouch:touchLocation];
    return TRUE;
}
-(void) selectSpriteForTouch:(CGPoint) touchLocation{
    CCSprite* newSprite = nil;
    for(int i = 1; i <= 5; i++){
        CCSprite* temp = (CCSprite *)[self getChildByTag:i];
        if(CGRectContainsPoint(temp.boundingBox, touchLocation))
        {
            newSprite = temp;
            break;
        }
        
    }
    selSprite = newSprite;
}
-(CGPoint) boundPos:(CGPoint)newPos{
    CCSprite* map = (CCSprite *)[self getChildByTag:0];
    CGPoint retval = newPos;
    retval.x = MAX(retval.x, map.position.x - [map boundingBox].size.width / 2.0f + [selSprite boundingBox].size.width / 2.0f);
    retval.x = MIN(retval.x, map.position.x + [map boundingBox].size.width / 2.0f - [selSprite boundingBox].size.width / 2.0f);
    retval.y = MAX(retval.y, map.position.y - [map boundingBox].size.height / 2.0f + [selSprite boundingBox].size.height / 2.0f);
    retval.y = MIN(retval.y, map.position.y + [map boundingBox].size.height / 2.0f - [selSprite boundingBox].size.height / 2.0f);
    return retval;
    
}
-(void) panForTranslation: (CGPoint)translation{
    if(selSprite)
    {
        CGPoint newPos = ccpAdd(selSprite.position, translation);
        selSprite.position = [self boundPos:newPos];
        
        CCSprite* shade = (CCSprite*)[self getChildByTag:5+selSprite.tag];
        float x,y;
        CCSprite *map = (CCSprite *)[self getChildByTag:0];
        for(int i = 0; i <10 ; i++){
            x = map.position.x - map.boundingBox.size.width / 2.0f + shade.boundingBox.size.width / 2.0f + i * map.boundingBox.size.width / 10.0f;
            if(fabs(selSprite.position.x - x) <= map.boundingBox.size.width / 20.0f)
            {
                break;
            }
        }
        for(int i = 0; i < 10 ; i++){
            y = map.position.y - map.boundingBox.size.height / 2.0f + shade.boundingBox.size.height / 2.0f + i * map.boundingBox.size.height / 10.0f;
            if(fabs(selSprite.position.y - y) <= map.boundingBox.size.height / 20.0f)
            {
                break;
            }
        }
        CGPoint pos = ccp(x,y);
        shade.position = pos;
    }
}
-(BOOL) isBox1: (CGRect)rect1 collidingWithBox2: (CGRect )rect2{
    if (CGRectIntersectsRect(rect1, rect2)) {
        return true;
    }
    return false;
}
-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    dragged = TRUE;
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
    [self panForTranslation:translation];
    
    
}
-(CGRect) getRandomRect: (int) size{
    CCSprite* map = (CCSprite*)[self getChildByTag:0];
    int height = 1;
    int width = size;
    if(arc4random()%2==0)
    {
        float t = height;
        height = width;
        width = t;
    }
    int x = arc4random()% (10 - width + 1);
    int y = arc4random()% (10 - height + 1);
    return CGRectMake((float)x * map.boundingBox.size.width / 10.0f + map.boundingBox.origin.x, (float)y * map.boundingBox.size.height /10.0f + map.boundingBox.origin.y, width * map.boundingBox.size.width / 10.0f, height * map.boundingBox.size.width / 10.0f);
}
-(void) proceedBtnPressed{
    bool overlap = false;
    for(int i = 1; i < 5 && !overlap; i++){
        for(int j = i + 1 ; j <= 5 ; j++){
            if([self isBox1:((CCSprite *)[self getChildByTag:i]).boundingBox collidingWithBox2:((CCSprite *)[self getChildByTag:j]).boundingBox])
            {
                overlap = true;
                break;
            }
        }
    }
    if (overlap) {
        //Prompt for de-overlapping
    }
    else{
        
        NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:5];
        for(int i = 1; i <= 5 ; i++ )
        {
            [array addObject:[NSValue valueWithCGRect:((CCSprite*)[self getChildByTag:i]).boundingBox]];
        }
        NSMutableArray* hits = [[NSMutableArray alloc] init];
        NSMutableArray* AIarray = [[NSMutableArray alloc] init];
        int width[5] = {2,3,3,4,5};
        for(int i = 0 ; i<= 5 ; i ++)
        {
        
            CGRect rect = [self getRandomRect:width[i]];
            for(int j = 0 ; j < AIarray.count ; j++)
            {
                if(CGRectIntersectsRect(rect, [AIarray[j] CGRectValue]))
                {
                    rect = [self getRandomRect:width[i]];
                    j = -1;
                }
            }
            [AIarray addObject:[NSValue valueWithCGRect:rect]];
            
        }
        NSMutableArray* otherhits = [[NSMutableArray alloc] init];
        [[CCDirector sharedDirector] replaceScene:[CombatScene sceneWithParameters:AIarray andHits:hits andOtherPositions:array andOtherHits:otherhits]];
    }
}
-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if(selSprite){
        CCSprite* shade = (CCSprite*)[self getChildByTag:5 + selSprite.tag];
        if (!dragged) {
            selSprite.rotation = 90 - selSprite.rotation;
            shade.rotation = selSprite.rotation;
            selSprite.position = [self boundPos:selSprite.position];
            shade.position = [self boundPos:shade.position];
            [self panForTranslation:ccp(0,0)];
            selSprite.position = shade.position;
        }
        else{
            selSprite.position = shade.position;
        }
    }
    dragged = false;
    
    CCLOG(@"%f %f %f %f\n" , selSprite.boundingBox.origin.x, selSprite.boundingBox.origin.y, selSprite.position.x,selSprite.position.y);
    
    // check for collision
    
    
}
@end
