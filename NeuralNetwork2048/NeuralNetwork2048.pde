import java.util.ArrayList;
import java.io.*;

Population population;

void setup()
{
    size(800, 700);
    frameRate(30);

    int columns = 4;
    int rows = 4;

    setupSigmoidValues();

    population = new Population(4, 4);
}

void draw()
{
    background(230);
    
    if(population.generationCount < 1000)
    {
        population.run();
        population.update();

        println("Best so Far: " + sqrt(population.best.fitness));
    }
    population.show(width / 2, height / 2);
}

void keyPressed()
{

}