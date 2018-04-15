import java.util.ArrayList;
import java.io.*;

Game game;
Population population;
Button play;
Button train;
Button run;

int gameState = 0; //0 - main, 1 - play, 2 - train, 3 - run, 4 - select how many generations to train
int generationsToTrain;

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

        break;
        case 3:

        break;
        case 4:
            fill(0);
            textSize(40);
            textAlign(CENTER, CENTER);
            text("Generations To Train", width / 2, height / 2 - 100);
            text(generationsToTrain, width / 2, height / 2);
        break;
        default:

        break;
    }
    
    // if(population.generationCount < 1000)
    // {
    //     for(int i = 0; i < 5; i++) population.run();
    //     population.update();

    //     println("Best so Far: " + sqrt(population.best.fitness / 5.0));
    // }
    // else
    // {
    //     population.best.output("best.txt");
    // }
    // population.show(width / 2, height / 2);
}

void keyPressed()
{
    if(keyCode == ESC)
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
                generationsToTrain /= 10;
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
            gameState = 3;
        }
    }
    else if(gameState == 4)
    {
        if(train.mouseOver()) gameState = 2;
    }
}