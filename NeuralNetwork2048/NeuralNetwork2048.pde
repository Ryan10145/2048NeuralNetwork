import java.util.ArrayList;
import java.io.*;

Game game;
Population population;
Network network;
Button play;
Button train;
Button run;
Button help;

GameState gameState = GameState.MENU;
int generationsToTrain;
String output;

int columns = 4;
int rows = 4;
String path;

PImage logo;

void setup()
{
    size(800, 700);
    frameRate(30);

    setupSigmoidValues();

    game = new Game(columns, rows, 6, 80);
    population = new Population(columns, rows);

    play = new Button("Play 2048", width / 2 - 110, height / 2 - 100, 220, 60,
        color(241, 213, 146), color(229, 208, 157));
    train = new Button("Train a Neural Network", width / 2 - 140, height / 2 - 20, 280, 60,
        color(241, 213, 146), color(229, 208, 157));
    run = new Button("Run a Trained Neural Network", width / 2 - 160, height / 2 + 60, 320, 60,
        color(241, 213, 146), color(229, 208, 157));
    help = new Button("Help", width / 2 - 110, height / 2 + 200, 220, 60,
        color(241, 213, 146), color(229, 208, 157));

    generationsToTrain = 0;

    logo = loadImage("data/logo.png");

    path = "network.txt";
}

void draw()
{
    background(227, 221, 221);

    switch(gameState)
    {
        case MENU:
            imageMode(CENTER);
            image(logo, width / 2, height / 7);
            play.show();
            train.show();
            run.show();
            help.show();

            if(play.mouseOver())
            {
                stroke(100);
                strokeWeight(2);    
                line(float(width / 2 - 120), float(height / 2 - 70), float(width / 2 - 150), float(height / 2 - 70));
                line(float(width / 2 + 120), float(height / 2 - 70), float(width / 2 + 150), float(height / 2 - 70));
            }
            if(train.mouseOver())
            {
                stroke(100);
                strokeWeight(2); 
                line(float(width / 2 - 150), float(height / 2 + 10), float(width / 2 - 180), float(height / 2 + 10));
                line(float(width / 2 + 150), float(height / 2 + 10), float(width / 2 + 180), float(height / 2 + 10));
            }
            if(run.mouseOver())
            {
                stroke(100);
                strokeWeight(2);   
                line(float(width / 2 - 170), float(height / 2 + 90), float(width / 2 - 200), float(height / 2 + 90));
                line(float(width / 2 + 170), float(height / 2 + 90), float(width / 2 + 200), float(height / 2 + 90));
            }
            if(help.mouseOver())
            {
                stroke(100);
                strokeWeight(2);
                line(float(width / 2 - 120), float(height / 2 + 230), float(width / 2 - 150), float(height / 2 + 230));
                line(float(width / 2 + 120), float(height / 2 + 230), float(width / 2 + 150), float(height / 2 + 230));
            }
        break;
        case PLAY:
            game.update();
            game.draw(width / 2, height / 2 - 50);
        break;
        case TRAIN:
            if(population.generationCount < generationsToTrain)
            {
                for(int i = 0; i < 5; i++) population.run();
                population.update();
            }
            else
            {
                fill(0);
                text("Training Finished!", width / 2, height * 2 / 3.0 + 120);
            }

            textAlign(CENTER, CENTER);
            textSize(20);
            fill(0);
            text("Best so Far: " + sqrt(population.best.fitness / 5.0), width / 2, height * 2 / 3.0);
            text("Current Generation: " + population.generationCount, width / 2, height * 2 / 3.0 + 30);
            text("Target Generation: " + generationsToTrain, width / 2, height * 2 / 3.0 + 60);
            population.show(width / 2, height / 4);
        break;
        case RUN:
            if(frameCount % 5 == 0)
            {
                float[] responses = network.respond(game.getInput());

                boolean moved = false;
                while(!moved)
                {
                    switch(getMax(responses))
                    {
                        case 0:
                            if(!game.move(Direction.UP)) responses[0] = -100; 
                            else moved = true;
                        break;
                        case 1:
                            if(!game.move(Direction.RIGHT)) responses[1] = -100;
                            else moved = true;
                        break;
                        case 2:
                            if(!game.move(Direction.DOWN)) responses[2] = -100;
                            else moved = true;
                        break;
                        case 3:
                            if(!game.move(Direction.LEFT)) responses[3] = -100;
                            else moved = true;
                        break;
                        default:
                            moved = true;
                            game.update();
                        break;
                    }
                }
                game.update();
            }
            game.draw(width / 2, height / 2 - 50);
            network.show(width / 2, height / 2 + 250);
        break;
        case GENERATIONS:
            fill(0);
            textSize(40);
            textAlign(CENTER, CENTER);
            text("Generations To Train", width / 2, height / 2 - 100);
            text(generationsToTrain, width / 2, height / 2);
        break;
        case INPUT:

        break;
        case HELP:
            fill(0);
            textSize(40);
            textAlign(CENTER, CENTER);
            text("Help", width / 2, 50);
            
            play.show();
            train.show();
            run.show();

            textSize(25);
            text("On any screen, press backspace to go back", width / 2, height / 2 + 180);
            text("Press escape to quit the application", width / 2, height / 2 + 220);

            if(play.mouseOver())
            {
                stroke(100);
                strokeWeight(2);    
                line(float(width / 2 - 120), float(height / 2 - 70), float(width / 2 - 150), float(height / 2 - 70));
                line(float(width / 2 + 120), float(height / 2 - 70), float(width / 2 + 150), float(height / 2 - 70));
                
                textSize(15);
                textAlign(LEFT, CENTER);
                text("Press to Play 2048!", 20, height / 2 - 70);

                textAlign(RIGHT, CENTER);
                text("Use Arrow Keys to Move", width - 20, height / 2 - 80);
                text("Press R to Restart", width - 20, height / 2 - 60);
            }
            if(train.mouseOver())
            {
                stroke(100);
                strokeWeight(2); 
                line(float(width / 2 - 150), float(height / 2 + 10), float(width / 2 - 180), float(height / 2 + 10));
                line(float(width / 2 + 150), float(height / 2 + 10), float(width / 2 + 180), float(height / 2 + 10));
                
                textSize(15);
                textAlign(LEFT, CENTER);
                text("Train a Network!", 20, height / 2 + 10);

                textSize(12);
                textAlign(RIGHT, CENTER);
                text("Enter in number of generations", width - 20, height / 2 - 2);
                text("More Gens = Better Network", width - 20, height / 2 + 10);
                text("Save network as a file", width - 20, height / 2 + 22);
            }
            if(run.mouseOver())
            {
                stroke(100);
                strokeWeight(2);   
                line(float(width / 2 - 170), float(height / 2 + 90), float(width / 2 - 200), float(height / 2 + 90));
                line(float(width / 2 + 170), float(height / 2 + 90), float(width / 2 + 200), float(height / 2 + 90));
                
                textSize(15);
                textAlign(LEFT, CENTER);
                text("Run a Trained Network!", 20, height / 2 + 90);

                textAlign(RIGHT, CENTER);
                text("Run a saved network", width - 20, height / 2 + 80);
                text("Press R to restart", width - 20, height / 2 + 100);
            }
        break;
        default:

        break;
    }
}

void keyPressed()
{
    if(gameState != GameState.GENERATIONS && keyCode == BACKSPACE)
    {
        if(gameState == GameState.TRAIN)
        {
            selectOutput("Select a file to write to", "outSelected", new File(path));
        }
        gameState = GameState.MENU;
    }

    switch(gameState)
    {
        case MENU:

        break;
        case PLAY:
            if(keyCode == UP)
            {
                game.move(Direction.UP);
            }
            else if(keyCode == RIGHT)
            {
                game.move(Direction.RIGHT);
            }
            else if(keyCode == DOWN)
            {
                game.move(Direction.DOWN);
            }
            else if(keyCode == LEFT)
            {
                game.move(Direction.LEFT);
            }
            else if(key == 'r' || key == 'R')
            {
                game.reset();
            }
        break;
        case TRAIN:

        break;
        case RUN:
            if(key == 'r' || key == 'R')
            {
                game.reset();
            }
        break;
        case GENERATIONS:
            if(key >= 48 && key <= 57) //Check if character is a number
            {
                generationsToTrain = generationsToTrain * 10 + key - 48;
            }
            else if(keyCode == BACKSPACE)
            {
                if(generationsToTrain == 0) gameState = GameState.MENU;
                else generationsToTrain /= 10;
            }
            else if((keyCode == ENTER || keyCode == RETURN) && generationsToTrain != 0)
            {
                gameState = GameState.TRAIN;
            }
        break;
        case INPUT:

        break;
        case HELP:
        
        break;
        default:

        break;
    }
}

void mousePressed()
{
    if(gameState == GameState.MENU)
    {
        if(play.mouseOver())
        {
            gameState = GameState.PLAY;
            game.reset();
        }
        else if(train.mouseOver())
        {
            gameState = GameState.GENERATIONS;
            population.reset(columns, rows);
        }
        else if(run.mouseOver())
        {
            gameState = GameState.INPUT;
            selectInput("Select a Network File", "fileSelected", new File(path));
        }
        else if(help.mouseOver())
        {
            gameState = GameState.HELP;
        }
    }
    else if(gameState == GameState.PLAY)
    {
        int zoneSize = 300;

        if(mouseY < zoneSize && mouseX > zoneSize && mouseX < width - zoneSize)
        {
            game.move(Direction.UP);
        }
        else if(mouseY > width - zoneSize && mouseX > zoneSize && mouseX < width - zoneSize)
        {
            game.move(Direction.DOWN);
        }
        else if(mouseX < zoneSize && mouseY > zoneSize && mouseY < height - zoneSize)
        {
            game.move(Direction.LEFT);
        }
        else if(mouseX > width - zoneSize && mouseY > zoneSize && mouseY < height - zoneSize)
        {
            game.move(Direction.RIGHT);
        }
    }
}

void outSelected(File output)
{
    if(output == null)
    {
        gameState = GameState.MENU;
        return;
    }
    path = output.getAbsolutePath();
    population.best.output(output.getAbsolutePath());
    generationsToTrain = 0;
}

void fileSelected(File input)
{
    if(input == null)
    {
        gameState = GameState.MENU;
        return;
    }
    path = input.getAbsolutePath();
    Dna dna = new Dna(input.getAbsolutePath());
    network = new Network(dna);

    game.reset();

    gameState = GameState.RUN;
}