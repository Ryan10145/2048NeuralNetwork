import java.util.ArrayList;
import java.io.*;

Game game;
Population population;
Network network;
Button play;
Button train;
Button run;

int gameState = 0; //0 - main, 1 - play, 2 - train, 3 - run, 4 - how many generations to train, 5 - select input
int generationsToTrain;
String output;

void setup()
{
    size(800, 700);
    frameRate(30);

    int columns = 4;
    int rows = 4;

    setupSigmoidValues();

    game = new Game(4, 4, 2, 80);
    population = new Population(4, 4);

    play = new Button("Play 2048", width / 2 - 110, height / 2 - 100, 220, 60,
        color(153, 255, 255), color(133, 235, 235));
    train = new Button("Train a Neural Network", width / 2 - 130, height / 2, 260, 60,
        color(153, 255, 255), color(133, 235, 235));
    run = new Button("Run a Trained Neural Network", width / 2 - 150, height / 2 + 100, 300, 60,
        color(153, 255, 255), color(133, 235, 235));

    generationsToTrain = 0;
}

void draw()
{
    background(230);

    switch(gameState)
    {
        case 0:
            play.show();
            train.show();
            run.show();
        break;
        case 1:
            game.update();
            game.draw(width / 2, height / 2);
        break;
        case 2:
            if(population.generationCount < generationsToTrain)
            {
                for(int i = 0; i < 5; i++) population.run();
                population.update();
            }
            else
            {
                population.best.output("best.txt");
            }

            textAlign(CENTER, CENTER);
            textSize(20);
            text("Best so Far: " + sqrt(population.best.fitness / 5.0), width / 2, height * 2 / 3.0);
            text("Current Generation: " + population.generationCount, width / 2, height * 2 / 3.0 + 30);
            text("Target Generation: " + generationsToTrain, width / 2, height * 2 / 3.0 + 60);
            population.show(width / 2, height / 4);
        break;
        case 3:
            if(frameCount % 10 == 0)
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
        break;
        case 4:
            fill(0);
            textSize(40);
            textAlign(CENTER, CENTER);
            text("Generations To Train", width / 2, height / 2 - 100);
            text(generationsToTrain, width / 2, height / 2);
        break;
        case 5:
            selectInput("Select a Network File", "fileSelected");
            break;
        default:

        break;
    }
}

void keyPressed()
{
    if(gameState != 4 && keyCode == BACKSPACE)
    {
        gameState = 0;
    }

    switch(gameState)
    {
        case 0:

        break;
        case 1:
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
        case 2:

        break;
        case 3:

        break;
        case 4:
            if(key >= 48 && key <= 57) //Check if character is a number
            {
                generationsToTrain = generationsToTrain * 10 + key - 48;
            }
            else if(keyCode == BACKSPACE)
            {
                if(generationsToTrain == 0) gameState = 0;
                else generationsToTrain /= 10;
            }
            else if(keyCode == ENTER || keyCode == RETURN)
            {
                gameState = 2;
            }
        break;
    }
}

void mousePressed()
{
    if(gameState == 0)
    {
        if(play.mouseOver())
        {
            gameState = 1;
        }
        else if(train.mouseOver())
        {
            gameState = 4;
        }
        else if(run.mouseOver())
        {
            gameState = 5;
        }
    }
}

void fileSelected(File input)
{
    Dna dna = new Dna(input.getAbsolutePath());
    network = new Network(dna);

    game.reset();

    gameState = 2;
}